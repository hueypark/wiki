---
title: "MongoDB 스터디 7주차(MongoDB CURD 읽기 연산)"
date: "2021-02-27"
tags: ["MongoDB"]
draft: true
---

아직 작성중입니다.

---

# [db.collection.find()](https://docs.mongodb.com/manual/reference/method/db.collection.find/)


|Parameter|Type|Description|
|---|---|---|
|query|document|Optional. Specifies selection filter using query operators. To return all documents in a collection, omit this parameter or pass an empty document ({}).|
|projection|document|Optional. Specifies the fields to return in the documents that match the query filter. To return all fields in the matching documents, omit this parameter. For details, see Projection.|


## Returns:	A cursor to the documents that match the query criteria. When the find() method “returns documents,” the method is actually returning a cursor to the documents.

## cursor
A pointer to the result set of a query. Clients can iterate through a cursor to retrieve results. By default, cursors timeout after 10 minutes of inactivity. See Iterate a Cursor in the mongo Shell.

## [Query and Projection Operators](https://docs.mongodb.com/manual/reference/operator/query/)

## Embedded Field Specification
For fields in an embedded documents, you can specify the field using either:

- dot notation; e.g. "field.nestedfield": <value>
- nested form; e.g. { field: { nestedfield: <value> } } (Starting in MongoDB 4.4)

# [Iterate a Cursor in the mongo Shell](https://docs.mongodb.com/manual/tutorial/iterate-a-cursor/#read-operations-cursors)

Cursor
커서의 옵션 및 명령
Collation

## Read Concern
## Read Preference
comment

# [db.collection.findAndModify()](https://docs.mongodb.com/manual/reference/method/db.collection.findAndModify/)

Comparisons with the update Method
When updating a document, db.collection.findAndModify() and the update() method operate differently:

By default, both operations modify a single document. However, the update() method with its multi option can modify more than one document.

If multiple documents match the update criteria, for db.collection.findAndModify(), you can specify a sort to provide some measure of control on which document to update.

With the default behavior of the update() method, you cannot specify which single document to update when multiple documents match.

By default, db.collection.findAndModify() returns the pre-modified version of the document. To obtain the updated document, use the new option.

The update() method returns a WriteResult object that contains the status of the operation. To return the updated document, use the find() method. However, other updates may have modified the document between your update and the document retrieval. Also, if the update modified only a single document but multiple documents matched, you will need to use additional logic to identify the updated document.

When modifying a single document, both db.collection.findAndModify() and the update() method atomically update the document. See Atomicity and Transactions for more details about interactions and order of operations of these methods.