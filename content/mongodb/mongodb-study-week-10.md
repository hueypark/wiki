---
title: "MongoDB 스터디 10주차(트랜잭션)"
date: "2021-03-26"
tags: ["MongoDB"]
---

# 트랜잭션

몽고디비는 4.0버전(2018년)부터 여러 도큐먼트에 대한 트랜잭션을, 4.2버전(2019년) 부터는 샤딩된 컬렉션에 대한
분산 트랜잭션을 지원하고 있습니다.

여러 도큐먼트에 대한 ACID 트랜잭션 지원은 다양한 상황에서 개발자가 쉽게 대응할 수 있게 합니다. 스냅샷 격리수준과
아토믹한 실행은 샤딩된 클러스터에서도 트랜잭션이 필요한 워크로드를 제어할 수 있게 합니다.

- In version 4.0, MongoDB supports multi-document transactions on replica sets.
- In version 4.2, MongoDB introduces distributed transactions, which adds support for multi-document transactions on sharded clusters and incorporates the existing support for multi-document transactions on replica sets.

> IMPORTANT: 대부분의 경우 멀티 도큐먼트 트랜잭션은 큰 부하를 일으키며, 효율적인 스키마를 대체하지 않아야 합니다.
대부분의 시나리오에서 비정규화된 데이터 모델(임베디드 도큐먼트 또는 배열)로 최적화 가능합니다.

## Read Preference

여러 도큐먼트에 대한 트랜잭션은 `read preference` `primary` 를 사용해야만 합니다.

## Read Concern

트랜잭션 내에서는 트랜잭션의 `read concern` 이 적용됩니다.

### local

- 접근 가능한 노드에서 롤백 가능성이 있는 최신 데이터를 받아옵니다
- 샤딩된 클러스터에서 트랜잭션의 경우 여러 샤드가 같은 스냅샷을 사용하는 것을 보장하지 않습니다. 보장이 필요하면 `snapshot` 을 사용하십시오.
- 4.4 이상 버전에서는 트랜잭션 내에서 컬렉션이나 인덱스를 만들 수 있습니다. 명시적으로 생성할 경우 `local` 을 사용해야
하고 암시적으로 생성할 경우에는 다른 `read concern` 을 사용해도 됩니다.

### majority

- 트랜잭션이 `write concern` `majority` 로 커밋했다면 레플리카 셋의 과반이 동의한 데이터를 반환합니다.
- `write concern` `majority` 아닌 커밋에 대해 `read concern` `majority` 는 과반이 동의한 데이터 반환을 보장하지 않습니다.
- 샤딩된 클러스터에서 트랜잭션의 경우 여러 샤드가 같은 스냅샷을 사용하는 것을 보장하지 않습니다. 보장이 필요하면 `snapshot` 을 사용하십시오.

### snapshot

- 트랜잭션이 `write concern` `majority` 로 커밋했다면 레플리카 셋의 과반이 동의한 데이터를 반환합니다.
- `write concern` `majority` 아닌 커밋에 대해 `read concern` `majority` 는 과반이 동의한 데이터 반환을 보장하지 않습니다.
- 샤딩된 클러스터에서 데이터가 클러스터에 걸쳐 동기화되었음을 보장합니다.

## Transactions and Write Concern

트랜잭션 내에서 트랜잭션의 `write concern` 이 적용됩니다.

### w: 1

- 프라이머리에 커밋되면 트랜잭션이 응답합니다.
- 이 경우 `majority` 와 `snapshot` `read concern` 을 이용한 읽기는 과반이 동의한 데이터 반환을 보장받지 않습니다.

### w: majority

- 과반의 노드에 쓰기 작업이 적용되면 응답합니다.
- 이 경우 `majority` `read concern` 읽기는 과반이 동의한 데이터 반환을 보장합니다. 샤딩된 클러스터에서 전체 샤드에 동기화되었음을 보장하지는 않습니다.
- 이 경우 `snapshot` `read concern` 읽기는 과반이 동의한 데이터 반환을 보장합니다. 샤딩된 클러스터에서 전체 샤드에 동기화되었음을 보장합니다.

# 일반정보와 고려사항

## 아비터

여러 샤드에 걸쳐 쓰기 작업이 있는 트랜잭션의 경우 아비터가 포함된 샤드에 접근할 경우 실패합니다.

## Read Concern Majority 비활성화

PAS 레플리카 셋은 `majority` `read concern` 이 비활성되어 있을 수 있습니다.

- 샤딩된 클러스터
	- `majority` `read concern` 이 비활성화된 샤드에 트랜잭션이 적용될 때 `snapshot` 을 사용할 수 없습니다.
- 단일 레플리카 셋
	- `local`, `majority`, `snapshot` 모두 사용할 수 있습니다.

## 샤딩된 클러스터에 대한 설정 제한

[writeConcernMajorityJournalDefault](https://docs.mongodb.com/manual/reference/replica-configuration/#mongodb-rsconf-rsconf.writeConcernMajorityJournalDefault)
설정이 false 인 샤드를 가진 클러스터에서 트랜잭션을 사용할 수 없습니다.

## 스토리지 엔진

4.2 버전부터 프라이머리가 WiredTiger 이고, 세컨더리가 in-memory 인 경우에도 트랜잭션을 사용할 수 있습니다.

## 진행중인 트랜잭션과 쓰기충돌(Write Conflicts)

트랜잭션이 바꾸려고 시도하는 도큐먼트를 외부에서 먼저 변경하면, 트랜잭션은 실패합니다.

트랜잭션이 바꾸고 아직 커밋하지 않은 도큐먼트를 외부에서 변경하려 하면 외부의 쓰기작업은 대기합니다.

## 진행중인 트랜잭션과 스테일 리드(Stale Reads)

트랜잭션 내 읽기 작업은 스테일 데이터를 반환할 수 있습니다. 즉 트랜잭션 내부의 읽기는 외부 쓰기작업의 결과를 보는 것을
보장받지 못합니다.

## 진행중인 트랜잭션과 청크 마이그레이션

청크 마이그레이션 특정 단계에서 컬렉션 락을 설정합니다.

진행중인 트랜잭션이 컬렉션 락을 필요로 한다면, 청크 마이그레이션은 트랜잭션 종료를 기다리고 이는 성능에 영향을 줍니다.

만약 청크 마이그레이션이 트랜잭션에 영향을 주면(청크 마이그레이션 시작 후 트랜잭션이 시작되어 컬렉션 락을 요구하면),
트랜잭션은 중단됩니다.

## 커밋 중간의 외부 읽기

트랜잭션을 커밋하는 동안, 변경한 도큐먼트를 외부에서 읽을 수 있습니다. 만약 트랜잭션이 여러 샤드에 걸쳐 진행 중이라면:

- `snapshot` 또는 `linearizable` `read concern` 을 사용한 읽기 또는 `causally consistent sessions`([afterClusterTime](https://docs.mongodb.com/manual/reference/read-concern/#std-label-afterClusterTime) 설정을 사용한)
트랜잭션이 보일 때까지 대기합니다.
- 그 외의 경우는 트랜잭션의 모든 도큐먼트가 표시되길 기다리지 않고 사용가능한 이전 버전의 도큐먼트를 읽습니다.

## 백업과 복구

> WARNING: `mongodump` 와 `mongorestore` 를 사용한 백업은 트랜잭션의 원자성을 보장하지 않기 때문에 4.2버전 이상의 샤딩된 클러스터에서 백업용으로 사용할 수 없습니다.

이 떄는 다음 옵션을 고려하십시오.

- [MongoDB Atlas](https://www.mongodb.com/cloud/atlas?tck=docs_server)
- [MongoDB Cloud Manager](https://www.mongodb.com/cloud/cloud-manager?tck=docs_server)
- [MongoDB Ops Manager](https://www.mongodb.com/products/ops-manager?tck=docs_server)

## Multi-document transactions are atomic (i.e. provide an "all-or-nothing" proposition):

- 트랜잭션이 커밋되면, 모든 변경사항이 저장되고 트랜잭션 바깥에 공개됩니다. 트랜잭션이 커밋될 때까지 변경된 데이터는
외부에 공개되지 않습니다. 하지만 트랜잭션이 여러 샤드에 커밋 될 때에든 모든 샤드가 커밋될 때까지 기다리지는 않습니다.
예를 들어 트랜션이 커밋되고 `쓰기 1` 은 `샤드 A` 에 보이고, `쓰기 2` 는 `샤드 B` 에 보이지 않을 경우, 다른 읽기가 read
concern `local` 라면 `쓰기 1` 만 읽을 수 있습니다.
- 트랜잭션이 취소되면 모든 변경사항은 외부에서 보이지 않고 삭제됩니다.

## 스냅샷 격리수준과 쓰기 충돌(Snapshot Isolation and Write Conflicts)

도큐먼트를 변경할 때 트랜잭션은 도큐먼트에 락을 겁니다. 만약 트랜잭션이 락을 획득할 수 없으면(다른 트랜잭션이 락을
유지하고 있으면), 5ms 후에 쓰기 충돌과 함께 중단됩니다.

읽기에는 쓰기와 같은 잠금은 필요하지 않습니다. 물론 다른 트랜잭션에서 커밋되지 않은 상태의 값만 볼 수 있습니다.

## 트랜잭션 재시도(Retrying Transactions)

단기 트랜잭션 에러(transient transaction error)는 쓰기 충돌이 발생했으며, 다시 시도해도 안전함을 알립니다. 

# 참고자료

- 홈페이지 ACID Transactions in MongoDB: https://www.mongodb.com/transactions
- Path to Transactions - WiredTiger Timestamps: https://youtu.be/mUbM29tB6d8
- MongoDB 4.2 Brings Fully Distributed ACID Transactions (MongoDB World 2019 Keynote, part 2): https://youtu.be/iuj4Hh5EQvo
- Performance Best Practices: Transactions and Read / Write Concerns: https://www.mongodb.com/blog/post/performance-best-practices-transactions-and-read--write-concerns
- MongoDB 4 Update: Multi-Document ACID Transactions: https://www.mongodb.com/blog/post/mongodb-multi-document-acid-transactions-general-availability
