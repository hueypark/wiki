---
title: "MongoDB 스터디 11주차(데이터 모델링)"
date: "2021-04-07"
tags: ["MongoDB"]
---

# 고려사항

- 데이터 모델은 애플리케이션과 함께 변함
- 데이터 모델에 영향을 미치는 요소
	- 사용자의 요구사항
	- 읽기 및 쓰기 작업의 특성

# 모델링 순서

1. 애플리케이션 워크로드 측정
	- 데이터 사이즈
	- 중요도에 따라 작업을 목록화
2. 데이터와 데이터 간의 관계를 연결(CRD, Collection Relationship Diagram)
	- 링크할지 임베드 할지 결정
3. 각 컬렉션의 데이터 모델을 정리(디자인 패턴 적용)

# 임베딩 vs 링킹

## 1. 임베딩

```javascript
User =
{
	"_id": 1,
	"name": "hueypark",
	"items":
	[
		{
			"type": "sword",
			"damage": 10
		},
		{
			"type": "spear",
			"damage": 20
		}
	]
}
```

## 2. 링킹(부모가 가진 배열로 연결)

```javascript
User =
{
	"_id": 1,
	"name": "hueypark",
	"items": [2, 3]
}

Item =
{
	"_id": 2,
	"type": "sword",
	"damage": 10
},
{
	"_id": 3,
	"type": "spear",
	"damage": 20
}
```

## 3. 링킹(자식이 가진 스칼라로 연결)

```javascript
User =
{
	"_id": 1,
	"name": "hueypark"
}

Item =
{
	"_id": 2,
	"user_id": 1,
	"type": "sword",
	"damage": 10
},
{
	"_id": 3,
	"user_id": 1,
	"type": "spear",
	"damage": 20
}
```

## 각 방법의 장단점

1. 임베딩
	- 장점
		- 한 번의 조회로 필요한 데이터를 가져 올 수 있음
		- 트랜잭션 도움 없이 아토믹한 데이터 변경이 가능함
	- 단점
		- 단일 도큐먼트 크기 제한을 고려해야 함
		- 자식을 기준으로 조회하기 어려움(예: 모든 sword 의 수는 몇 개인가?)
2. 링킹(부모가 가진 배열로 연결)
	- 장점
		- 단일 도큐먼트 크기 제한에서 상대적으로 자유로움
	- 단점
		- 자식으로 부모를 조회할 수 없음
		- 조회를 두 번 해야 함
		- 아토믹한 데이터 변경을 위해 트랜잭션을 사용해야 함
3. 링킹(자식이 가진 스칼라로 연결)
	- 장점
		- 자식 기반의 조회가 용이함
		- 단일 도큐먼트 크기 제한에서 상대적으로 자유로움
	- 단점
		- 조회를 두 번 해야 함
		- 아토믹한 데이터 변경을 위해 트랜잭션을 사용해야 함

## 선택 전략

- 데이터의 특성에 따라 적절한 방법을 적용한다.
- 기본적으로 임베딩을 사용하고 필요시 링킹으로 전환한다.
- 기본적으로 링킹을 사용하고 필요시 임베딩으로 전환한다.

# 참고자료

- Data Modeling with MongoDB 프레젠테이션: https://www.mongodb.com/presentations/data-modeling-with-mongodb
- 공식문서 내 데이터 모델링: https://docs.mongodb.com/manual/core/data-modeling-introduction/
- [MongoDB 스터디 5주차(패턴과 안티패턴)](/mongodb/mongodb-study-week-5/)
