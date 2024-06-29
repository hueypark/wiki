---
title: "OLAP database query optimizer and performance"
date: "2024-02-23"
tags: ["database", "luft", "olap"]
layout: "slide"
draft: true
---

# OLAP database query optimizer and performance

---

## OLAP workloads

> Online analytical processing, or OLAP, is an approach to answer multi-dimensional analytical queries swiftly in computing.

https://en.wikipedia.org/wiki/Online_analytical_processing

---

## OLAP VS. OLTP: THE DIFFERENCES

> OLAP is used for complex data analysis, while OLTP is used for real-time processing of online transactions at scale.

https://www.snowflake.com/guides/olap-vs-oltp/

---

## Luft: OLAP database for Airbridge

https://engineering.ab180.co/stories/introducing-luft

---

## Airbridge dashboard demo

Let's take a look at what you'd do if you implemented.

1. Retention
2. Funnel

---

## TrailDB to Ziegel (C++ to GO)

https://marsettler.com/go/c++-to-go/

---

## Revisiting TODO

1. Remove TrailDB compatibility
2. More efficient memory management
3. Support very fast autoscale
4. Download partial column only if needed
    - Pre requirment for the very fast autoscale
5. User level filter

---

## 오늘 할 이야기

- Luft 성능 리포트 2:  더 많은 코호트에 대한 리텐션 집계
- 제안서: Luft 의 대형 쿼리 처리에 관하여
- AWS Lambda 를 활용한 Luft 스케일링

---

## Luft 성능 리포트 2
## 더 많은 코호트에 대한 리텐션 집계

https://engineering.ab180.co/stories/luft-performance-report-2
 

---

## 제안서: Luft 의 대형 쿼리
## 처리에 관하여

https://engineering.ab180.co/stories/luft-query-optimizer-and-scale

---

## AWS Lambda 를 활용한
## Luft 스케일링

https://engineering.ab180.co/stories/luft-task-executor-with-aws-lambda

---

## Q & A

---

## Reference

- [Luft: 유저 행동 분석에 최적화된 OLAP 데이터베이스](https://engineering.ab180.co/stories/introducing-luft)
- [C++ to Go: Introducing Ziegel](https://marsettler.com/go/c++-to-go/)
- [Luft 성능 리포트 2:  더 많은 코호트에 대한 리텐션 집계](https://engineering.ab180.co/stories/luft-performance-report-2)
- [제안서: Luft 의 대형 쿼리 처리에 관하여](https://engineering.ab180.co/stories/luft-query-optimizer-and-scale)
- [AWS Lambda 를 활용한 Luft 스케일링](https://engineering.ab180.co/stories/luft-task-executor-with-aws-lambda)
