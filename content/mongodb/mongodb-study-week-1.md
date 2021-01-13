---
title: "MongoDB 스터디 1주차(MongoDB 기초)"
date: "2021-01-10"
tags: ["MongoDB"]
---

### 들어가며

지금까지 필요 없는 로그성 데이터를 MongoDB에 저장한 경험이 있으며, 대부분은 RDBMS를 사용했습니다. MongoDB도 많이 발전하였고(트랜잭션, 컨시스턴시 관련) 우리의 MongoDB 운영능력도 증가했기 떄문에 애플리케이션에서 스케일아웃을 핸들링하지 않고 MongoDB를 사용해 개발속도를 향상시키고 싶습니다.

### MongoDB란

도큐먼트를 기본 자료형으로 사용하는 NoSQL 데이터베이스

### 도큐먼트와 컬렉션

- 도큐먼트
    - 도큐먼트는 field와 value의 쌍으로 데이터를 저장하고 관리
    - JSON 형태로 사용되며 실제로는 BSON으로 시리얼라이즈되어 저장됨

``` json
{
    "name" : "hueypark",
    "title" : "software engineer"
}
```

- 컬렉션
    - 도큐먼트들이 모여있는 집합
    - 일반적으로 한 컬렉션에 있는 도큐먼트들은 공통된 필드를 가지고 있음

### BSON

BSON은 바이너리로 시리얼라이즈 된 JSON

- 용량이 최적화되게 디자인되었으며, 많은 상황에서 JSON보다 더 효율적
- 인코드, 디코드 속도가 빠르게 디자인되었음
    - 예를 들어 integer 타입의 경우 문자열로 부터 파싱하지 않습니다. 이로 인해 JSON에 비해 더 적은 용량을 사용하고 더 빠르게 동작합니다.
- BinData나 Date와 같은 데이터 타입을 추가로 사용할 수 있음

### 주요 기능

- 고성능
- 풍부한 쿼리 언어
- 고가용성
    - 자동 페일오버
    - 데이터를 중복으로 적제하여 일부 노드에 손실이 있더라도 복구가능
- 수평확장
    - 클러스터 네 여러 노드에 걸친 샤딩
    - 3.4 버전부터 샤드 키에 기반한 존 설정 가능
        - 데이터를 원하는 샤드에 저장
        - 관련 있는 데이터를 물리적으로 가까운 샤드에 모을 수 있음
        - 하드웨어 또는 성능 기반으로 데이터를 라우팅 할 수 있음
- 다양한 스토리지 엔진 지원
    - WiredTiger
    - In-Memory Storage Engine

### 전통적인 RDBMS와 차이점

- SQL을 지원하지 않음
- 스케일 아웃 가능함
- 이벤츄얼 컨시스턴시

### MongoDB Atlas

- MongoDB를 DBaaS 제공하는 클라우드 서비스
- AWS, Azure, Google Cloud를 설정할 수 있는 풀 매니지드 데이터베이스
- 아쉽게도 아직 한국 리전은 선택이 불가능함
- Free tier가 무제한 무료(3서버 레플리카 셋, 512MB)

### 레퍼런스

- MongoDB University의 [M001 MongoDB Basics](https://university.mongodb.com/courses/M001/about)
- 공식문서의 [MongoDB 소개](https://docs.mongodb.com/manual/introduction)

### 더 알아보고 싶은 것

1. 트랜잭션의 동작방식과 제한사항(스트롱 컨시스턴시를 지원하는가?)
2. C++ Driver의 생산성
3. 데이터 모델링 방법([M320 - Data Modeling, Later Chapters](https://university.mongodb.com/))
4. _id 를 논리적 ID로 사용해도 될까?
5. 몽고디비 아틀라스는 쓸 만할까?
6. 퍼포먼스...
7. 여러 리전에 걸친 배포는 가능한가?(Zone?)
8. Update가 동작하는 방식(디스크에 쓰이는 데이터를 기준으로)courses/M320/about))
9. Community와 Enterprise 버전 차이점

### 흥미로운 점

[MongoDB 한국 트위터 대응](https://twitter.com/MongoDB/status/1349293682579660801)은 놀라울 정도로 빠르게 한국어 트윗에 응답하고 있습니다.
