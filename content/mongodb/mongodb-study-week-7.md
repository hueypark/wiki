---
title: "MongoDB 스터디 7주차(MongoDB CURD 읽기 연산)"
date: "2021-02-27"
tags: ["MongoDB"]
draft: true
---

아직 작성중입니다.

---

# [db.collection.find()](https://docs.mongodb.com/manual/reference/method/db.collection.find/)

쿼리 기준과 일치하는 도큐먼트에 대한 커서를 반환합니다.

|파라미터|설명|
|---|---|
|query|Optional. 필터에 사용할 쿼리 연산자입니다.|
|projection|Optional. 도큐먼트에서 반환할 필드를 지정합니다. 생략하면 모든 필드가 반환됩니다.|

반환: 쿼리 기준과 일치하는 도큐먼트에 대한 커서를 반환합니다.

# [db.collection.findAndModify()](https://docs.mongodb.com/manual/reference/method/db.collection.findAndModify/)

도큐먼트를 업데이트할 때 `db.collection.findAndModify()` 와 `update()` 는 다르게 동작합니다:

- 기본적으로 둘 다 단일 도큐먼트를 업데이트합니다. 그러나 `update()` 는 `multi` 옵션을 사용해 여러 문서를 업데이트 할 수 있습니다.

- 대상이 되는 도큐먼트가 다수일때 `findAndModify()` 는 `sort` 옵션을 사용해 대상을 선택할 수 있습니다.

- 기본적으로 `findAndModify()` 는 업데이트 전의 문서를 반환합니다. 업데이트 된 문서를 얻으려면 `new` 옵션을 사용하십시오. `update()` 는 작업 상태만 포함된 `WriteResult` 객체를 반환합니다. 업데이트 문서를 확인하려면 `find()` 명령을 사용하십시오(그 사이에 다른 업데이트에 의해 문서가 수정되었을 수 있습니다.).
