---
title: "MongoDB 스터디 7주차(MongoDB CURD 읽기 연산)"
date: "2021-02-27"
tags: ["MongoDB"]
---

# [db.collection.find()](https://docs.mongodb.com/manual/reference/method/db.collection.find/)

쿼리 기준과 일치하는 도큐먼트에 대한 커서를 반환합니다.

## 파라미터

- query: 필터에 사용할 쿼리 연산자입니다.
- projection: 도큐먼트에서 반환할 필드를 지정합니다. 생략하면 모든 필드가 반환됩니다.

# [db.collection.findOne()](https://docs.mongodb.com/manual/reference/method/db.collection.findOne/)

쿼리 기준과 일치하는 하나의 도큐먼트를 반환합니다.
여러 도큐먼트들이 쿼리를 만족하면 디스크에 저장된 순서에 따라 첫 도큐먼트를 반환합니다.
만약 대상이 없으면 null을 반환합니다.

# [Read Concern](https://docs.mongodb.com/manual/reference/read-concern/)

readConcern 옵션을 사용해 읽기 작업의 일관성과 격리수준, 가용성을 제어할 수 있습니다.

4.4 버전부터 기본값의 전역 설정이 가능합니다. 세부정보는 [setDefaultRWConcern](https://docs.mongodb.com/manual/reference/command/setDefaultRWConcern/#dbcmd.setDefaultRWConcern)에서 확인하십시오.

## Read Concern Levels

- local
	- 과반수에 기록되었음을 확인하지 않고 데이터를 반환합니다.(읽어온 데이터가 롤백될 수 있음)
	- 사용가능: `causally consistent session` 또는 트랜잭션에서 사용할 수 있습니다.
- available
	- 과반수에 기록되었음을 확인하지 않고 데이터를 반환합니다.(읽어온 데이터가 롤백될 수 있음)
	- 사용가능: `causally consistent session` 또는 트랜잭션에서 사용할 수 없습니다.
	- 샤딩된 클러스터에서 가장 낮은 레이턴시를 제공합니다. 하지만 샤드된 컬렉션에서 [orphaned document](https://docs.mongodb.com/manual/reference/glossary/#term-orphaned-document)를 반환할 수 있음을 유의하십시오.
- majority
	- 과반수에 기록된 데이터를 반환합니다.
	- 이를 충족하기 위해 각 레플리카 셋 멤버들이 메모리의 `majority-commit point` 반환해야 합니다. 따라서 위 두 설정에 비해 성능이 떨어집니다.
	- 사용가능:
		- `causally consistent session` 또는 트랜잭션에서 사용할 수 있습니다.
		- PSA 아키텍처를 사용할 때 이 설정을 쓰지 않게 설정할 수 있습니다. 하지만 이것은 Change Streams, 트랜잭션, 샤디드 클러스터에 영향을 줄 수 있습니다. 자세한 내용은 [Disable Read Concern Majority](https://docs.mongodb.com/manual/reference/read-concern-majority/#disable-read-concern-majority)에서 확인하십시오.
- linearizable
	- 읽기를 시작하기 전에 완료된 쓰기에 대한 데이터만 반환합니다. 쿼리가 결과를 반환하기 전에 레플리카 셋 전체에 결과가 전파되길 기다립니다.
	- 읽기 시작 후 레플리카 셋의 과반이 재시작되어도, 반환된 데이터는 유효합니다.(`writeConcernMajorityJournalDefault` 을 false 로 변경하면 아닐 수 있음)
	- 사용가능:
		- `causally consistent session` 또는 트랜잭션에서 사용할 수 없습니다.
		- 프라이머리 노드에만 설정할 수 있습니다.
	- 어그리게이션의 [$out](https://docs.mongodb.com/manual/reference/operator/aggregation/out/#pipe._S_out), [$merge](https://docs.mongodb.com/manual/reference/operator/aggregation/merge/#pipe._S_merge) 스테이지에서 사용할 수 없습니다.
	- 요구사항: 유니크하게 식별가능한 단일 도큐먼트에 읽기 작업에서만 보장됩니다.
- snapshot
	- 트랜잭션이 `causally consistent session` 이 아니고 Write concern 이 majority 인 경우, 트랜잭션은 과반이 커밋된 데이터의 스냅샷에서 읽습니다.
	- 트랜잭션이 `causally consistent session` 이고 Write concern 이 majority 인 경우, 트랜잭션 시작 직전에 과반이 커밋된 데이터의 스냅샷에서 읽습니다.
	- 사용가능:
		- 멀티 도큐먼트 트랜잭션에서만 사용가능합니다.
		- 샤딩된 클러스터 중 하나라도 [Disable Read Concern Majority](https://docs.mongodb.com/manual/reference/read-concern-majority/#disable-read-concern-majority) 설정을 할 경우 사용할 수 없습니다.

## [Causal Consistency](https://docs.mongodb.com/manual/core/read-isolation-consistency-recency/#causal-consistency)

뭔가 묘한 일관성 옵션입니다. 잘 찾아보면 활용할 만 한 특수한 사용처가 있을지도 모릅니다.

> Applications must ensure that only one thread at a time executes these operations in a client session.

> Operations within a causally consistent session are not isolated from operations outside the session.

# [Read Preference](https://docs.mongodb.com/manual/core/read-preference/)

MongoDB 클라이언트가 레플리카 셋의 어떤 멤버에서 데이터를 가져올지 설정합니다.

- primary
	- 기본 값
	- 모든 명령은 프라이머리에서 데이터를 가져옵니다.
- primaryPreferred
	- 프라이머리에서 데이터를 가져옵니다. 그럴 수 없을 경우 세컨더리에서 가져옵니다.
- secondary
	- 세컨더리에서 데이터를 가져옵니다.
- secondaryPreferred
	- 세컨더리에서 데이터를 가져옵니다. 그럴 수 없을 경우 프라이머리에서 가져옵니다.
- nearest
	- 계산된 레이턴시를 기반으로 적절한 노드에서 데이터를 가져옵니다.

# [db.collection.findAndModify()](https://docs.mongodb.com/manual/reference/method/db.collection.findAndModify/)

단일 도큐먼트를 변경 후 반환합니다.

`db.collection.findAndModify()` 와 `update()` 의 차이:

- 기본적으로 둘 다 단일 도큐먼트를 업데이트합니다. 그러나 `update()` 는 `multi` 옵션을 사용해 여러 문서를 업데이트 할 수 있습니다.

- 대상이 되는 도큐먼트가 다수일때 `findAndModify()` 는 `sort` 옵션을 사용해 대상을 선택할 수 있습니다.

- 기본적으로 `findAndModify()` 는 업데이트 전의 문서를 반환합니다. 업데이트 된 문서를 얻으려면 `new` 옵션을 사용하십시오. `update()` 는 작업 상태만 포함된 `WriteResult` 객체를 반환합니다. 업데이트 문서를 확인하려면 `find()` 명령을 사용하십시오(그 사이에 다른 업데이트에 의해 문서가 수정되었을 수 있습니다.).
