---
layout: post
title: "스프린트서울 첫 참가"
date: 2019-06-30
tags: [cockroachdb, sprint]
---

작년 11월부터 카크로치디비에 [기여](https://github.com/cockroachdb/cockroach/pulls?q=is%3Apr+author%3Ahueypark)하고 있습니다. 한국에는 관련 커뮤니티나 정보가 부족해 답답해 하고 있었는데, [스프린트서울](https://www.sprintseoul.org/)이라는 행사를 알게되어 참가했습니다.

<!--more-->

스프린트서울은 스프린트를 아래처럼 정의하고 있습니다.
> 스프린트는 오픈소스 프로젝트의 작성자 또는 기여자와 함께 짧은 시간 동안 함께 문제를 찾고 해결하며, 해당 오픈소스 프로젝트에 대해 보다 깊게 알아가는 행사입니다.

다른 오픈소스 기여자들에 대한 궁금증이 가장 큰 참가 동기여서 때문에 별다른 준비는 하지 않고 참가했습니다. 평소 데스크탑(리눅스)으로 개발을 하고 있어 노트북(윈도우)에 리눅스 vm을 설치하는 정도였는데 매우 불편해 [WSL2](https://devblogs.microsoft.com/commandline/wsl-2-is-now-available-in-windows-insiders/)를 위해 윈도우즈 인사이더를 설치해볼까 하는 생각이 들었습니다.

같이 참한 다른 리더분들은 프로젝트를 홍보하고 기여자를 늘리기 위해 대해 많이 준비한 것처럼 보였습니다. [안내문](https://gist.github.com/dahlia/c91d0ad45db0f0074feedc7c8a739d67)을 만들고,
[행사만을 위한 프로젝트](https://github.com/orgs/planetarium/projects/11)를 준비했으며, 기여에 필요한 정보를 적극적으로 공유했습니다.

저는 카크로치디비의 고유ID 생성방식에 대한(Serial에서 UUID로 변환) [이슈](https://github.com/cockroachdb/docs/issues/4234)를 살펴보았는데, 코드 수정보다 해당 수정이 유의미한가를 확인하기 위한 부하 테스트 환경을 구성하는 데 오랜 시간이 걸렸습니다. 지금까지의 테스트로는 변환 자체가 무의미한 것으로 확인되어 PR은 만들지 못하고 댓글만 추가했습니다.

하지만, [박현우](https://github.com/lqez)님이 [활약](https://github.com/cockroachdb/cockroach/pulls/lqez)해주어, 한국에서 만들어진 PR이 두 개 더 생겨 보람찼습니다.


끝나고 [PR 기록](https://github.com/sprintseoul/history/blob/master/201906.md)을 살펴보는데 LibreOffice의 한글화 시도가 인상적이었습니다. 작년부터 [카크로치디비 한글화 이슈](https://github.com/cockroachdb/docs/issues/4053)가 방치되고 있는데 19.1 문서를 [통채로 번역](https://github.com/hueypark/docs)해 다시 한 번 요청을 해볼 생각입니다.

다음 참가에는 이런 일을 더 해보고 싶습니다.
- 카크로치디비를 더 홍보
- 적절한 난이도의 이슈를 미리 식별해 행사 당일에 공유
- 한글화 함께 진행

---

### 덧붙이는 말

- [한국 카크로치디비 사용자 그룹](https://www.facebook.com/groups/cockroachdb.kr/) 가입해주세요! 카크로치디비 관련 정보와 이후에 진행될 한글화 진행상황을 공유하고자 합니다.
- 앞으로 번역에는 [Muchtrans](https://muchtrans.com/)를 사용해 볼까 고민중입니다.
- 파이콘 2019 스프린트는 진행자 신청기간이 종료되어 참가하지 못하는 것이 안타깝습니다.
