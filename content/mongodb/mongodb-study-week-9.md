---
title: "MongoDB 스터디 9주차(인덱스)"
date: "2021-03-14"
tags: ["MongoDB"]
draft: true
---

# 인덱스

인덱스는 쿼리가 효율적으로 실행되게 돕습니다. 쿼리에 적절한 인덱스가 있으면 이를 사용해 조회할 도큐먼트 수를 줄일 수 있습니다.

인덱스는 특정 필드 또는 필드들을 값에 따라 정렬해 저장합니다.

정렬된 인덱스는 효율적인 레인지 쿼리를 지원합니다.

몽고디비 인덱스는 B-tree 자료구조를 사용합니다.

![](/mongodb/mongodb-study-week-9/index-for-sort.bakedsvg.svg)

## `_id` 인덱스

몽고디비는 [_id](https://docs.mongodb.com/manual/core/document/#document-id-field) 유니크 인덱스를 만듭니다.
`_id` 인덱스는 같은 `_id` 를 가진 도큐먼트가 두 개 생기는 것을 막습니다. `_id` 인덱스는 제거할 수 없습니다.

> NOTE: 샤딩된 클러스터에서 `_id` 필드를 샤드 키로 사용하지 않으면 오류방지를 위해 애플리케이션이 `_id` 필드의
유니크성을 보장해야 합니다.

## 인덱스 이름

인덱스의 기본 이름은 인덱스 키의 이름과 정렬기준(1 또는 -1)의 합입니다. 예를 들어 `{item: 1, quantity: -1}` 로 인덱스를
만들면 이름은 `item_1_quantity_-1` 입니다.

인덱스를 만들 때 명시적으로 이름을 정할 수도 있습니다.

```javascript
db.products.createIndex(
  { item: 1, quantity: -1 } ,
  { name: "query for inventory" } // 명시적 이름
)
```

---

# 인덱스 타입

몽고디비에는 다양한 종류의 인덱스가 있습니다.

# 단일 필드 인덱스

단일 필드를 사용하는 인덱스입니다.

단일 필드 인덱스의 경우 양방향으로 탐색할 수 있기 때문에 정렬순서(sort order) 는 중요하지 않습니다.

# 컴파운드 인덱스

여러 필드를 포함한 인덱스입니다.

컴파운드 인덱스에서 필드 순서는 중요합니다. 예를 들어 `{ userid: 1, score: -1 }` 는, `userid` 로 먼저 정렬된
후, `score` 로  정렬됩니다.

> IMPORTANT: 4.4 버전부터 컴파운드 인덱스는 단 하나의 해시드 인덱스 필드를 가질 수 있습니다.(4.2 버전 이전에는 불가)

## 정렬 순서

컴파운드 인덱스에서 정렬 순서는 중요합니다. 예를 들어 `{ "username" : 1, "date" : -1 }` 인덱스를
 `sort( { username: 1, date: 1 } )` 쿼링에 사용할 수 없습니다.

## 인덱스 프리픽스

인덱스 프리픽스는 인덱스 앞부분의 집합입니다.

아래와 같은 인덱스가 있을 때:
```javascript
{ "item": 1, "location": 1, "stock": 1 }
```

인덱스 프리픽스는 다음과 같습니다:

- { item: 1 }
- { item: 1, location: 1 }

컴파운드 인덱스는 인덱스 프리픽스를 활용해서 쿼리할 수 있습니다. 하지만 `location` 또는 `stock` 등 프리픽스가 아닌 필드만으로는
인덱스를 활용할 수 없습니다.

# 멀티키 인덱스

배열에 인덱스를 설정하면 몽고디비는 배열의 각 엘리먼트에 인덱스 키를 만듭니다. 이 멀티 키 인덱스들은 배열에 쿼리하는데
활용됩니다.

## 제한사항

### 컴파운드 멀티키 인덱스

컴파운드 멀티키 인덱스에서 값이 배열인 인덱스는 하나만 있을 수 있습니다.

### 해시드 인덱스

멀티키 인덱스는 해시드 인덱스로 설정할 수 없습니다.

### [커버드 쿼리](https://docs.mongodb.com/manual/core/index-multikey/#covered-queries)

멀티 키 인덱스는 배열 필드에 대한 커버드 쿼리를 지원하지 않습니다.

### 배열 전체에 대한 쿼리

배열 전체에 대한 쿼리를 할 경우 몽고디비는 첫 번째 엘리먼트에 대해서만 인덱스를 사용할 수 있습니다.

아래와 같은 경우는 `ratings` 가 5 인 경우에 대해 인덱스를 사용한 다음, `[5, 9]` 인 경우를 다시 필터합니다.
```javascript
db.inventory.find( { ratings: [ 5, 9 ] } )
```

### $expr

멀티 키 인덱스는 [$expr](https://docs.mongodb.com/manual/reference/operator/query/expr/#op._S_expr) 을 지원하지 않습니다.

# 텍스트 인덱스

> MONGODB ATLAS SEARCH: Build fast, relevant, full-text search capabilities right on top of your data in the cloud.
Design and deliver rich user experiences with a full-text search engine built on industry-leading `Apache Lucene`.

> IMPORTANT: 컬렉션은 최대 하나의 텍스트 인덱스를 가질 수 있습니다.

## Specify Weights

텍스트 검색으로 점수를 산출할 때 중요도를 결정할 웨이트, 기본값은 1입니다.

```javascript
db.blog.createIndex(
   {
     content: "text",
     keywords: "text",
     about: "text"
   },
   {
     weights: {
       content: 10,
       keywords: 5
     },
     name: "TextIndex"
   }
 )
```

## 와일드카드 텍스트 인덱스

`$**` 를 사용해 와일드카드 텍스트 인덱스를 만들면 몽고디비는 문자열을 가진 모든 필드를 인덱싱합니다.

```javascript
db.collection.createIndex( { "$**": "text" } )
```

## sparse 속성

텍스트 인덱스는 언제나 `sparse` 입니다. 만약 도튜먼트에 충분한 텍스트 인덱스가 없으면
몽고디비는 텍스트 인덱스 엔트리에 해당 도큐먼트를 추가하지 않습니다.

## 제한사항

- 한 컬렉션에 하나의 텍스트 인덱스만 추가할 수 있습니다.
- 텍스트 인덱스를 사용하면 [hint()](https://docs.mongodb.com/manual/reference/method/cursor.hint/#cursor.hint) 를 쓸 수 없습니다.
- 텍스트 인덱스로 정렬할 수 없습니다.
- 컴파운드 인덱스로 사용할 수 있지만 제한사항이 있습니다.
	- [멀티 키](https://docs.mongodb.com/manual/core/index-multikey/#index-type-multi-key), [geospatial](https://docs.mongodb.com/manual/geospatial-queries/#index-feature-geospatial) 과 같은 다른 특수 인덱스와 같이 쓸 수 없습니다.
	- 텍스트 인덱스 보다 앞에 있는 인덱스가 있다면, 쿼리는 해당 인덱스를 꼭 포함해야 합니다.
	- 모든 텍스트 인덱스 키는 인접해 있어야 합니다.
- 텍스트 인덱스는 [collation](https://docs.mongodb.com/manual/reference/bson-type-comparison-order/#collation) 을 지원하지 않습니다.

## 스토리지 요구사항과 성능관련 비용

- 텍스트 인덱스는 큽니다. 유니크한 단어마다 하나의 인덱스 엔트리가 만들어집니다.
- 텍스트 인덱스를 만드는 것은 커다란 멀티 키 인덱스를 만드는 것과 비슷하게 느립니다.
- 이미 있는 컬렉션에 커다란 텍스트 인덱스를 만들 때 `open file descriptors` 제한이 크게 설정되어 있는지 확인하십시오.
- 텍스트 인덱스는 insert 쓰루풋에 영향을 줍니다.
- Additionally, text indexes do not store phrases or information about the proximity of words in the documents. As a result, phrase queries will run much more effectively when the entire collection fits in RAM.

# 와일드카드 인덱스

필드 집합에 인덱스를 추가할 수 있습니다.

sparse 인덱스입니다.

```javascript
{ "userMetadata" : { "likes" : [ "dogs", "cats" ] } }
{ "userMetadata" : { "dislikes" : "pickles" } }
{ "userMetadata" : { "age" : 45 } }
{ "userMetadata" : "inactive" }
```

```javascript
db.userData.createIndex( { "userMetadata.$**" : 1 } )
```

> IMPORTANT: 와일드카드 인덱스는 워크로드 기반의 인덱스 설계를 대체하기 위해 생긴 것이 아닙니다.

## 고려사항

- 와일드카드 인덱스는 동시에 하나의 필드만 사용할 수 있습니다.
- 컬렉션에 여러 와일드카드 인덱스를 만들 수 있습니다.
- 와일드 카드 인덱스는 sparse 인덱스입니다.

## 동작

- 만약 필드가 오브젝트면, 하위 필드를 탐색하며 인덱싱합니다.
- 만역 필드가 배열이면, 순회하면 각 엘리먼트를 인덱싱합니다.
	- 만약 엘리먼트가 오브젝트면, 하위 필드를 탐색하며 인덱싱합니다.
	- 만약 필드가 배열이면 전체를 순회하지 않고 단일 값으로 취급합니다.
- 다른 모든 필드는 값을 인덱싱합니다.

## 제한사항

- 와일드카드 인덱스로 샤딩할 수 없습니다.
- 컴파운드 인덱스를 만들 수 없습니다.
- TTL, 유니크 속성은 와일드 카드 인덱스에 적용할 수 없습니다.
- 와일드 카드 인덱스로 2d, 2dsphere, 해시 인덱스는 만들 수 없습니다.

## 쿼리/정렬 지원

- 아래 조건을 만족하면 커버드 쿼리를 지원합니다.
	- 쿼리 플래너가 와일드카드 인덱스를 선택
	- 와일드카드 인덱스가 적용되는 필드 하나만 읽기 요청
	- 명시적으로 `_id` 필드 제거
	- 대상 필드가 배열이 아님
- 여러 필드 쿼리
### Multi-Field Query Predicates
Wildcard indexes can support at most one query predicate field. That is:

- MongoDB cannot use a non-wildcard index to satisfy one part of a query predicate and a wildcard index to satisfy another.
- MongoDB cannot use one wildcard index to satisfy one part of a query predicate and another wildcard index to satisfy another.
- Even if a single wildcard index could support multiple query fields, MongoDB can use the wildcard index to support only one of the query fields. All remaining fields are resolved without an index.

### Queries with Sort
MongoDB can use a wildcard index for satisfying the sort() only if all of the following are true:

- The query planner selects the wildcard index for satisfying the query predicate.
- The sort() specifies only the query predicate field.
- The specified field is never an array.

### Unsupported Query Patterns¶

- Wildcard indexes cannot support query condition that checks if a field does not exist.
- Wildcard indexes cannot support query condition that checks if a field is or is not equal to a document or an array
- Wildcard indexes cannot support query condition that checks if a field is not equal to null.

### Sharding
You cannot shard a collection using a wildcard index. Create a non-wildcard index on the field or fields you want to shard on. For more information on shard key selection, see Shard Keys.

## 2d 인덱스, 2d sphere 인덱스

2차원 평면과, 2차원 구체(지구와 같은) 를 나타내는 인덱스

[GeoJSON object](https://docs.mongodb.com/manual/geospatial-queries/#geospatial-geojson) 를 사용해야 함

## geoHayStack 인덱스

> DEPRECATION: MongoDB 4.4 deprecates the geoHaystack index and the geoSearch command. Use a 2d index with $geoNear or $geoWithin instead.

## 해시 인덱스

해시 인덱스는 해시를 활용해 인덱스 엔트리를 유지합니다.

해시 인덱스를 사용하면 샤딩에서 해시된 샤드키를 쓸 수 있습니다. 해시된 샤드키를 사용하면 데이터가 임의로 분산됩니다.

```javascript
db.collection.createIndex( { _id: "hashed" } )
```

### 컴파운드 해시 인덱스

```javascript
db.collection.createIndex( { "fieldA" : 1, "fieldB" : "hashed", "fieldC" : -1 } )
```

### 고려사항

#### 멀티 키 인덱스(배열) 에슨 사용할 수 없습니다.

#### 유니크 제약조건을 걸 수 없습니다. 

#### 2의 53승 제한

> WARNING: 해시 이전에 부동 소수점 숫자를 64비트 정수로 잘릅니다. 예를 들어 해시된 인덱스는 2.0, 2.1, 2.2 에 대해 동일한 값을 저장합니다. 충돌을 방지하려면 부동 소수점 숫자를 사용하지 마십시오.
2의 53승 보다 큰 부동 소수점 숫자를 지원하지 않습니다.

[해시 함수](https://github.com/mongodb/mongo/blob/master/src/mongo/db/hasher.cpp)

## 인덱스 프로퍼티

### TTL 인덱스

TTL 인덱스는 특정 시간이 지난 후 도큐먼트를 자동으로 제거하는 데 사용할 수 있는 단일 필드 인덱스입니다.

```javascript
db.eventlog.createIndex( { "lastModifiedDate": 1 }, { expireAfterSeconds: 3600 } )
```

#### 동작

필드에 배열이고 여러 값이 있으면 가장 빠른 값 기준으로 제거됩니다.

만약 `date` 필드가 아니면 제거되지 않습니다.

인덱스된 값이 없으면 제거되지 않습니다.

#### 삭제 오퍼레이션

`mongod` 의 백그라운드 쓰레드가 인덱스 값을 읽고 만료된 도큐먼트를 지웁니다.

TTL 쓰레드가 활성화되면 [db.currentOp()](https://docs.mongodb.com/manual/reference/method/db.currentOp/#db.currentOp) 과 [데이터베이스 프로파일러](https://docs.mongodb.com/manual/tutorial/manage-the-database-profiler/#database-profiler) 에서 확인할 수 있습니다.

#### 삭제 시간

백그라운드 작업은 60초에 한 번 실행됩니다. 이 때문에 만료된 도큐먼트가 잠시 유지될 수 있습니다.

#### 레플리카 셋

레플리카 셋이 구성되면 삭제 작업은 프라이머리에만 실행됩니다.

#### 제한사항

- 컴파운드 인덱스를 지원하지 않습니다.
- `_id` 필드에 적용할 수 없습니다.
- `capped 컬렉션` 에 사용할 수 없습니다.
- 이미 존재하는 인덱스의 `expireAfterSeconds` 값을 `createIndex()` 명령어로 변경할 수 없습니다.
대신 [collMod](https://docs.mongodb.com/manual/reference/command/collMod/#dbcmd.collMod) 데이터베이스 커맨드로 변경하십시오.
이미 존재하는 인덱스의 값을 변경하려면 인덱스를 삭제하고 다시 만들어야 합니다.
- 단일 필드가 TTL이 아닌 인덱스를 가지고 있으면 TTL 인덱스를 생성할 수 없습니다. 변경하려면 먼저 인덱스를 삭제하고 다시 만들어야 합니다.

### 유니크 인덱스

유니크 인덱스는 중복 값을 저장하지 않게 보장합니다. 몽고디비는 기본적으로 `_id` 필드에 유니크 인덱스를 만듭니다.

```javascript
db.collection.createIndex( <key and index type specification>, { unique: true } )
```

#### 유니크 컴파운드 인덱스

컴파운드 인덱스에도 유니크 제약조건을 추가할 수 있습니다.

```javascript
db.members.createIndex( { groupNumber: 1, lastname: 1, firstname: 1 }, { unique: true } )
```

#### 제한사항

제약조건을 위반하는 데이터가 이미 포함되어 있는 경우 유니크 인덱스를 추가할 수 없습니다.

해시 인덱스에 유니크 제약조적을 추가할 수 없습니다.

#### 존재하지 않는 필드에 대한 유니크 인덱스

도큐먼트가 인덱스된 필드를 가지고 있지 않으면 `null` 값을 저장합니다. 만약 인덱스된 필드가 없는 도큐먼트가 하나 이상 있으면 인덱스 빌드가 실패합니다.

#### 샤딩된 클러스터와 유니크 인덱스

해시드 인덱스에 유니크 제약조건을 추가할 수 없습니다.

레인지 샤드된 컬렉션의 경우 아래의 경우 유니크 인덱스를 설정할 수 있습니다:

- 인덱스는 샤드 키여야 합니다.
- 컴파운드 인덱스을 경우 샤드 키은 앞쪽에 있어야 합니다.
- 기본 `_id` 인덱스: 샤드 키에 포함되어 있지 않다면 유니크성은 샤드 별로만 보장됩니다.

The unique index constraints mean that:

- For a to-be-sharded collection, you cannot shard the collection if the collection has other unique indexes.
- For an already-sharded collection, you cannot create unique indexes on other fields.

#### Partial Indexes

특정한 조건을 만족하는 대상에만 적용되는 인덱스

도큐먼트 중 일부만 인덱스 되고, 더 적은 스토리지와 비용(성능)을 사용합니다.

```javascript
db.restaurants.createIndex(
   { cuisine: 1, name: 1 },
   { partialFilterExpression: { rating: { $gt: 5 } } }
)
```

사용 가능 연산자
- equality expressions (i.e. field: value or using the $eq operator),
- $exists: true expression,
- $gt, $gte, $lt, $lte expressions,
- $type expressions,
- $and operator at the top-level only

##### 동작

쿼리 커버리지: Partial 인덱스를 사용하기 위해 쿼리는 미리 설정된 필터를 포함하는 쿼리를 사용해야 합니다.

아래와 같은 인덱스가 있다면,

```javascript
db.restaurants.createIndex(
   { cuisine: 1 },
   { partialFilterExpression: { rating: { $gt: 5 } } }
)
```

아래처럼 되어야 적용할 수 있습니다.
```javascript
db.restaurants.find( { cuisine: "Italian", rating: { $gte: 8 } } )
```

아래 같다면 적용할 수 없습니다.
```javascript
db.restaurants.find( { cuisine: "Italian" } )
```

##### sparse 인덱스와의 비교

> TIP: Partial 인덱스는 apares 인덱스의 슈퍼셋 기능을 제공합니다.

#### Case Insensitive 인덱스

```javascript
db.collection.createIndex( { "key" : 1 },
                           { collation: {
                               locale : <locale>,
                               strength : <strength>
                             }
                           } )
```

- locale: specifies language rules. See Collation Locales for a list of available locales.
- strength: determines comparison rules. A value of 1 or 2 indicates a case insensitive collation.

#### Hidden 인덱스

히든 인덱스는 쿼리 플래너가 해당 인덱스를 사용하지 않게 설정합니다.

하지만 인덱스 생성, TTL, 유니크 제약조건 등은 그대로 동작합니다.

히든 인덱스를 이용해서 인덱스 삭제의 잠재적인 영향을 평가한 후 인덱스를 삭제할 수 있습니다.

```javascript
db.restaurants.hideIndex( { borough: 1, ratings: 1 } ); // Specify the index key specification document

db.restaurants.hideIndex( "borough_1_ratings_1" );
```

```javascript
db.restaurants.unhideIndex( { borough: 1, city: 1 } );  // Specify the index key specification document

db.restaurants.unhideIndex( "borough_1_ratings_1" );    // Specify the index name
```

#### Sparse 인덱스

Sparse indexes only contain entries for documents that have the indexed field, even if the index field contains a null value. The index skips over any document that is missing the indexed field. The index is “sparse” because it does not include all documents of a collection. By contrast, non-sparse indexes contain all documents in a collection, storing null values for those documents that do not contain the indexed field.

> IMPORTANT: Changed in version 3.2: Starting in MongoDB 3.2, MongoDB provides the option to create partial indexes. Partial indexes offer a superset of the functionality of sparse indexes. If you are using MongoDB 3.2 or later, partial indexes should be preferred over sparse indexes.


---