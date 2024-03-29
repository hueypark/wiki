---
layout: post
title: "(번역) 카크로치디비(CockroachDB) 블로그 / CockroachDB의 온라인 스키마 변경 원리"
date: 2018-10-26
tags: ["cockroachdb"]
---

원문: https://www.cockroachlabs.com/blog/how-online-schema-changes-are-possible-in-cockroachdb/

<!--more-->

Written by [Vivek Menezes](https://www.cockroachlabs.com/author/vivek-menezes/) on Jan 20, 2016

> 저에게는 정기적인 테이블 변경이 필요한데 대부분의 경우 컬럼 추가입니다. 명령 자체는 간단하지만 테이블에는 4천만 개의 로우가 있고 빠르게 증가 중입니다. 그래서 테이블 변경에는 수 시간이 걸립니다. 아마존 RDS를 사용하기 때문에 슬레이브를 이용해 작업한 후 마스터로 승격하는 방법도 사용할 수 없습니다. 다운타임을 최소화할 방법이 없을까요? 사용자가 데이터베이스를 이용할 수만 있다면 작업에 며칠이 걸려도 상관없습니다...
> -- `스택 오버플로우` `1`

위 질문은 2010년에 게시되었지만, 스키마 변경 다운타임에 대한 걱정은 여전히 존재합니다.

우리는 CockroachDB의 스키마 변경 엔진을 디자인할 때, 이 부분을 개선하고 싶었습니다. 테이블 스키마를 변경하는 간단한 방법을 제공하고, 다운타임을 포함한 부정적인 결과를 애플리케이션이 겪지 않게 하게 하려고 했습니다. 스키마 변경은 CockroachDB에 빌트인으로 포함되어 어떤 외부 툴, 자원, 특별한 작업이 필요하지 않기를 바랐습니다. 또 이 모든 것을 하면서도 애플리케이션의 읽기/쓰기 속도에는 영향을 주고 싶지 않았습니다.

이 글에서는 온라인 스키마 변경 전략을 설명하겠습니다. 컬럼과 인덱스 같은 스키마 요소의 변경을 다운타임 없이 관리하는 방법에 대해 알아보겠습니다.

### 우리가 하는 일

스키마 변경에는 스키마를 업데이트하고 변경과 관련된 테이블 데이터를 추가하거나 제거하는 작업이 포함됩니다. 다음 두 가지 분산 데이터베이스의 특성은 이를 더 까다롭게 합니다.

1. 고성능: 데이터베이스 성능을 최적화하려면 여러 노드에서 스키마를 캐시해야 합니다. 분산 캐시를 일관되게 유지하는 것은 어렵습니다.
2. 큰 테이블: 데이터베이스 테이블은 매우 클 수 있습니다. 스키마 변경과 관련된 테이블 데이터를 다시 채우거나 삭제하는 작업에는 시간이 걸리며, 데이터베이스 접근을 비활성화하지 않고 올바르게 수행하는 것은 어려운 일입니다.

우리는 일관성 있는 분산 스키마 캐시를 유지하고 여러 스키마 버전에서 일관된 테이블 데이터를 사용하기 위해, 새 스키마가 준비될 때까지 이전 버전의 사용을 허용합니다. 이로서 테이블의 잠금 없이 데이터를 추가하거나 삭제할 수 있습니다. 이 방법은 구글 F1팀의 작업을 참고한 것입니다.

### 안전한 스키마 롤아웃

스키마 요소(인덱스 또는 컬럼일 수 있으며, 이 글에서는 인덱스에 중점을 둠)는 SQL DML에 의해 삭제, 쓰기, 읽기가 가능합니다. CockroachDB는 새 인덱스를 롤아웃하기 위해 이러한 DML의 삭제, 쓰기, 읽기 기능을 하나씩 순차적으로 부여합니다.

새 인덱스는 아래 단계에 따라 추가됩니다.

1. 삭제 기능을 부여합니다.
2. 쓰기 기능을 부여합니다.
3. 인덱스를 채웁니다.
4. 읽기 기능을 부여합니다.

새 스키마에에는 이전에 부여된 모든 기능이 포함됩니다. 정확성을 위해, 모든 클러스터가 이전 기능을 부여받은 후 새 기능을 부여합니다. 따라서 프로세스는 각 단계 전에 일시 중지되며, 이전에 부여된 기능을 전체 클러스터에 전파한 후 다음 기능을 부여합니다.

인덱스 삭제는 역순으로 진행됩니다.

1. 읽기 기능을 폐지합니다.
2. 쓰기 기능을 폐지합니다.
3. 인덱스 데이터를 제거합니다.
4. 삭제 기능을 폐지합니다.

마찬가지로, 이전 폐지가 전체 클러스터에 전파된 후 다음 기능의 폐지가 진행됩니다.

#### 삭제 기능: 잘못된 인덱스 입력 방지

이 기능은 인덱스를 DELETE_ONLY 상태로 설정합니다. 이 기능을 사용하면 SQL DML은 아래와 같이 제한됩니다.

- DELETE는 로우와 함께 인덱스 데이터를 완전히 삭제할 수 있습니다.
- UPDATE는 오래된 인덱스를 삭제하지만, 새로운 것을 쓸 수는 없습니다.
- INSERT와 SELECT는 인덱스를 무시합니다.

다음 단계에서 인덱스에 대해 쓰기 기능이 부여된 노드는 전체 클러스터가 삭제 기능을 사용하고 있다고 신뢰할 수 있습니다. 따라서 INSERT 명령을 받아 인덱스를 추가해도 다른 노드가 DELETE로 인덱스를 올바르게 삭제할 수 있습니다. 이로서 잘못된 인덱스로 인한 오염을 피할 수 있습니다.

스키마 변경으로 인덱스가 삭제되면, 관련 인덱스 데이터는 클러스터에서 쓰기 기능을 폐지한 이후에 제거됩니다. 인덱스 데이터 제거 시점에 모든 클러스터에는 삭제 기능만 남아 있습니다.

#### 쓰기 기능: 인덱스 누락 방지

이 기능은 WRITE_AND_DELETE_ONLY 상태로 설정하여, 삭제 및 쓰기 기능을 부여합니다.

- INSERT, UPDATE, DELETE는 정상적으로 동작하며, 필요에 따라 인덱스를 추가하거나 삭제합니다.
- 반면 SELECT에는 읽기 기능이 필요하며 인덱스는 무시됩니다.

인덱스 채우기는 전체 클러스터가 쓰기 기능을 가진 후에 시작됩니다. 채우기가 진행 동안 들어온 INSERT 명령은 인덱스를 사용하여 새 로우를 생성하고, 별도의 다시 채우기 과정에 의존하지 않습니다. 그러므로 채우기 완료 후에는 빠진 인덱스가 없습니다.

#### 읽기 기능

이 기능은 인덱스를 활성화하여 모든 명령에 대한 인덱스 사용을 활성화합니다.

### 빠른 스키마 롤아웃

스키마 변경 프로세스 각 단계에 걸쳐 전체 클러스터가 최신 버전의 스키마로 수렴됩니다. 간단한 스키마 캐싱 매커니즘은 5분 정도의 TTL을 사용하지만, 최신 버전의 스키마 변경을 수 분간 기다리게 합니다. CockroachDB에서는 최신 스키마 버전으로 클러스터 수렴 속도를 높이기 위해 스키마 버전의 리스를 개발했으며, 이는 스키마 변경 속도를 빠르게 합니다.

SQL DML에 스키마를 사용하기 전에, 노드는 스키마의 유효한 읽기 리스를 상당한 시간(수분)동안 얻습니다. 업데이트된 버전이 활성화되면, 전체 클러스터로 브로드캐스트하여 알리고 이전 버전에 대한 리스를 만료하게 합니다. 만약 몇 노드가 불안정하여 리스를 만료하지 못하면 롤아웃은 만료될까지 기다리며 지연됩니다.

스키마 변경 전략은 다음 두 가지 규칙을 따르도록 함으로써 단순하게 유지됩니다:

- 새 리스는 마지막 버전의 스키마에만 적용됩니다.
- 유효한 리스는 최신 스키마 버전 두 개에만 있습니다.

테이블 리스에 대한 더 자세한 내용은 Github 저장소의 RFC를 참조하십시오.

### 신뢰할 수 있는 스키마 롤아웃

스키마 변경은 스키마 변경 SQL 명령을 실행하는 노드에 의해 완료됩니다. 변경은 장시간 실행될 수 있기 떄문에 수행하는 노드가 죽었을 때 다시 시작할 수 있어야 합니다. 모든 노드는 불안정한 스키마 변경을 실행할 수 있는 스키마 변경 고루틴을 가지고 있습니다. 스키마 변경을 실행하기 전 스키마 변경 고루틴은 먼저 독점적인 쓰기 리스를 획득하여 스키마 변경을 주도할 수 있는 유일한 권한을 획득합니다.

### 결론

CockroachDB에서는 온라인 스키마 변경을 쉽게 사용할 수 있으며, 스키마 변경 롤아웃 프로세스는 안전하고, 빠르며, 신뢰할 수 있습니다. 변화를 피할 방법은 없지만 이제 걱정하지 않아도 됩니다!

많은 영감을 준 [온라인 스키마 변경](https://ai.google/research/pubs/pub41376)을 공유해주신 구글의 F1 팀의 사람들에게 감사드립니다.

---

1. Apptree. Stack Overflow. "[Modifying columns of a very large mysql table with little or no downtime.](https://serverfault.com/questions/174749/modifying-columns-of-very-large-mysql-tables-with-little-or-no-downtime)" August 26, 2010.
