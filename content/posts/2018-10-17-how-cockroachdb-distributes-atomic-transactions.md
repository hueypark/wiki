---
layout: post
title: (번역) 카크로치디비(CockroachDB) 블로그 / CockroachDB의 분산처리, 아토믹 트랜잭션은 어떻게 동작하는가
date: 2018-10-17
tags: ["cockroachdb"]
---

원문: https://www.cockroachlabs.com/blog/how-cockroachdb-distributes-atomic-transactions/

<!--more-->

Written by [Matt Tracy](https://www.cockroachlabs.com/author/matt-tracy/) on Sep 2, 2015

CockroachDB의 주요기능 중 하나는 분산 데이터베이스의 임의의 키에서 [ACID 트랜잭션](https://en.wikipedia.org/wiki/ACID_(computer_science))을 완벽하게 지원하는 것입니다. CockroachDB 트랜잭션은 핵심속성을 유지하면서(원자성, 일관성, 격리성, 지속성) 데이터베이스에 일련의 작업을 합니다. 이 글에서는 CockroachDB가 잠금을 사용하지 않고 **원자** 트랙잭션을 수행하는 방법에 대해 알아보겠습니다.

**원자성**은 다음과 같이 정의됩니다:

> 데이터베이스 명령어의 그룹이 실행되면, 모든 명령이 적용되거나 하나도 적용되지 않습니다.

원자성이 없으면, 인터럽트된 트랜잭션은 의도한 변경사항의 일부만 적용할 수 있습니다. 이것은 데이터베이스가 일관성 없는 상태로 남을 여지를 줍니다.

### 전략

원자 트랜잭션을 제공하기 위해 CockroachDB가 사용하는 전략은 다음 기본 단계를 따릅니다.

1. **스위치**: 어떤 키의 값을 수정하기 전에, 트랜잭션은 변경되는 실제 값과 구별되는 쓰기 가능한 값인 스위치를 만듭니다. 스위치에는 동시에 접근할 수 없습니다. 스위치의 읽기 및 쓰기는 엄격히 순차적으로 실행됩니다. 스위치는 초기에 `꺼짐` 상태이며, `켜짐` 상태로 스위치 할 수 있습니다.

2. **스테이지**: 데이터베이스 대한 변경사항을 준비하지만, 기존 값을 덮어쓰지는 않습니다. 새 값이 기존 값에 근접하여 스테이지됩니다.

3. **필터**: 스테이지된 값이 있는 경우, 해당 키에 대한 읽기는 값을 반환하기 전 트랜잭션의 스위치 상태를 확인합니다. 만약 스위치가 `꺼짐`이면, 기존 값을 반환합니다. 스위치가 `켜짐`이라면 스테이지된 값을 반환합니다. 따라서 스테이지 된 값이 있는 키의 모든 읽기는 스위치 상태를 통해 필터됩니다.

4. **플립**: 트랜잭션의 모든 변경사항이 준비되면 스위치를 `켜짐` 상태로 전환합니다. 필터링과 함께 트랜잭션의 일부로 준비된 모든 값은 이후의 읽기에서 즉시 반환됩니다.

5. **언스테이지**: 트랜잭션이 완료되면(중단되거나 커밋되면), 즉시 스테이지된 값이 가능한 빨리 정리됩니다. 트랜잭션이 성공하면 기존 값이 준비된 값으로 대체됩니다. 실패하면 준비된 값은 무시됩니다. 언스테이징은 비동기식으로 완료되며 트랜잭션이 커밋된 것으로 간주되기 전에 완료할 필요가 없음을 참고하십시오.

### 상세한 트랜잭션 절차

**스위치: CockroachDB 트랜잭션 기록**

트랜잭션을 시작하려면, 먼저 **트랜잭션 레코드**를 만들어야 합니다. 트랜잭션 레코드는 CockroachDB가 **스위치**를 제공하는 데 사용됩니다.

각 트랜잭션 레코드에는 다음 필드가 있습니다:

* 트랜잭션을 구분가능한 **고유한 식별자**(UUID) 
* 현재 **상태**: `PENDING`, `ABORTED`, `COMMITTED`
* cockroach K/V **키**, 분산 데이터 저장소에서 `스위치`의 위치를 결정합니다.

`PENDING` 상태의 새로운 UUID를 사용하여 레코드를 생성합니다. 그런 다음 CockroachDB의 `BeginTransaction()`을 사용하여 트랜잭션 레코드를 저장합니다. 그 레코드는 트랜잭션 레코드의 키에 함께 배치됩니다.(즉, 분산 시스템의 동일한 노드에 있습니다.)

레코드가 하나의 cockroach 키에 저장되기 때문에, 그것에 대한 작업은 엄격히 순차적으로 실행됩니다.(Raft와 스토리지 엔진의 조합으로 인해 가능합니다.) 트랜잭션의 **상태**는 스위치의 `켜짐/꺼짐` 상태이며 `PENDING` 또는 `ABORTED` 상태는 `꺼짐`을, `COMMITTED`는 `켜짐`을 나타냅니다. 따라서 트랜잭션 레코드는 스위치의 요구사항을 충족시킵니다.

트랜잭션 상태는 `PENDING`에서 `ABORTED` 또는 `COMMITTED`로 변경될 수 있지만, 다른 방법으로 변경될 수는 없습니다.(즉, `ABORTED`와 `COMMITTED`는 영구 상태입니다.)

**스테이지: Write Intent**

트랜잭션에서 변경을 **스테이지**하기 위해 CockroachDB는 **write intent**라고 하는 자료구조를 사용합니다. 값이 트랜잭션의 일부로 키에 기록될 때마다 write intent로 기록됩니다.

이 write intent 자료구조에는 트랜잭션이 성공할 경우 기록될 값이 들어있습니다.

또한 write intent에는 트랙잭션 레코드가 저장된 키도 포함됩니다. 이것은 읽기 작업시 write intent를 발견하면 이 값을 이용해 트랜잭션 레코드(스위치)를 찾을 수 있기 때문에 중요합니다.

마지막으로, 모든 키는 단 하나의 write intent를 가집니다. 만약 동시에 여러개의 트랜잭션이 있는 경우 한 트랜잭션이 다른 활성화된 intent를 가진 트랜잭션에 쓰기 시도를 할 수 있게 됩니다. 그러나 트랜잭션 동시성은 복잡한 내용이며 나중에 다른 글에서 다시 설명(트랜잭션 격리에 대해)하겠습니다. 지금은 한 번에 하나의 트랜잭션만 있다고 가정하며, 이미 존재하는 트랜잭션의 write intent는 폐기하겠습니다.

이미 write intent가 있는 키에 쓰는 경우:

1. 기존 intent에 대한 트랜잭션 레코드가 `PENDING` 상태인 경우 `ABORTED` 상태로 변경합니다. 이전 트랜잭션이 `COMMITTED` 또는 `ABORTED`인 경우 아무 작업도 하지 않습니다.
2. 이전 트랜잭션에서 기존 intent를 정리하고, 제거합니다.
3. 현재 트랜잭션에 새 intent를 추가합니다.

**필터: Intent를 읽기**

키를 읽을 때, 스위치의 상태를 참조하여 값을 반환하기 전에 세가지 원칙을 꼭 따라야 합니다.

만약 키가 일반 값이면(write intent가 없다면), 키와 관련된 진행중인 트랜잭션이 없고, 가장 최근 커밋된 값이 있음을 알 수 있습니다. 따라서 값은 그대로 반환됩니다.

그러나 write intent를 만난다면, intent를 제거하기 전에 트랜잭션이 취소되었다는 것을 의미합니다.(한 번에 하나의 트랜잭션만 있다고 가정 중입니다.). 따라서, 읽기 작업을 계속하기 전에 트랜잭션의 스위치(트랜잭션 레코드) 상태를 확인해야 합니다.

1. 만약 트랜잭션 레코드가 `PENDING` 상태라면 `ABORTED`로 변경합니다.
2. 이전 트랜잭션에서 기존 intent를 정리하고, 제거합니다.
3. 키의 일반 값을 반환합니다. 이전 트랜잭션이 `COMMITTED`인 경우 정리 작업은 스태이지 된 값을 일반 값으로 업그레이드 합니다. 그렇지 않다면 트랜잭션 이전의 기존 값을 반환합니다.

**플립: 트랜잭션을 커밋하기**

트랜잭션을 커밋하기 위해, 트랜잭션 레코드는 `COMMITTED` 상태로 갱신됩니다.

트랜잭션에 의해 작성된 모든 write intent는 즉시 유효해집니다. 이 트랜잭션에 대한 이후의 읽기는 트랜잭션 레코드를 필터하여 커밋되었음을 확인하고, intent에 스테이지 된 값을 반환합니다.

트랜잭션 중단

트랜잭션의 상태를 `ABORTED`로 변경하에 트랜잭션을 중단할 수 있습니다. 이 시점에서 트랜잭션은 영구적으로 중단되고 이후 읽기는 이 트랜잭션에 의해 작성된 write intent를 무시합니다.

**언스테이지: intent 정리**

위의 시스템은 이미 원자성 커밋 속성을 제공합니다. 하지만 분산 시스템에 대한 트랜잭션 레코드 쓰기가 필요하기 때문에 필터 비용은 비쌉니다. 이는 분산 시스템에서 바람직하지 않은 동작입니다.

그러므로, 트랜잭션이 완료된 후 가능한 한 빨리 작성된 write intent를 제거합니다. 키에 write intent가 없는 일반 값이 있으면 읽기 작업을 필터될 필요가 없고 적절히 분산되어 처리됩니다.

정리 작업

연관된 트랜잭션이 `PENDING` 상태가 아니면 write intent는 정리작업을 할 수 있습니다. 이는 다음 단계를 따릅니다:

* 트랜잭션이 `ABORTED`이면, write intent는 제거됩니다.
* 트랜잭션이 `COMMITTED`이면, write intent의 스테이지된 값은 기본 값을 대체하고 제거됩니다.
* 정리작업은 멱등입니다. 즉, 두 프로세스가 동일한 키와 트랜잭션에 대한 intent를 정리하려고 하면 두 번째 작업은 아무 작업도 수행하지 않습니다.

정리는 다음과 같은 경우에 수행됩니다:

* 쓰기작업이 트랜잭션을 커밋하거나 중단한 후, 즉시 모든 intent를 정리합니다.
* 쓰기작업이 이전 트랜잭션의 다른 write intent를 만났을 때.
* 읽기작업이 이전 트랜잭션의 write intent를 만났을 때.

만료된 write intent를 여러 경로를 통해 적극적으로 정리함으로써, 필터링으로 발생되는 성능영향이 최소화됩니다.

### 마무리

이 글을 통해, CockroachDB의 원자성을 보장하기 위한 기본 전략을 확인했습니다.

하지만 여기서 다루었던 것보다 더 많은 이야기가 있습니다. CockroachDB는 중복되는 키 세트에 쓸 수 있는 동시 트랜잭션을 지원합니다. 중복되는 동시 트랜잭션을 허용하는 것은 ACID에서 `I`이며 격리성을 보장합니다. 향후 글에서 격리성을 수행하는 방법에 대해 자세히 설명할 것입니다. 계속 지켜봐 주십시오!