---
layout: post
title: "피터 매티스와의 인터뷰 - Software Engineering Daily"
date: "2020-02-20"
tags: ["cockroachdb"]
---

카크로치 연구소의 피터 매티스가 소프트웨어 엔지니어링 데일리와 인터뷰를 진행했습니다. 몇 가지 흥미로운
부분을 요약해 정리했으며, 전체 내용은 [소프트웨어 엔지니어링 데일리](https://softwareengineeringdaily.com/2020/04/28/cockroachdb-with-peter-mattis/)에서
들을 수 있습니다.

<!--more-->

---

[00:04:55] 구글의 빅테이블, 스패너 개발과정에 관해 이야기합니다. 내부의 필요에 의해 스토리지에 기능이 추가되는 과정이 흥미롭습니다.

[00:35:16] 전용 스토리지 엔진인 [페블](https://github.com/cockroachdb/pebble)에 대해 이야기합니다. 초기에는 이미 개발되어 있는 스토리지 엔진을 사용하는 것이 좋았지만, 전용 스토리지 엔진을 사용하여 특화된 문제를 쉽게 해결하려고 합니다.

[00:44:25] 카크로치 클라우드에 대한 이야기합니다. AWS나 GCP를 사용하게 설정할 수 있으며, [소프트웨어 엔지니어링 데일리](https://softwareengineeringdaily.com/2020/04/28/cockroachdb-with-peter-mattis/)에서 링크를 통해 30일 체험을 제공하고 있습니다.
