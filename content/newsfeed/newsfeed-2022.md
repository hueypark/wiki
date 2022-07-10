---
title: "뉴스피드 2022"
date: "2022-06-03"
tags: ["newsfeed"]
---

## 2022년 7월

### 스타트업은 유치원이... 시리즈를 읽고

- 링크
	- [스타트업은 유치원이 아닙니다.](https://medium.com/@kurtlee/%EC%8A%A4%ED%83%80%ED%8A%B8%EC%97%85%EC%9D%80-%EC%9C%A0%EC%B9%98%EC%9B%90%EC%9D%B4-%EC%95%84%EB%8B%99%EB%8B%88%EB%8B%A4-7fad4b48e87f)
	- [스타트업은 유치원과 비슷합니다.](https://velog.io/@zetlos/%EC%8A%A4%ED%83%80%ED%8A%B8%EC%97%85%EC%9D%80-%EC%9C%A0%EC%B9%98%EC%9B%90%EC%9E%85%EB%8B%88%EB%8B%A4)
	- [회사는 유치원이 아니다'라는 글을 보고 한마디 썼었는데...](https://www.facebook.com/cjunekim/posts/pfbid021jtvbMgi3e6wdYVUtAqVerWWAWoeFZdXT1mkUc5YwYAaVoKaFjwEGYTVBHzUzjQEl)

### DRI(Directly Responsible Indivisual)

[토스에서의 시간을 돌아보며](https://evan-moon.github.io/2022/05/07/toss-retrospective/) 라는 글을 읽다 DRI(Directly Responsible Indivisual) 라는 개념이 신기해 기록을 남깁니다.

> 토스에서 DRI라는 것은 일종의 신성불가침영역과도 같다. 어떤 DRI를 맡고 있다는 것은 동료들이 해당 업무에 대한 그 사람의 능력에 대해 신뢰하고 있다는 것이고, DRI를 잃는다는 것은 동료로부터 신뢰를 잃어 더 이상 토스팀에 필요없는 사람이 되는 것과 마찬가지이기 때문에 다들 죽기살기로 자신의 DRI를 지켜내기 위해 동료로부터 신뢰를 얻고 팀에 도움이 되려고 노력한다.

### 넥슨코리아 신규개발본부 ER 서버유닛 정성훈님께서 해주신 멀티플레이 게임 동기화 관련 발표

멀티플레이 게임을 개발해보기 전에는 상상하기 어려운 부분들을 정리해 공유해주셨습니다.

> 예측과 보정을 통한 자연스러운 동기화

링크: [[NDC22-프로그래밍] 실시간 MMORPG의 플레이 감각을 날카롭게 벼려보자!](https://youtu.be/HSRo7TAV4T4)

### 쿠키런: 킹덤, 총 56시간의 긴급 점검 회고

데브시스터즈에서 쿠키런: 킹덤 긴급 점검 회고를 해주셨습니다.\
CockroachDB 를 사용한 것으로 알고 있어 개인적으로 관심이 컸는데 공유해 주신 것에 감사드립니다.

> 이미 2주간 밤을 샌 엔지니어가 작업을 하다가...\
> 작업 중 의도치 않은 Configuration 이슈 발생

> AWS 데이터 센터 냉각 유닛 정전으로\
> 12분에 걸쳐 킹덤 데이터베이스\
> 6대가 작동 불능이 됨

> 데이터센터 냉각 시스템 고장으로 DB 60대 중 6대가 사망했다.\
> 소실된 range들의 replica 7개 중 4개 이상이\
> 하필 사망한 6대에 분포되어 있을 확률을 구하시오. (3점)
> \
> DB 60대 중 6대 사망\
> 25000개 Range 중 34개 소실\
> 그 중 유저 데이터 관련 Range는 2개\

링크: [[NDC22-프로그래밍] 쿠키런: 킹덤, 총 56시간의 긴급 점검 회고](https://youtu.be/AZbCZ2KOcwU)

## 2022년 6월

### Redis Sorted Set 을 활용한 처리율 제한기 구현에 관한 글입니다.

링크: [Better Rate Limiting With Redis Sorted Sets](https://engineering.classdojo.com/blog/2015/02/06/rolling-rate-limiter/)
