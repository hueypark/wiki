---
title: "Go module에서 GitHub private 저장소 사용"
date: "2020-03-29"
tags: ["go"]
---

Go module에서 GitHub private 저장소를 사용하는 방법입니다.

---

### git 설정에서 GitHub 접근을 계정과 토큰을 사용하게 변경

```bash
git config --global url."https://${GITHUB_USER}:${{GITHUB_TOKEN}}@github.com".insteadOf "https://github.com"
```

### [GOPRIVATE](https://golang.org/cmd/go/#hdr-Module_configuration_for_non_public_modules) 환경변수에 private 저장소 등록

```bash
GOPRIVATE="github.com/hueypark/asset"
```
