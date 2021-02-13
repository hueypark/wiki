---
title: "MongoDB 스터디 5주차(패턴과 안티패턴)"
date: "2021-02-10"
tags: ["MongoDB"]
---

아직 작성중입니다.

---

## Pattern

### Handling Duplication, Staleness and Integrity

- Duplication
	- Why?
		- Result of embedding information in a given document for faster access
	- Concern
		- Challenge for correctness and consistency
	- case
		- is solution
		- has minimal effect(unchanging information)
		- should be handled(precomputed sum, application handled)
accepting staleness in some pieces of data,
writing extra application side logic to ensure referential integrity.

- Staleness
	- Why?
		- New events come along at such a rate that updating some data constantly causes peformance issues
	- Concern
		- Data quality and reliablity
	- case
		- use secondary
		- batch updates
		- use change stream

- Referential integrity
	- Why?
		- Linking information between documents or tables
		- No support for cascading deletes
	- Concern
		- Challenge for correctness and consistency
	- case
		- Change Streams
		- Single Document
		- Multi documents transction

### Attribute Pattern

- Problem
	- List of similar fields
	- Want to search across many fields at once
	- Fields present in only a small subset of documents
- Solution
	- Break  the field/value into sub-document with:
		- fieldA: field
		- fieldB: value
	- Example
```json
"specs": [
    { k: "volume", v: "500", u: "ml" },
    { k: "volume", v: "12", u: "ounces" }
]
```
- Benefits and Trade-Offs
	- Easier to index
	- Allow for non-deterministic field names
	- Ability to qualify the relationship of the original field and value

### Extended Reference Pattern

- Embed the "One" side, of a "One-to-Many" relationship, into "Many" side

- only the part that we need to join often

- Proplem
	- Too many repetitive joins
- Solution
	- Identify fields on the lookup side
	- Bring those fields into the main object
- Benefits
	- Faster reads
	- Reduce number of joins and lookups
- Trade-Offs
	- May introduce lots of duplication if extended reference contains fields that mutate a lot

### Subset Pattern

- Problem
	- Working set is too big
	- Lot of pages are evicted from memory
	- A larget part of documents is rarely needed
- Solution
	- Split the collection in 2 collections
		- Most used part of documents
		- Less used part of documents
	- Duplicate part of a 1-N or N-N relationship that is often used in the most used side
- Benefits
	- Smaller working set, as often used documents are smaller
	- Shorter disk access for bringing in additional documents from the most used collection
- Trade-Offs
	- More round trips to the server
	- A little more space used on disk

### Computed Pattern

- Problem
	- Costly computation or manipulation of data
	- Executed frequently on the same data, producing the same result
- Solution
	- Peform the operationand store the result in the appropriate document and collection
	- If need to redo the operations, keep the source of them
- Benefits
	- Read queries are faster
	- Saving on resources like CPU and Disk
- Trade-Offs
	- May be difficult to identify the need
	- Avoid applying or overusing it unless needed

### Bucket Pattern

- Problem
	- Avoiding too many documents, or too big documents
	- A 1-to-Many relationship that can't be embedded
- Solution
	- Define the optimal amount of information to group together
	- Create arrays to store the information in the main object
	- It is basically an embedded 1-to-Many relationship, where you get N documents, each having an average of Many/N sub documents
- Benefits
	- Good balance between number of data access and size of data returned
	- Makes data more manageable
	- Easy to prune data
- Trade-Offs
	- Can lead to poor query results in not designed correctly
	- Less friendly to BI Tools

### Shcema Versioning Pattern

- Problem
	- Avoid downtime while doing schema upgrades
	- Upgrading all documents can take hours, days or even weeks when dealing with big data
	- Don't want to update all documents
- Solution
	- Each document get a "schema_version" field
	- Application can handle all versions
	- Choose your strategy to migrate the documents
- Benefits
	- No downtime needed
	- Feel in control of the migration
	- Less future technical debt
- Trade-Offs
	- May need 2 indexes for same field while in migration period

### Polymorphic Pattern

- Problem
	- Objects more similar than different
	- Wnat to keep objects in same collection
- Solution
	- Field traks the type of document or sub-document
	- Application has different code paths per document type, or has subclasses
- Benefits
	- Easier to implement
	- Allow to query across a single collection

## Anti-patterns

[Massive arrays](https://developer.mongodb.com/article/schema-design-anti-pattern-massive-arrays/): storing massive, unbounded arrays in your documents.

- Problem
	- 16 MB document size limit
	- Index performance on arrays decreases as array size increases

[Massive number of collections](https://developer.mongodb.com/article/schema-design-anti-pattern-massive-number-collections/): storing a massive number of collections (especially if they are unused or unnecessary) in your database.

- Problem
	- Empty and unused indexes drain resources
	- WiredTiger performance decreases with an excessive number of collections and indexes

Limit each replica set to 10,000 collections

- Collections To Drop
	- Empty collections
	- Collections whose size is mostly indexes

[Unnecessary indexes](https://developer.mongodb.com/article/schema-design-anti-pattern-unnecessary-indexes/): storing an index that is unnecessary because it is (1) rarely used if at all or (2) redundant because another compound index covers it.

- The Problem
	- Indexes take up space
	- Indexes impact storage engine performance
	- Indexes impact write performance

Limit each collection to 50 indexes.

Indexes to Drop
	- Rarely used indexes
	- Redundant indexes

- Summary
	- Do: Create indexes that support frequent queries
	- Don't: Create unnecessary indexes

[Bloated documents](https://developer.mongodb.com/article/schema-design-anti-pattern-bloated-documents/): storing large amounts of data together in a document when that data is not frequently accessed together.

WiredTiger는 인덱스와 자주 쓰는 도큐먼트를 캐시한다

- Summary
	- Do: Store data together that is accessed together
	- Don't: bloat your documents with related data that isn't accessed together

[Separating data that is accessed together](https://developer.mongodb.com/article/schema-design-anti-pattern-separating-data/): separating data between different documents and collections that is frequently accessed together.

$lookup
	- Joins data from more than one collection
	- Great for rarely used queried or analytical queries

- Problem
	- $lookup can be slow and resource-intensive

Data that is accessed together should be stored together 

Case-insensitive queries without case-insensitive indexes: frequently executing a case-insensitive query without having a case-insensitive index to cover it.
