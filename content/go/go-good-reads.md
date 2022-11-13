---
title: "Go good reads"
date: "2022-09-18"
tags: ["go"]
---

## [Obscure Go Optimisations - Bryan Boreham](https://youtu.be/rRtihWOcaLI)

- Take-aways
	- Slice-to-interface cast will allocate.
	- Heap allocation is costly.
	- Generic methods are not fast.
	- Heap Ballast is dead.
	- Long live GOMEMLIMIT!

## [Fixing Memory Exhaustion Bugs in My Golang Web App](https://mtlynch.io/notes/picoshare-perf/)

Go 메모리 관련 OOM 버그를 수정하는 여정에 관한 이야기

디버깅 과정을 상세하게 공유해 주고 있으며,
특히 [Other lessons learned](https://mtlynch.io/notes/picoshare-perf/#other-lessons-learned) 와
[Dead ends](https://mtlynch.io/notes/picoshare-perf/#dead-ends) 파트에서 공유해준 내용에는 배울 점이 많습니다.
