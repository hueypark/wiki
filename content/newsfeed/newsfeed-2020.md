---
title: "뉴스피드 2020"
date: "2020-11-25"
tags: ["newsfeed"]
---

## 2020년 12월

### Disagree and commit

[이병준](https://mobile.twitter.com/bjlee72)님의 [면접시 조심하면 좋은 것들](https://youtu.be/SZEHjcDSEdE) 중 일부

링크: https://youtu.be/SZEHjcDSEdE?t=183

> 자기가 동의하지 않는 내용이라도 팀원의 한 사람으로서 동의를 했다면 그 동의한 내용을 반드시 따라야 한다.

### [기계인간](https://mobile.twitter.com/John_Grib)님의 개발자의 성격 이야기

어떤 역할을 하느냐에 따라 조금씩 다르겠지만, 개발자도 적극적이어야 할 필요가 있다는 점에서 크게 공감합니다.

> 사람마다 회사생활하며 느낀바는 다르겠지만 개발자는 어느 수준부터는 축구선수같길 요구받는다. 내가 수비수라고 수비만 하면 안된다. 내가 공격해야 하는 상황일 땐 공 차고 나가면서 골도 넣을 수 있어야 한다. 소극적인 내 성격에 개발자가 딱인줄 알았는데 경력 쌓이고 보니 오산이었다.

### semgrep-go

링크: https://github.com/dgryski/semgrep-go

이상한 Go 코드의 패턴을 탐지하는 유틸리티입니다. [Damian Gryski](https://mobile.twitter.com/dgryski)의 [트윗](https://mobile.twitter.com/dgryski/status/1337166486025060353)에서 아래와 같이 잘못된 에러를 반환하는 코드를 탐지하는 것을 소개합니다.

```go
if rows.Err() != nil {
   return nil, err        // <-- not the error from rows
}
```

### [박현우](https://mobile.twitter.com/lqez)님의 직무기술서 이야기

링크: https://twitter.com/lqez/status/1339816860540256257?s=20

> 직무기술서(JD) 쓰기 귀찮은 거 나도 안다. 하지만 회사 소개가 노션 페이지 하나 뿐이고, JD도 없는데 아는 사람이 한다는 이유 만으로 다른 사람에게 추천하기는 어렵다. 초창기 스타트업에서 어떻게 그걸 챙기냐고 반문하기도 하는데, 그럼 좋은 사람 뽑는 일보다 더 중요한 일은 무엇일까?

### 알비온 온라인 개발자 한마디: 연말 업데이트

링크: https://albiononline.com/ko/news/devtalk-year-end-update

알비온 온라인의 `개발자 한마디: 연말 업데이트`입니다. 2020년을 돌아보고 2021년 계획을 알려주는데 그 중 흥미로운 내용을 기록합니다.

장비 세트를 한 번에 착용하고 구입하면 편하겠군요.

> 캐릭터에서 장비 세트를 저장, 공유 및 빠른 장착을 허락하는 장비 세트

드디어... 전부 사용하기가 생깁니다.

> 서적과 실버 주머니의 오래 된 편의성 문제인 "전부 사용하기" 기능

은신처 외에 더 많은 건축물이 생기는 걸까요?

> 일반적으로 길드의 경우, 우리는 은신처를 확장하여 오픈 월드 건축물을 추가함으로써 길드가 영지를 보호하고, 자원을 수집 하며, 오픈 월드에서의 전투 지원을 제공하고자 합니다.

### 매우 보수적인 재화 밸런스로 예상하지 못 한 경제붕괴에 대응

`꽃등심TV의 [뱅송온] 엘리온 골드 & 시장 경제가.. 이상하게 돌아간다..?` 중 일부

링크: https://youtu.be/SWX-VBDzz-U?t=10290

부케작으로 붕괴되는 것이 정상일 정도로 많은 골드가 게임 내에 풀렸지만, 경제가 유지되고 있는 이상한 현상에 대해 이야기하고 있습니다. 처음부터 부케작을 예상하지는 못했을 생각되며, 매우 보수적인 재화 밸런스로 예상하지 못한 이슈로 인한 경제붕괴에 대응한 사례로 생각됩니다.

### 프레임을 떨어뜨려서 게임의 사용자 경험을 개선

`유영천님의 (socket + C/C++기반의)실시간 게임서버 최적화 전략` 중 일부

링크: https://youtu.be/LBo_rKN_e-I?t=5290

> 현재 처리 가능한 수준의 프레임 레이트를 판단, 30fps -> 15fps로 게임 프레임 레이트를 낮춘다. 전체적으로 정밀도가 조금 떨어지지만 게임 플레이에 치명적인 지연은 발생하지 않는다.

### 중형 탈 것(엘리온 마갑기) 연출

`김실장님의 오랜만에 PC MMORPG 엘리온 오픈, 어떤 게임인지 살펴봅시다` 중 일부

링크: https://youtu.be/GOfooTFvlr8?t=20378

중형 탈 것 연출을 살펴볼 수 있습니다. 창세기전의 마장기가 떠오르는 연출이네요.

### 도메인 지식의 중요성

`이병준님의 큰 회사 개발자의 핵심 직무 역량은?` 중 일부

링크: https://youtu.be/_b4b1EsYx8E?t=320

> 시스템의 복잡성이 어느 방향으로 진화할지 알 수 없기 때문에, 프로덕트가 개발되고 있는 도메인을 잘 이해하고, 그 도메인 내에서 내가 개발하는 프로덕트가 어떤 방향으로 진화해나가게 될지, 그 진화되는 과정에서 어떤 피쳐들이 추가가 될지 이런 것들을 유심히 살펴보고 그것에 맞게 나에게 주어진 과제들을 처리해나갈 수 있는 능력, 이게 되게 중요하다고 할 수 있습니다.

### 바이투플레이와 작업장의 연관성?

`오랜만에 PC MMORPG 엘리온 오픈, 어떤 게임인지 살펴봅시다` 중 일부

링크: https://www.youtube.com/watch?v=GOfooTFvlr8&feature=youtu.be&t=839

바이투플레이로 작업장은 막을 수 없습니다. 비용보다 더 많은 수익을 획들할 수 있는 방법이 게임에 존재하면 작업장은 생깁니다.

### BM 구성을 되게 못하는 회사에 관한 이야기

`(LONG) (매몰비용 1편) 개발사는 알고있다, 당신이 온라인 게임을 쉽게 접지 못하는 이유 중` 중 일부

링크: https://www.youtube.com/watch?v=wMsFZt-N2gI&feature=youtu.be&t=1350

아직 게임에 대한 이해나 호감이 생기도 전에 강압적인 구매유도를 하는 것은 유저에게 부정적인 경험만 줍니다.

### CentOS Project shifts focus to CentOS Stream

링크: https://blog.centos.org/2020/12/future-is-centos-stream/

CentOS가 8 버전 지원기간을 2021년 12월로 축소하고 Stream 버전에 집중하겠다는 발표를 합니다. 해당 공지의 댓글에서 사용자들은 분노하고 있습니다.

바보같은 일이다. CentOS를 사용하는 유일한 이유는 RHEL를 재빌드하기 때문이었다. 망친 거 축하한다, 멍청이.

> This is dumb. The entire premise and the only reason anyone uses CentOS is because it's rebuilt RHEL. Congratulations on undermining that, nitwits.

기존 CentOS와 동일한 역할을 하게 될 배포판 저장소인 [Rocky Linux](https://github.com/rocky-linux/rocky)가 매우 빠르게 만들어졌습니다. README.md 있는 상황에서 4,500k 스타를 가지고 있네요. CentOS와 같은 배포판을 필요로 한다면 관심있게 지켜봐야 할 것 같습니다.

### SQL JOIN은 벤 다이어그램? 이제는 그만!

링크: https://velog.io/@public_danuel/sql-join-is-not-venn-diagram

이해가 잘 가는 SQL JOIN 동작방식 설명입니다.

### Lecture 14 - How to Operate (Keith Rabois)

링크: https://youtu.be/6fQHLK1aIBs

한국어 정리 링크: https://www.notion.so/How-to-operate-b7a3f2591bd043dd81ef0861f47035d7

매니저가 조직을 운영하는 방법에 관해 이야기합니다. Writer가 아니라 Editor로서의 역할을 강조하고 있습니다.

### 왜 드라군만 유독 멍청할까?

링크: https://youtu.be/t2PXgu3G91E

길찾기와 관련해서 드라군이 왜 멍청한지에 대해 설명하는 영상입니다.
A* 알고리즘과 스타크래프트에서 사용하는 패스파인더 리전에 관해 역으로 분석해 설명하는 모습이 인상적이었습니다.

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
