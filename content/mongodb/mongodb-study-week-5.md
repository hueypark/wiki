---
title: "MongoDB 스터디 5주차(패턴과 안티패턴)"
date: "2021-02-10"
tags: ["MongoDB"]
---

## 패턴

### Attribute Pattern

- 상황
	- 비슷한 필드가 많을 때
	- 여러 필드에 걸쳐 조회하고 싶을때
	- 필드가 일부 도큐먼트에만 있을 때
- 해결책
	- 필드를 k/v 짝으로 나누어 서브도큐먼트에 저장
- 예

적용 전
```json
{
	"title": "Star Wars",
	"release_US": "1977-05-20T01:00:00+01:00",
	"release_France": "1977-10-19T01:00:00+01:00",
	"release_Italy": "1977-10-20T01:00:00+01:00",
	"release_UK": "1977-12-27T01:00:00+01:00",
}
```

적용 후
```json
{
	"title": "Star Wars",
	"director": "George Lucas",
	"releases":
	[
		{
			"location": "USA",
			"date": "1977-05-20T01:00:00+01:00"
		},
		{
			"location": "France",
			"date": "1977-10-19T01:00:00+01:00"
		},
		{
			"location": "Italy",
			"date": "1977-10-20T01:00:00+01:00"
		},
		{
			"location": "UK",
			"date": "1977-12-27T01:00:00+01:00"
		},
	]
}
```
- 장점
	- 인덱싱하기 쉬움
	- 더 적은 인덱스가 필요함
	- 쿼리가 간단해지고 일반적으로 빨라짐

### Extended Reference Pattern

- 상황
	- 너무 많은 조인이 발생함
- 해결책
	- 주가 되는 도큐먼트에 쪽에 필드를 임베딩함
- 예

적용 전
```json
customer
{
	"_id": 1,
	"name": "huey",
	"city": "seoul",
}

order
{
	"customer_id": 1,
	"date": "2021-02-14"
}
```

적용 후
```json
customer
{
	"_id": 1,
	"name": "huey"
}

order
{
	"customer_id": 1,
	"customer":
	{
		"name": "huey"
	},
	"date": "2021-02-14"
}
```

- 장점
	- 조인이 줄어들어 성능이 향상됨
- 단점
	- 데이터 중복

### Subset Pattern

- 상황
	- 작업 데이터가 너무 커서 메모리에 캐시를 유지하기 어려움
	- 도큐먼트의 큰 부분이 자주 사용되지 않음
- 해결책
	- 컬렉션을 두 개로 나눔
		- 자주 사용되는 부분
		- 자주 사용되지 않는 부분
	- 두 컬렉을 연결
- 예)


적용 전
```json
user
{
	"_id": 1,
	"name": "huey",
	"city": "seoul",
	"desc": "Software engineer in Seoul..."
}
```

적용 후
```json
user
{
	"_id": 1,
	"name": "huey",
	"city": "seoul",	
}

user_detail
{
	"_id": 1,
	"user_id": 1,
	"desc": "Software engineer in Seoul..."
}
```

- 장점
	- 자주 사용되는 도큐먼트가 작기 때문에 작업 데이터가 작아짐
	- 도큐먼트가 더 많이 캐시되기 때문에 디스크 접근이 줄어듬
- 단점
	- 서버와 더 많은 횟수의 통신이 필요
	- 디스크가 약간 더 필요함

### Computed Pattern

- 상황
	- 데이터에 대한 계산이 많음
	- 같은 데이터에 자주 접근해서, 같은 결과를 계산함
- 해결책
	- 계산된 데이터를 도큐먼트에 저장
	- 다음 번에 데이터가 필요할 때 미리 계산된 데이터 사용
- 장점
	- 읽기가 빨라짐
	- CPU와 디스크 자원이 절약됨
- 단점
	- 필요한 지점을 식별하기 어려울 수 있음
	- 불필요한 상황에서 과용되기 쉬움

### Bucket Pattern

- 상황
	- 도큐먼트가 너무 많거나, 커짐
	- 임베딩하기 어려운 크기의 1 to many 관계 
- 해결책
	- 그룹화할 적절한 양의 데이터를 지정
	- 메인 도큐먼트에 array를 만들어 데이터 저장
- 예

적용 전
```json
{
	"sensor_id": 12345,
	"timestamp": "2019-01-31T10:00:00.000Z",
	"temperature": 40
}

{
	"sensor_id": 12345,
	"timestamp": "2019-01-31T10:01:00.000Z",
	"temperature": 40
}

{
	"sensor_id": 12345,
	"timestamp": "2019-01-31T10:02:00.000Z",
	"temperature": 41
}
```

적용 후
```json
{
	"sensor_id": 12345,
	"start_date": "2019-01-31T10:00:00.000Z",
	"end_date": "2019-01-31T10:59:59.000Z",
	"measurements": [
		{
			"timestamp": "2019-01-31T10:00:00.000Z",
			"temperature": 40
		},
		{
			"timestamp": "2019-01-31T10:01:00.000Z",
			"temperature": 40
		},
		{
			"timestamp": "2019-01-31T10:42:00.000Z",
			"temperature": 42
		}
	]
}
```

- 장점
	- 데이터가 급격하게 커져도 적절한 수준에서 제어 가능
	- 쉽게 데이터 관리 가능
- 단점
	- 잘 디자인되지 않으면 제대로 된 결과를 얻기 힘듬
	- 일반적인 BI 툴에 적용 불가

### Shcema Versioning Pattern

- 상황
	- 스키마 변경시 다운타임 발생(짧게는 수 시간에서 수 주가 소요)
	- 모든 도큐먼트를 다 변경하고 싶지 않음
- 해결책
	- `schema_version` 필드 추가
	- 애플리케이션이 버전 별 처리
	- 버전 마이그레이션 전략 수립
- 장점
	- 다운타임 없음
	- 데이터 마이그레이션을 제어할 수 있음
- 단점
	- 마이그레이션 전까지 인덱스가 두 배로 필요할 수 있음

---

## 안티 패턴

### Massive arrays

- 상황
	- 매우 큰 array 를 포함한 도큐먼트
- 문제점
	- 도큐먼트 크기 제한 16 MB
	- array 크기가 커 짐에 따라 인덱스 성능이 떨어짐
- 예

수정 전
```json
user
{
	"_id": 1,
	"name": "huey",
	"items":
	[
		{
			"_id": 1,
			"name": "dragon sword"
		},
		{
			"_id": 2,
			"name": "titanium shield"
		},
		...
	]
}
```

수정 후
```json
user
{
	"_id": 1,
	"name": "huey"
}

item
{
	"_id": 1,
	"user_id": 1,
	"name": "dragon sword"
}
{
	"_id": 2,
	"user_id": 1,
	"name": "titanium shield"
}
...
```

### Massive number of collections

- 상황
	- 너무 많은 컬렉션(안 쓰거나 불필요한)을 추가
- 문제점
	- 안 쓰거나 불필요한 인덱스도 자원을 소모함
	- WiredTiger 는 컬렉션과 인덱스의 수가 늘어남에 따라 성능이 저하됨
- 예
	- 새로 추가되는 데이터를 일별로 구분된 컬렉션으로 관리(`player-2021-02-14`, `player-2021-02-15`, `player-2021-02-16`, ...)

### Unnecessary indexes

- 상황
	- 거의 안 쓰이거나 컴파운드 인덱스가 이미 커버하는 인덱스를 중복 생성
- 문제점
	- 인덱스는 디스크를 차지함
	- 인덱스는 스토리지 엔진 성능에 영향을 줌
	- 인덱스는 쓰기 성능에 영향을 줌
- 해결책
	- 중복 인덱스 제거
		- { last_name: 1, first_name: 1 } 인덱스가 있으면 { last_name: 1 } 불필요
	- 거의 안 쓰는 인덱스 제거 고려

### Bloated documents

- 상황
	- 함께 사용되는 경우가 적은 데이터를 한 도큐먼트로 관리
- 문제점
	- WiredTiger 는 자주 쓰는 도큐먼트를 캐시하기 때문에 불필요한 메모리 사용 증가
- 해결책
	- 함께 사용되는 경우가 적은 데이터는 Subset Pattern 을 이용해 분리

### Separating data that is accessed together

- 상황
	- 자주 함께 사용되는 데이터를 분리해 놓음
- 문제점
	- $lookup 은 느리고 자원을 많이 사용함
- 해결책
	- 자주 함께 사용되는 데이터는 한 도큐먼트에 저장(Extended Reference Pattern 으로 중복 적제하는 것 고려)

### Case-insensitive queries without case-insensitive indexes

- 상황
	- 대소문자를 구분하지 않는 쿼리를 대소문자 구분하는 인덱스에 적용
- 문제점
	- $regex 쿼리는 사용가능하지만 비효율적임(인덱스 사용불가)
	- Non-$regex 쿼리는 동작하지 않음
- 해결책
	- [MongoDB Collation](https://docs.mongodb.com/manual/reference/collation/) 을 참고해 필요한 인덱스 생성

---

## 참고자료

- Building with Patterns: A Summary: https://www.mongodb.com/blog/post/building-with-patterns-a-summary
- A Summary of Schema Design Anti-Patterns and How to Spot Them: https://developer.mongodb.com/article/schema-design-anti-pattern-summary/
