---
title: "성능 개선에 관한 가벼운 생각들"
date: "2022-08-07"
tags: [performance]
layout: slide
draft: true
---

## 가정

우리는 놀라운 속도로 성장할 것이다.

---

## 왜 하는가?

1. 비용
	- 고정비와 변동비
2. 최소 요구사항
	- 콘솔 게임과 하드웨어 성능이 고정되어 있는 환경
	- 하드웨어의 발전보다 우리 서비스 발전이 빠를 수도 있다
3. 성능에 대한 부담으로 느려기는 개발속도?

---

## 변동비가 크다면

### 쏘카 사례

- https://brunch.co.kr/@jyzz21/14
- https://www.newswatch.kr/news/articleView.html?idxno=59899
- [증권신고서](https://dart.fss.or.kr/dsaf001/main.do?rcpNo=20220624000264)

---

## 측정의 중요성

## Go 로 C++ 보다 빠른 프로그램을 작성할 수 있나?

## C++ 은 왜 빠른가?

### ++i 가 빠를까 i++ 이 빠를까?

[C++ Weekly - Ep 311 - ++i vs i++](https://youtu.be/ObVRSNvGitE)

[Compiler Explorer](https://godbolt.org/z/1oW5voTYY)

### constexpr

[C++ Weekly - Ep 312 - Stop Using `constexpr` (And Use This Instead!)](https://www.youtube.com/watch?v=4pKtPWcl1Go)

[Compiler Explorer](https://godbolt.org/z/dcd5r6scr)

## Go benchmark

https://blog.logrocket.com/benchmarking-golang-improve-function-performance/
