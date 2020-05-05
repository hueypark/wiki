---
layout: post
title: "(Guide) Jordan Lewis's LARGE DATA BANK livestream: CockroachDB is learning the secret technique LISTEN/NOTIFY"
date: "2020-05-05"
tags: ["cockroachdb", "guide", "livestream"]
---

{{< rawhtml >}}
<iframe
	src="https://player.twitch.tv/?video=v608291326&parent=streamernews.example.com&autoplay=false"
	height="400"
	width="100%"
	allowfullscreen="true">
</iframe>
{{< /rawhtml >}}

[@JordanALewis](https://mobile.twitter.com/JordanALewis)는 매 주 토요일 새벽
4시에 카크로치디비 관련 라이브스트림을 진행하고 있습니다. 이번에는 PostgreSQL의 LISTEN/NOTIFY를
구현하고 있는데, 흥미로운 부분을 정리해 안내드립니다.

이슈: [sql: support NOTIFY, LISTEN, and UNLISTEN commands of postgresql](https://github.com/cockroachdb/cockroach/issues/41522)

PR: https://github.com/cockroachdb/cockroach/pull/48308

<!--more-->

### 흥미로운 부분

[01:10:15](https://www.twitch.tv/videos/608291326?t=1h10m15s) `\set auto_trace=on,kv` 명령어를 사용해 스토리지 레이어 디버깅에 도움이 되는 정보들을 출력합니다.

[01:24:39](https://www.twitch.tv/videos/608291326?t=1h24m39s) `yacc`를 사용해서 SQL 문법을 추가합니다. 새로운 SQL 문법을 추가하시고 싶은 분이시라면 큰 도움이 될 것 같습니다.

[02:33:26](https://www.twitch.tv/videos/608291326?t=2h33m26s) 카크로치디비에 컨트리뷰트 하는 방법을 공유합니다. (컨트리뷰트에 관심이 있으시면 [스프린트서울](https://www.sprintseoul.org)에 참가해 보십시오!)

[02:45:09](https://www.twitch.tv/videos/608291326?t=2h54m9s) `cdemo --logtostderr=info` 명령어를 이용해 더 많은 로그를 출력합니다. 디버깅에 도움이 될 것 같습니다.

[03:06:12](https://www.twitch.tv/videos/608291326?t=3h6m12s) 구글에서 `go remove from map`을 검색합니다. 평소에 제가 많이 하는 행동이라 친근감이 듭니다.

[03:47:32](https://www.twitch.tv/videos/608291326?t=3h47m32s) 아젠다를 설명합니다. 충분히 검증된 `Rangefeed`를 사용해 `LISTEN/NOTIFY`를 구현하고 있다고 말합니다.
