---
title: "뉴스피드 2020"
date: "2020-11-25"
tags: ["newsfeed"]
---

흥미롭게 본 이야기를 정리합니다.

## 2020년 11월

### Unite Europe 2016 - Building a PvP focused MMO

비디오 링크: https://youtu.be/x_4Y2-B-THo

PVP가 중심인 MMO 게임 알비온 온라인 개발에 관한 이야기입니다.

알비온 온라인이 이브 온라인과 리그 오브 레전드의 현대적인 해석이라고 소개하고 시작합니다.

> Albion Online is a modern interpretation of EVE Online with the skill based combat from Leafue of Legends

미들웨어는 아래와 같이 사용했습니다.
- 클라이언트: Unity
- 데이터베이스: Cassandra, Postgres
- 네트워크: Photon

툴과 스트레스 테스트 봇 제작을 위해 클라이언트는 Unity 없이도 동작하게 개발되었습니다.

> Ideally, client works without Unity, too!

성능목표는 300명 이상으로 잡고 있습니다.

> ~500 mobs / cluster

> \> 10,000 game objects (e.g. trees)

> up to 300 players

### gcassert

프로젝트 링크: https://github.com/jordanlewis/gcassert

Go 컴파일 타임에 assert를 발생시키는 패키지입니다. `//gcassert:inline` 와 같은 방식으로 사용가능하며, Go로 퍼포먼스를 끝까지 짜내는 과정을 볼 수 있습니다.

GopherCon 에서의 소개영상: https://www.youtube.com/watch?v=YGREMxpodN8&feature=youtu.be&t=1612
