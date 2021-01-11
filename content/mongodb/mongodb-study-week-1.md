---
title: "MongoDB 스터디 1주차(MongoDB 기초)"
date: "2021-01-10"
tags: ["MongoDB"]
---

### MongoDB란?

- A database
- A NoSQL Database
    - row, column 이 없음
- NoSQL documentDB
- Stored in collections

MongoDB는 NoSQL Document Database 입니다.

### Document와 Collection?

Document: A way to organize and store data as a set of field-value pairs

``` json
{
    "name" : "hueypark",
    "title" : "software engineer"
}
```

Collection: An ogranized store of documents in MongoDB, usually with common fields between documents

### Atlas의 놀라운 프리티어 정책

- 3-server replica set
- 512MB storage
- Never expires

```bash
mongo "mongodb+srv://sandbox.nfd8b.mongodb.net/sample-airbnb" --username m001-student
```

### M320 - Data Modeling, Later Chapters

---

#### 특징

- Reliability
- Scalability
- Flexibility
- Index Support

#### 구조

- 도큐먼트
- 컬렉션
- 데이터베이스

#### 어떻게 사용하면 좋을까?

- 스키마가 없다는 것
- 정규화, 반정규화

#### 다른 데이터베이스와 비교

- RDBMS
- NoSQL


### 더 알아보고 싶은 것

1. 트랜잭션의 동작방식과 제한사항
2. C++ 클라이언트 인터페이스의 생산성
3. 몽고디비 아틀라스
4. GUI 관리자 툴
5. 퍼포먼스
6. 여러 리전에 걸친 배포
7. Community와 Enterprise 버전 차이점
8. Atlas(클라우드 데이터베이스 서비스)
