---
title: "MongoDB 스터디 3주차(샤딩을 통한 시스템 확장)"
date: "2021-01-24"
tags: ["MongoDB"]
---

## 샤딩

샤딩은 여러 물리장비에 데이터를 분산하는 방법
MongoDB 는 샤딩을 이용해 매우 큰 데이터에 대해 높은 처리량을 제공

### 시스템을 확장하는 두 가지 방법

- 스케일업
- 스케일아웃(MongoDB 는 샤딩 통해 스케일아웃을 지원)

### 대상이 되는 자원

- CPU
- 네트워크
- 메모리
- 디스크

### 고려사항

경제적으로 이득인가?

실현가능한가?

#### 예 1)

- 서버의 CPU 자원에 한계가 다가오고 필요한 CPU 자원은 2배로 예상됨
- 다음으로 좋은 CPU는 처리량이 10배이고 비용도 10배임
- 스케일업을 한다면 10배의 비용으로 2배의 CPU만 사용
- 스케일아웃을 한다면 2배의 비용으로 2배의 CPU 사용가능

#### 예 2)

- 현재 사용가능한 가장 좋은 CPU를 사용 중 자원에 한계가 다가옴
- 스케일업으로 해결불가
- 스케일아웃으로 해결가능

#### 예 3)

- 디스크를 1TB 에서 20TB 로 20배 스케일업
- 백업, 복구, resync 에 20배의 시간이 듬
- 스케일아웃한다면 병렬화의 장점을 사용해 시간을 절약할 수 있음
- 또 MongoDB의 경우 큰 데이터는 큰 인덱스를 만들기 때문에 메모리 사용량도 함께 증가함

### 기타 장점

분산처리에 용이하기 때문에 MongoDB 에서 제공하는 존 샤딩, 어그리게이션 등의 기능을 효과적으로 사용가능

## 클러스터

- shard: mongod 레플리카 셋
- mongos: 클라이언트와 샤딩된 클러스터를 연결해주는 라우터
- config servers(CSRS): 샤딩 관련 메타데이터와 설정을 가지고 있는 서버

![](/mongodb/mongodb-study-week-3/sharded-cluster-production-architecture.bakedsvg.svg)

## 샤드 키

MongoDB 는 샤드에 샤드 키를 사용

샤드 키는 여러 필드로 구성될 수 있음

- 4.4 버전부터 필드 값이 없는 샤드 키로 사용 가능
- 4.4 버전부터 [refineCollectionShardKey](https://docs.mongodb.com/manual/reference/command/refineCollectionShardKey/)로 suffix 확장 가능
- 4.2 버전부터 불변의 `_id` 가 아닐 경우 도큐면트의 키 필드 변경 가능

### 샤드 키 인덱스

샤딩을 위해서는 샤드 키가 될 인덱스가 필요

### 샤드 키 설정 전략

#### Cardinality

높은 Cardinality = 샤드 키가 유니크한 값을 많이 가짐

- 요일(7개)보다는 일(31개)이 더 높은 Cardinality

#### Frequency

높은 Frequency = 중복이 적은가

- 도시 이름으로 설정했는도 모두 서울이면 낮은 Frequency

#### Monotonic Change

단조롭게 변하지 않는가?

기본 `_id` 나 `date` 와 같이 한 방향으로 꾸준하게 변하면 청크에 데이터가 몰리게 되므로 적합하지 않음

### Hashed Shard Key

Monotonic Change 가 있는 키를 사용 할 때 적용하면 키를 분산시킬 수 있음

- 하지만 range 쿼리를 할 때 모든 샤드에 브로드케스트 해야 하는 단점이 있음

## 존(Zone)

여러 데이터 센터에 걸쳐 샤딩된 클러스터에서 설정하여 데이터 로컬리티를 높일 수 있음

샤드키 기반으로 존을 설정하며 하나 이상의 샤드 키 구간을 설정가능

![](/mongodb/mongodb-study-week-3/sharding-segmenting-data-by-location-architecture.bakedsvg.svg)

## 청크

샤드된 데이터를 청크 단위로 나누어 저장

청크는 할당된 샤드 키의 구간으로 설정

### 청크 스플릿(Chunk Split)

청크가 설정된 값보다 커지거나, 도큐먼트의 수가 마이그레이트를 위한 최대 값까지 증가하면 샤드 키 기반으로 스플릿 함

Insert 나 Update 명령이 스플릿을 트리거함

![](/mongodb/mongodb-study-week-3/sharding-splitting.bakedsvg.svg)

### 청크 마이그레이션(Chunk Migration)

수동, 또는 자동(밸런서를 이용해)으로 샤드 간 청크를 이동시킴

![](/mongodb/mongodb-study-week-3/sharding-migrating.bakedsvg.svg)

### 점보 청크(Jumbo Chunk)

특정 크기 이상으로 청크가 커지면 스플릿 할 수 없는 점보 청크가 됨

단일 샤드 키에 너무 많은 데이터가 들어갔을 때 흔히 발생하며, 보틀넥이 되기 쉬우므로 주의 필요

## 클러스터 밸런서

백그라운드에서 청크와 샤드를 모니터링하는 프로세스

청크의 수가 임계치에 도달하면 샤드 간 청크 수를 동일하게 하기 위한 마이그레이션을 실행

밸런싱이 진행되는 동안 약간의 성능 저하가 있을 수 있지만, 애플레이션 계층에 영향을 주지 않음

밸런서는 config servers 의 프라이머리에서 실행됨

### 마이그레이션 절차

1. 밸런서는 [moveChunk](https://docs.mongodb.com/manual/reference/command/moveChunk/#dbcmd.moveChunk) 명령을 출발 샤드에 내림
2. 출발 샤드는 [moveChunk](https://docs.mongodb.com/manual/reference/command/moveChunk/#dbcmd.moveChunk) 명령을 수행함. 마이그레이션 진행동안 다른 명령은 출발 샤드에 라우트됨
3. 도착 샤드는 새로 필요해진 인덱스를 생성
4. 도착 샤드는 도큐먼트 복사본을 받기 시작
5. 청크의 마지막 도큐먼트를 받은 후, 도착 샤드는 마이그레이션 중 발생한 변경사항에 대한 동기화 프로세스를 진행
6. 모두 동기화 되면, 출발 샤드는 [config database](https://docs.mongodb.com/manual/reference/glossary/#term-config-database) 에 연결해 새로운 청크의 위치로 클러스터 메타데이터를 갱신함
7. 출발 샤드가 메타데이터를 갱신하고, 열려 있는 커서가 하나도 없으면 출발 샤드는 필요없어진 도큐먼트를 지움

## Config Servers(CSRS)

클러스터의 메타데이터를 가지는 설정 서버 레플리카 셋

모든 샤드에 있는 청크(샤드 키를 포함해)의 범위를 가지고 있음

`mongos` 는 이 데이터를 캐시하여 일기/쓰기 명령을 필요한 샤드에 라우트함

`mongos` 는 [샤드 추가](https://docs.mongodb.com/manual/tutorial/add-shards-to-shard-cluster/)나 [청크 스플릿](https://docs.mongodb.com/manual/core/sharding-data-partitioning/#sharding-chunk-splits) 과 같은 변경이 발생하면 이 캐시를 업데이트함

각 샤드도 config servers 에서 메타데이터를 읽음

인증과 권한 관련 정보가 저장되며, 분산 락 관련 기능도 관리됨

각 샤딩된 클러스터는 개별 config server 를 필요로 함(하나의 config server를 여러 클러스터에 공용으로 쓰지 말 것)

- 운영 명령어를 config servers 에 사용하는 것은 성능과 가용성에 큰 영향을 줌

### Configs Servers Replica Set

3.2 버전부터 configs server 는 레플리카 셋으로 배포되어 일반적인 레플리카 셋의 장점을 가지게 됨(`3.4 버전부터 지원되지 않는 three mirrored config server(SCCC) 대신`)

- 아비터 사용할 수 없음
- [지연된 멤버](https://docs.mongodb.com/manual/core/replica-set-delayed-member/) 사용할 수 없음
- 인덱스를 사용해야함(`buildIndexes` false 로 설정 불가)

### Config Server Availability

Primary 를 잃어버리고 선출하지 못할 때, 클러스터 메타데이터는 읽기 전용이 되지만 샤드에 쓰고 읽는 작업은 수행 가능하지만, 청크 마이그레이션이나 스플릿 작업은 수행할 수 없음

모든 configs server 가 사용불능이 되면 샤드도 복구할 수 없으므로 백업 구성이 중요함(config server 데이터는 상대적으로 적고 부하가 크지 않음)

* 중요: 운영 관련 작업을 하기 전 `config` 데이터베이스를 항상 백업 할 것

## mongos

`mongos` 는 읽기/쓰기 요청을 각 샤드에 라우트함

클라이언트는 각 샤드에 직접 접속하면 안 됨

가장 일반적인 방법은 애플리케이션 서버와 동일한 시스템에 `mongos` 인스턴스를 배포하는 것이며 별도의 시스템을 사용할 수 도 있음

### Targetd Queries vs Scatter Gather

샤드 키로 특정할 수 있으면 쿼리는 대상 샤드에만 라우트되고, 불가능하면 모든 샤드에 보낸 후 결과를 받아서 합침

샤드 키 순서는 중요하며, 앞 쪽에 있는 키가 쿼리 조건에 포맣되지 않으면 모든 샤드에 보낼 수 밖에 없음

예) 샤드 키가 `{ a: 1, b: 1 }` 경우 `{ b: 1 }` 조건으로는 Targetd Query 를 할 수 없음

## 기타

### hedged read

4.4 버전부터 읽기 요청시 두개의 레플리카 셋 맴버에게 라우트 해서 먼저 도착하는 쪽의 응답을 클라이언트에 전달함

### FCV Compatibility

4.0 버전부터 `mongod` 보다 낮은 버전의 `mongos` 를 쓸 수 없음

## 레퍼런스

- 공식문서 중 [Sharding](https://docs.mongodb.com/manual/sharding/)
- MongoDB University의 [M103 Basic Cluster Administration](https://university.mongodb.com/courses/M103/about)
