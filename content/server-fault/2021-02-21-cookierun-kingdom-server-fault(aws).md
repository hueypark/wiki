---
title: "2020년 2월 19일 쿠키런: 킹덤 장기 점검(AWS)"
date: "2021-02-21"
tags: ["server fault"]
---

## 개요

2월 19일(금) 23:22 ~ 2월 20(토) 19:00 까지 쿠키런: 킹덤 긴급 점검이 있었습니다.

## 원인

아마존웹서비스 장애로 인한 긴급 점검이라고 안내하고 있습니다.

## 특이사항

동일한 원인(AWS 도쿄 리전 장애)으로 의심되는 리그 오브 레전드의 경우 2월 20일 00:45 에 정상화되었는데, 왜 19:00 까지
점검이 지속되었는지 궁금합니다. 아마 서버 아키텍처의 유연성 차이 또는 데이터베이스의 HA 구성 차이일 것으로 짐작됩니다.

## 참고자료

- 쿠키런: 킹덤 [안내] 아마존 웹서비스 데이터센터의 장애 발생 안내(정상화): https://cafe.naver.com/crkingdom/343860
- 쿠키런: 킹덤 [안내] 아마존 웹서비스 장애 정상화 및 서버 오픈 안내(2/20, 19:00): https://cafe.naver.com/crkingdom/375034
- 리그 오브 레전드 2021년 2월 19일 게임 이용 장애 현상 안내 (정상화): https://kr.leagueoflegends.com/ko-kr/news/notices/2021nyeon-2wol-19il-geim-iyong-jangae-hyeonsang-annae-jeongsanghwa/
- 44BITS AWS 도쿄 리전 장애 발생, 특정 AZ 일부 구역의 온도 상승이 원인 https://www.44bits.io/ko/post/news--2021-02-20-aws-ap-northeast-1-outage