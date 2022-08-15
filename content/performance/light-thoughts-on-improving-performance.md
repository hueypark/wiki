---
title: "성능 개선에 관한 가벼운 생각들"
date: "2022-08-07"
tags: [performance]
layout: slide
draft: true
---

## 목차

---

## 최척화 작업이 업무의 대부분이 될 때도 있을까?

---

## 최적화를 언제 하나?

- 어쩔 수 없을 때
	- [[오시영의 겜쓸신잡] ‘사진 한 장’보다 게임 용량이 작다고요?](https://it.chosun.com/site/data/html_dir/2020/09/18/2020091803183.html)
	- 현시대의 장비도 어쩔 수 없는 경우가 많다
- 비용

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

### 

- [〈야생의 땅: 듀랑고〉 서버 아키텍처 Vol. 3](https://www.slideshare.net/sublee/vol-3-95472828)
- [각국 유저들의 성향은? ‘야생의 땅: 듀랑고’ 글로벌 서비스 인포그래픽 공개f](https://www.inven.co.kr/webzine/news/?news=222815&iskin=1)
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
