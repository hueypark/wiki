---
title: "MongoDB 스터디 6주차(MongoDB CURD 쓰기 연산)"
date: "2021-02-23"
tags: ["MongoDB"]
---

# Create Operations

## [db.collection.insertOne()](https://docs.mongodb.com/manual/reference/method/db.collection.insertOne/)

### 문법
```javascript
db.collection.insertOne(
	<document>,
	{
		writeConcern: <document>
	}
)
```

- [writeConcern](https://docs.mongodb.com/manual/reference/write-concern/)
	- w: 몇 개의 mongod 에 저장 후 응답할 지 설정
		- <숫자>: 몇 개의 mongod 에 기록될 지 직접 지정
		- "majority": 과반의 mongod 에 기록되게 설정
		- <커스텀 write concern 이름>: 특정 데이터 센터에 저장되게 설정가능, [Custom Multi-Datacenter Write Concerns](https://docs.mongodb.com/manual/tutorial/configure-replica-set-tag-sets/#configure-custom-write-concern)
	- j: 디스크의 저널에 저장 후 응답할지 설정 여부
	- timeout: 쓰기 제한 시간(밀리세컨드), 반환하기 전에 이미 성공한 쓰기 작업을 롤백하지 않음

### 예
```javascript
db.products.insertOne(
	{ "item": "envelopes", "qty": 100, type: "Self-Sealing" },
	{ writeConcern: { w : "majority", wtimeout : 100 } }
);
```

## [db.collection.insertMany()](https://docs.mongodb.com/manual/reference/method/db.collection.insertMany/)

### 문법
```javascript
db.collection.insertMany(
	[ <document 1> , <document 2>, ... ],
	{
		writeConcern: <document>,
		ordered: <boolean>
	}
)
```

- ordered
	- 입력이 순서를 유지할 지 여부, 기본값은 true

```javascript
db.products.insertMany( [
	{ _id: 13, item: "envelopes", qty: 60 },
	{ _id: 13, item: "stamps", qty: 110 },
	{ _id: 14, item: "packing tape", qty: 38 }
] );

BulkWriteError({
	"writeErrors" : [
		{
			"index" : 0,
			"code" : 11000,
			"errmsg" : "E11000 duplicate key error collection: inventory.products index: _id_ dup key: { : 13.0 }",
			"op" : {
				"_id" : 13,
				"item" : "stamps",
				"qty" : 110
			}
		}
	],
	"writeConcernErrors" : [ ],
	"nInserted" : 1,
	"nUpserted" : 0,
	"nMatched" : 0,
	"nModified" : 0,
	"nRemoved" : 0,
	"upserted" : [ ]
})
```

```javascript
	db.products.insertMany( [
		{ _id: 10, item: "large box", qty: 20 },
		{ _id: 11, item: "small box", qty: 55 },
		{ _id: 11, item: "medium box", qty: 30 },
		{ _id: 12, item: "envelope", qty: 100},
		{ _id: 13, item: "stamps", qty: 125 },
		{ _id: 13, item: "tape", qty: 20},
		{ _id: 14, item: "bubble wrap", qty: 30}
	], { ordered: false } );

BulkWriteError({
	"writeErrors" : [
		{
			"index" : 2,
			"code" : 11000,
			"errmsg" : "E11000 duplicate key error collection: inventory.products index: _id_ dup key: { : 11.0 }",
			"op" : {
				"_id" : 11,
				"item" : "medium box",
				"qty" : 30
			}
		},
		{
			"index" : 5,
			"code" : 11000,
			"errmsg" : "E11000 duplicate key error collection: inventory.products index: _id_ dup key: { : 13.0 }",
			"op" : {
				"_id" : 13,
				"item" : "tape",
				"qty" : 20
			}
		}
	],
	"writeConcernErrors" : [ ],
	"nInserted" : 5,
	"nUpserted" : 0,
	"nMatched" : 0,
	"nModified" : 0,
	"nRemoved" : 0,
	"upserted" : [ ]
})
```

# Update Operations

## [db.collection.updateOne()](https://docs.mongodb.com/manual/reference/method/db.collection.updateOne/)

### 문법

```javascript
db.collection.updateOne(
	<filter>,
	<update>,
	{
	  upsert: <boolean>,
	  writeConcern: <document>,
	  collation: <document>,
	  arrayFilters: [ <filterdocument1>, ... ],
	  hint:  <document|string>		  // Available starting in MongoDB 4.2.1
	}
)
```

- upsert: true일 경우 필터로 매치되는 도큐먼트가 없으면 새 도큐먼트 생성
- collation: 언어별 특화된 문자열 처리 옵션 [collation](https://docs.mongodb.com/manual/reference/collation/) 참조
- arrayFilters: 배열 업데이트를 위한 필터
- hint: 인덱스 힌트

### 예

```javascript
db.students.insert([
	{ "_id" : 1, "grades" : [ 95, 92, 90 ] },
	{ "_id" : 2, "grades" : [ 98, 100, 102 ] },
	{ "_id" : 3, "grades" : [ 95, 110, 100 ] }
])

db.students.updateMany(
	{ grades: { $gte: 100 } },
	{ $set: { "grades.$[element]" : 100 } },
	{
		arrayFilters: [ { "element": { $gte: 100 } } ]
	}
)

{ "_id" : 1, "grades" : [ 95, 92, 90 ] }
{ "_id" : 2, "grades" : [ 98, 100, 100 ] }
{ "_id" : 3, "grades" : [ 95, 110, 100 ] }
```

## db.collection.updateMany()

## db.collection.replaceOne()

필터된 도큐먼트를 새 도큐먼트로 변경합니다.

### 예

```javascript
db.students.insert([
	{ "_id" : 1, "grades" : [ 95, 92, 90 ] },
	{ "_id" : 2, "grades" : [ 98, 100, 102 ] },
	{ "_id" : 3, "grades" : [ 95, 110, 100 ] }
])

db.students.replaceOne(
	{ "_id" : 1 },
	{ "grade_sum" : 100 }
);

{ "_id" : 1, "grade_sum" : 100 },
{ "_id" : 2, "grades" : [ 98, 100, 102 ] },
{ "_id" : 3, "grades" : [ 95, 110, 100 ] }
```

# Delete operations

## [db.collection.deleteOne()](https://docs.mongodb.com/manual/reference/method/db.collection.deleteOne/)

필터된 도큐먼트를 하나 지웁니다.

### 문법

db.collection.deleteOne(
	<filter>,
	{
		writeConcern: <document>,
		collation: <document>,
		hint: <document|string>		  // Available starting in MongoDB 4.4
	}
)

## [db.collection.deleteMany()](https://docs.mongodb.com/manual/reference/method/db.collection.deleteMany/)

필터된 도큐먼트를 여러개 지웁니다.

### 문법

db.collection.deleteMany(
	<filter>,
	{
		writeConcern: <document>,
		collation: <document>
	}
)

# Bulk Write Operations

## [db.collection.bulkWrite()](https://docs.mongodb.com/manual/reference/method/db.collection.bulkWrite/)

여러 작업을 한 번에 합니다.

### 문법

db.collection.bulkWrite(
	[ <operation 1>, <operation 2>, ... ],
	{
		writeConcern : <document>,
		ordered : <boolean>
	}
)

- 사용가능 명령
	- insertOne
	- updateOne
	- updateMany
	- deleteOne
	- deleteMany
	- replaceOne

### 예

```javascript
	db.characters.bulkWrite([
		{ insertOne: { "document": { "_id": 4, "char": "Dithras", "class": "barbarian", "lvl": 4 } } },
		{ insertOne: { "document": { "_id": 5, "char": "Taeln", "class": "fighter", "lvl": 3 } } },
		{ updateOne : {
			"filter" : { "char" : "Eldon" },
			"update" : { $set : { "status" : "Critical Injury" } }
		} },
		{ deleteOne : { "filter" : { "char" : "Brisbane"} } },
		{ replaceOne : {
			"filter" : { "char" : "Meldane" },
			"replacement" : { "char" : "Tanys", "class" : "oracle", "lvl": 4 }
		} }
	]);
```

## [db.collection.insertMany()](https://docs.mongodb.com/manual/reference/method/db.collection.insertMany/)

# $isolated

[4.0](https://docs.mongodb.com/manual/release-notes/4.0-compatibility/index.html) 에서 제거되었고,
필요하면 트랜잭션을 사용하길 권고하고 있음
