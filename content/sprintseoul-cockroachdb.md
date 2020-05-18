---
layout: post
title: "스프린트서울 참가자분들을 위한 카크로치디비(CockroachDB)"
date: "2020-02-20"
tags: [cockroachdb, sprint]
---

### 스프린트에 참가하는 이유

왜 스프린트에 참가하시나요? 참가할 때마다 여러가지 이유를 생각해보지만 정답이 있는 문제는 아닙니다. 저는 처음 스프린트에 참가하며 다음과 같은 동기를 가지고 있었습니다.

1. `Go` 언어 개발능력을 향상시키고 싶었습니다.
2. 가까운 미래에 애플리케이션 개발을 위해 단단하고 확장가능한 데이터베이스를 사용하고 싶었습니다.

아직 목표를 완전히 이룬 것은 아니지만 스프린트서울에 처음 참가한 2019년 6월보다는 한 걸음 나아가 있습니다.

당신에게는 어떤 목표가 있나요? 저보다 더 멋진 목표와 동기가 있을 것으로 기대됩니다. 댓글로 저에게도 알려주십시오!

### 카크로치디비

카크로치디비는 `Go`로 작성된 수평확장 가능한 관계형 데이터베이스로, 관계형 데이터베이스의 편의성과 NoSQL이 가진 확장성을 동시에 제공합니다.

### 아주 좋은 첫 이슈

작업방향이 분명한 이슈를 모으고, 간략한 설명을 추가해보았습니다. 첫 이슈를 선택할 때 참고해보십시오.

* [#41274 sql: Support aggregate functions for statistics](/cockroachdb-issue-41274-vgfi-sql-support-aggregate-functions-for-statistics) * 링크에 세부내용 있음
* [pebble #660 tool: improve LSM visualization performance](https://github.com/cockroachdb/pebble/issues/660) 카크로치디비는 최근 스토리지 엔진을 `Go`로 다시 작성하고 있습니다. 성능 관련 시각화를 진행하고 있는데 `D3` 또는 `웹 프론트엔드` 전문가 분의 도움을 원하고 있네요.
* 카크로치디비는 최근 Geospatial 관련 함수를 구현하기 시작했습니다. 카크로치디비의 [올리버](https://github.com/otan)가 정리한 이슈 중 `E-easy`를 선택하는 것도 현명한 전략입니다.
	* [A-geography-builtins](https://github.com/cockroachdb/cockroach/labels/A-geography-builtins)
	* [A-geometry-builtins](https://github.com/cockroachdb/cockroach/labels/A-geometry-builtins)
	* [A-geometry-creations](https://github.com/cockroachdb/cockroach/labels/A-geometry-creation-builtins)
* [#44135 sql: add support for COMMENT ON VIEW, COMMENT ON SEQUENCE](/cockroachdb-issue-44135-sql-add-support-for-comment) * 링크에 세부내용 있음

### 커뮤니티 슬랙

[카크로치디비 커뮤니티 슬랙](https://join.slack.com/t/cockroachdb/shared_invite/zt-aeziijg1-QVzpA6nZfunDOObCWYcvUw)에서는 카크로치디비와 관련된 이야기를 자유롭게 할 수 있습니다. 이번 스프린트 서울 이벤트를 위해 `event-sprint-seoul` 채널을 추가했으니 참석해주시기 바랍니다.

### 조단의 라이브코딩

[조단](https://mobile.twitter.com/JordanALewis)은 매주 토요일 새벽 4시에 카크로치디비 개발관련 라이브방송을 [트위치](https://www.twitch.tv/large__data__bank)을 진행하고 있습니다. 또 6월 4일 새벽 1시 카크로치디비에 기여하는 방법이란 주제로 [온라인 이벤트](https://www.eventbrite.com/e/how-to-contribute-to-cockroachdb-tickets-105421279886)를 준비하고 있으니 많은 관심 부탁드립니다.
