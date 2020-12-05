---
title: "뉴스피드 2020"
date: "2020-11-25"
tags: ["newsfeed"]
---

흥미롭게 본 이야기를 정리합니다.

## 2020년 12월

### 한상구 네트워크 필드 엔지니어님의 네트워크 기초이론

링크: https://ssanggu.github.io/ch0/

네트워크 기초이론에 대한 정리가 잘 되어 있습니다.

### Relative Disarray (Zerg Debuff)

링크: https://forum.albiononline.com/index.php/Thread/141218-Relative-Disarray-Zerg-Debuff/

Relative Disarray(또는 Zerg Debuff)는 같은 지역에 25명 이상의 연합원이 모여 있을 때 적용되는 디버프입니다. 연합원 수에 따라 공격력과 CC 지속시간을 감소시킵니다. 

아마도 좁은 지역에 너무 많은 유저가 모이는 것을 기획적으로 막고자 한 것 같은데 더 좋은 방법은 없을까 고민해봅니다.

### 소득 수준을 좌우하는 가장 중요한 자질

링크: https://brunch.co.kr/@haneulalice/185

경제활동을 하는 사람들을 5개 그룹(노동자, 임플로이, 리더, 창업가, 사업가)으로 나눈 후 그에 대해 이야기하고 있습니다. 나는 어떤 그룹에 속하는지 고민해보는 시간이었습니다.

특히 이 부분이 기억에 남습니다.

> 그런데 리더가 되면서 회사의 성장이 아니고, 거의 회사의 존속을 좌우하는 위치에서 내가 방향과 방법을 생각해야 하는 위치에 서게 되니까, 처음으로 내가 이 일을 잘해서 목표를 이루어야겠다가 아니고, 잘하는 사람을 통해서 이 일을 이뤄야한다로 바뀌는게 느껴졌거든요.

### Rise of Avalon Patch 10 is Here

링크: https://albiononline.com/en/news/rise-of-avalon-patch-10-is-here

클러스터가 꽉 차면 대기열에서 기다리지 않고 근처로 넘어갈 수 있게 되었습니다. 전투가 여려 클러스터에서 동시에 진행될 수 있을 것으로 기대됩니다.

> When a cluster is overcrowded and the Smart Cluster Queue activates, players can now either join the queue or skip the overcrowded cluster entirely. Additionally, the distance players can move from the entrance before being kicked from the queue has been greatly increased.


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
