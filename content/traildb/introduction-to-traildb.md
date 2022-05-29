---
title: "TrailDB 소개"
date: "2022-05-29"
tags: ["database", "olap", "storage", "traildb"]
draft: true
---

## TrailDB

연속적인 이벤트들을 저장하고 조회하기 위한 효율적인 도구입니다.

## 왜냐하면?

데이터는 많음:
- 이벤트는 시간에 따라 일어나고,
- 유저별로 그룹화됨

## 무엇을?

### 간단한 데이터 모델

- Primary Key: 예) 유저 ID, 문서 ID 등
- Events: 언제 무엇이 발생했는가
- History: trails of events

### Comparison

- Primary Key + Events -> 관계형 데이터베이스
History 는 업데이트를 통해 소실됩니다.

- Primary Key + History -> 타임 시리즈 데이터베이스
개별 이벤트는 aggregation 은 통해 소실됩니다.

- History + Events -> 로그 파일
조회하기에는 무겁습니다.

### 압축(비법 소스)

TrailDB 는 내부에서 여러 압축기술을 사용해 데이터를 작게 만듭니다.
gzip 과 달리 원하는 부분만 압축을 풀 수 있습니다.

압축은 공간 뿐만 아니라 속도에도 영향을 줍니다.

### 간단함(읽기 전용 파일)

all-events.tdb(1.5GB)

### 간단함(라이브러리)

SQLite 와 같은 라이브러리입니다.(Postgres or Redis 등이 아닌)
C 로 구현되어 최고의 성능을 가짐

- Create
- Read
- ~~Update~~
- ~~Delete~~

### Polyglot -> 생산성

Pythosm R, D, C, Haskell, ...

### Clean API

Create

- 로우 이벤트를 기반으로 새 TrailDB 를 만듭니다.
- 이미 존재하느 TrailDB 를 새 것과 병합합니다.

Read

- UUID 또는 Trail ID 기반으로 트레일을 찾습니다.
- Trail 을 순회합니다.
- 효과적으로 이벤트를 처리합니다.
- 이벤트 중 일부를 필터합니다.

## 어떻게?

TODO: Go 샘플

## 참고자료

- Processing Trillions of Events with TrailDB
	- [슬라이드](https://slides.com/villetuulos/sf-data-mining-july-2016-traildb)
	- [영상](https://youtu.be/qK43uLbnFtg)
- [HOW TO BUILD A SQL-BASED DATA WAREHOUSE FOR A TRILLION ROWS IN PYTHON](http://tuulos.github.io/pydata-2014/#/)