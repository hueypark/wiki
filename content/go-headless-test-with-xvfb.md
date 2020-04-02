---
title: "xvfb를 이용한 Go headless 테스트"
date: "2020-04-02"
tags: ["go"]
---

Go에서 [GLFW](https://github.com/go-gl/glfw) 등을 이용해 그래픽스 관련 작업을 할 때에도 자동화
테스트 구성이 가능합니다. 하지만 [GitHub Actions](https://github.com/features/actions)과 같이
디스플레이가 없는 환경에서는 의존성을 가지고 있다는 이유만으로 그래픽스 관련 테스트가 실패합니다.

xvfb는 메뉴얼에서 `virtual framebuffer X server for X Version` 라고 소개되고 있으며, 서버 사이드
테스트를 위해 주로 사용됩니다.

Ubuntu 기준으로 `sudo apt install xvfb`로 설치하고 `xvfb-run`에 이어서 테스트 명령어를 추가하여
테스트할 수 있습니다. 실제 GitHub Actions에 적용한 [예시](https://github.com/hueypark/marsettler/blob/dadbd044b1c2c6ce29ace6924b7bee5180660e9e/.github/workflows/benchmark.yml#L29)를
공유드립니다.
