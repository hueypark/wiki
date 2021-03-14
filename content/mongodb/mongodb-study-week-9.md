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

## Default `_id` Index

몽고디비는 [_id](https://docs.mongodb.com/manual/core/document/#document-id-field) 필드를 유니크 인덱스를 만듭니다.
`_id` 인덱스는 같은 `_id` 를 가진 두 도큐먼트가 생기는 것을 막습니다. 사용자는 `_id` 인덱스를 제거할 수 없습니다.

> NOTE: 샤딩된 클러스터에서 `_id` 필드를 샤드 키로 사용하지 않으면 오류방지를 위해 애플리케이션이 `_id` 필드의
유니크성을 보장해야 합니다.

## 인덱스 이름

인덱스의 기본 이름은 인덱스 키의 이름과 정렬기준(1 또는 -1)의 합입니다. 예를 들어 `{item: 1, quantity: -1}` 로 인덱스를
만들면 이름은 `item_1_quantity_-1` 입니다.

인덱스를 만들 때 명시적으로 이름을 정할 수도 있습니다.

```javascript
db.products.createIndex(
  { item: 1, quantity: -1 } ,
  { name: "query for inventory" }
)
```

# 인덱스 타입

## 싱글 필드 인덱스

단일 필드 인덱스를 추가할 수 있습니다.

단일 필드 인덱스의 경우 몽고디비가 양방향으로 탐색할 수 있기 때문에 정렬순서(sort order) 는 중요하지 않습니다.

## 컴파운드 인덱스

여러 필드를 포함한 인덱스를 지원합니다.

컴파운드 인덱스에서 필드의 순서는 중요합니다. 예를 들어 `{ userid: 1, score: -1 }` 는, `userid` 로 먼저 정렬된
후, `score` 로  정렬됩니다.

> IMPORTANT: 4.4 버전부터 컴파운드 인덱스는 단 하나의 해시드 인덱스 필드를 가질 수 있습니다.(4.2 버전 이전에는 불가)

### 정렬 순서

컴파운드 인덱스에서 정렬 순서는 중요합니다. 예를 들어 `{ "username" : 1, "date" : -1 }` 인덱스는 
 `sort( { username: 1, date: 1 } )` 를 지원할 수 없습니다.

### 인덱스 프리픽스

인덱스 프리픽스는 인덱스 앞부분 집합입니다.

```javascript
{ "item": 1, "location": 1, "stock": 1 }
```

위 인덱스에서 인덱스 프리픽스는 다음과 같습니다:

- { item: 1 }
- { item: 1, location: 1 }

컴파운드 인덱스는 인덱스 프리픽스를 활용해서 쿼리할 수 있습니다. 하지만 프리픽스가 아닌 필드인 `location` 또는 `stock`
만을 사용했을 때는 인덱스를 활용할 수 없습니다.

## 멀티키 인덱스

배열에 인덱스를 설정하면 몽고디비는 배열의 각 엘리먼트에 인덱스 키를 만듭니다. 이 멀티 키 인덱스들은 배열에 쿼리하는데
활용됩니다.

### 제한사항

#### 컴파운드 멀티키 인덱스

컴파운드 멀티키 인덱스에서 값이 배열인 인덱스는 하나만 있을 수 있습니다.

#### [정렬](https://docs.mongodb.com/manual/core/index-multikey/#sorting)

#### 해시드 인덱스

해시드 인덱스는 멀티키가 될 수 없습니다.

#### [커버드 쿼리](https://docs.mongodb.com/manual/core/index-multikey/#covered-queries)

멀티 키 인덱스는 배열 필드에 대한 커버드 쿼리를 지원하지 않습니다.

#### 배열 전체에 대한 쿼리

배열 전체에 대한 쿼리를 할 경우 몽고디비는 첫 번째 엘리먼트에 대해서만 인덱스를 사용할 수 있습니다. 대신 다중 키
인덱스를 사용하여 

```javascript
db.inventory.find( { ratings: [ 5, 9 ] } )
```

위와 같은 경우 `ratings` 가 5 인 경우에 대해 인덱스를 사용한 후, `[5, 9]` 인 경우를 다시 필터합니다.

#### $expr

멀티 키 인덱스는 [$expr](https://docs.mongodb.com/manual/reference/operator/query/expr/#op._S_expr) 을 지원하지 않습니다.

## 텍스트 인덱스

> MONGODB ATLAS SEARCH: Build fast, relevant, full-text search capabilities right on top of your data in the cloud.
Design and deliver rich user experiences with a full-text search engine built on industry-leading Apache Lucene.

> IMPORTANT: 컬렉션은 최대 하나의 텍스트 인덱스를 가질 수 있습니다.

### Specify Weights

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

### 와일드카드 텍스트 인덱스

`$**` 를 사용해 와일드카드 텍스트 인덱스를 만들면 몽고디비는 문자열을 가진 모든 필드를 인덱싱합니다.

```javascript
db.collection.createIndex( { "$**": "text" } )
```

### [대소문자 구분](https://docs.mongodb.com/manual/core/index-text/#case-insensitivity)

### [Diacritic Insensitivity](https://docs.mongodb.com/manual/core/index-text/#diacritic-insensitivity)

### Tokenization Delimiters

For tokenization, version 3 text index uses the delimiters categorized under Dash, Hyphen, Pattern_Syntax, Quotation_Mark, Terminal_Punctuation, and White_Space in Unicode 8.0 Character Database Prop List.

For example, if given a string "Il a dit qu'il «était le meilleur joueur du monde»", the text index treats «, », and spaces as delimiters.

### Index Entries

text index tokenizes and stems the terms in the indexed fields for the index entries. text index stores one index entry for each unique stemmed term in each indexed field for each document in the collection. The index uses simple language-specific suffix stemming.

### Supported Languages and Stop Words

MongoDB supports text search for various languages. text indexes drop language-specific stop words (e.g. in English, the, an, a, and, etc.) and use simple language-specific suffix stemming. For a list of the supported languages, see Text Search Languages.

If you specify a language value of "none", then the text index uses simple tokenization with no list of stop words and no stemming.

To specify a language for the text index, see Specify a Language for Text Index.

### sparse Property

텍스트 인덱스는 언제나 `sparse` 이고 `sparse` 옵션을 무시합니다. 만약 도튜먼트에 충분한 텍스트 인덱스가 없으면
몽고디비는 텍스트 인덱스 엔트리에 해당 도큐먼트를 추가하지 않습니다.

### 제한사항

#### 한 컬렉션에 하나의 텍스트 인덱스만 추가할 수 있습니다.

#### 텍스트 인덱스를 사용하면 [hint()](https://docs.mongodb.com/manual/reference/method/cursor.hint/#cursor.hint) 를 쓸 수 없습니다.

#### 텍스트 인덱스로 정렬할 수 없습니다.

#### 컴파운드 인덱스

컴파운드 인덱스로 사용할 수 있지만 제한사항이 있습니다.

- [멀티 키](https://docs.mongodb.com/manual/core/index-multikey/#index-type-multi-key), [geospatial](https://docs.mongodb.com/manual/geospatial-queries/#index-feature-geospatial) 과 같은 다른 특수 인덱스와 같이 쓸 수 없습니다.
- 텍스트 인덱스 보다 앞에 있는 인덱스가 있다면, 쿼리는 해당 인덱스를 꼭 포함해야 합니다.
- 인덱스를 만들 때 모든 텍스트 인덱스 키는 인접해 있어야 합니다.

#### Collation 옵션

텍스트 인덱스는 [collation](https://docs.mongodb.com/manual/reference/bson-type-comparison-order/#collation) 을 지원하지 않습니다.

### 스토리지 요구사항과 성능관련 비용

- 텍스트 인덱스는 커질 수 있습니다. 유니크한 단어마다 하나의 인덱스 엔트리가 만들어집니다.
- 텍스트 인덱스를 만드는 것은 커다란 멀티 키 인덱스를 만드는 것과 비슷하게 느립니다.
- 이미 있는 컬렉션에 커다란 텍스트 인덱스를 만들 때 `open file descriptors` 제한이 크게 설정되어 있는지 확인하십시오.
- 텍스트 인덱스는 insert 쓰루풋에 영향을 줍니다.
- Additionally, text indexes do not store phrases or information about the proximity of words in the documents. As a result, phrase queries will run much more effectively when the entire collection fits in RAM.

## 텍스트 검색 지원

텍스트 인덱스는 [$text](https://docs.mongodb.com/manual/reference/operator/query/text/#op._S_text) 쿼리를 지원합니다.






- 



---