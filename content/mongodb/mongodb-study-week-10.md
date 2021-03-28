---
title: "MongoDB 스터디 10주차(트랜잭션)"
date: "2021-03-26"
tags: ["MongoDB"]
draft: true
---

# Transactions Under the Covers

## Low-level timestamps in MongoDB & WiredTiger

WiredTiger 스토리지 레이어는 Timestamp 메타데이터를 저장합니다. 이를 통해 특정 시간 이전 데이터만 쿼리할 수 었습니다.
또 트랜잭션이 같은 시간에 시작되게 하기 위한 스냅샷을 만들 수 있습니다.

# 참고자료

- Path to Transactions - WiredTiger Timestamps: https://youtu.be/mUbM29tB6d8
- MongoDB 4.2 Brings Fully Distributed ACID Transactions (MongoDB World 2019 Keynote, part 2): https://youtu.be/iuj4Hh5EQvo
- 홈페이지 ACID Transactions in MongoDB: https://www.mongodb.com/transactions