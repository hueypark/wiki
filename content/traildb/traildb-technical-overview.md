---
title: "TrailDB 기술 오버뷰"
date: "2022-05-30"
tags: ["database", "olap", "storage", "traildb"]
draft: true
---

## 데이터 모델

### traildb

- trail 들의 집합

### trail

- 사용자가 정의한 128 비트 UUID 와 자동으로 항당되는 trail ID 로 구분됨
- 시간순으로 정렬된 이벤트 집합으로 구성

### event

- UUID 와 관계된 특정 시간의 이벤트
- 64비트 정수형 타임스탬프를 소유
- 미리 정의된 filed 들을 구성

### field

- TrailDB 는 filed 로 구성된 스키마를 따름
- filed 는 값들로 구성

관계형 데이터베이스에서 UUID 는 기본 키, event 는 row, field 는 column 에 해당합니다.

## 퍼포먼스 베스트 프랙티스

### TrailDB 를 생성하는 것은 읽는 것보다 느림

새로운 TrailDB 를 생성하면 CPU, 메모리, 임시 디스크 공간이 대략 O(N) 만큼 소비됩니다. 여기서 N 은 데이터의 양입니다.
무거운 생성작업을 가공작업과 분리하여 충분한 자원을 투입할 수 있도록 하는 것이 일반적입니다.

### TrailDB 들을 통합하기 위해 `tdb_cons_append` 를 사용

어떤 경우에는 작은 TrailDB 샤드를 구성하고 나중에 `tdb_cons_append()` 함수를 사용하여 통합할 수 있습니다.
이 함수를 사용하는 것은 기존 TrailDB 를 순회하며  `tdb_cons_add()` 를 사용하는 것보다 효율적입니다.

### 아이템에 문자열을 매핑하는 것은 비교적 느린 O(L)

`tdb_get_item()` 을 사용해 문자열을 항목에 매핑하는 것은 O(L) 연산이며, L은 필드의 고유한 값 수입니다.
`tdb_get_item_value()` 를 사용해 항목을 문자열에 매핑하는 것은 빠른 O(1) 연산입니다.

### UUID 를 trail ID 에 매핑하는 것은 비교적 빠른 O(log N)

`tdb_get_trail_id()` 를 사용해 UUID 를 trail ID 비교적 빠른 O(log N) 연산으로, 여기서 N 은 trail 수입니다.
`tdb_get_uuid()` 를 사용해 trail ID 를 UUID 에 매핑하는 역연산은 O(1) 연산입니다.

### 쓰레드 안정성을 의해 여러 `tdb` 핸들러를 사용

`tdb_init()` 가 반환하는 `tdb` 는 쓰레드 세이프하지 않습니다. 각 쓰레드에서 `tdb_init()` 와 `tdb_open()` 을 각각 호출해야 합니다.
다행이 이런 작업은 매우 가볍고 데이터가 공유되므로 메모리 오버헤드는 무시해도 될 정도입니다.

### cursor 는 가벼움

`tdb_cursor_new()` 로 생성된 cursor 는 가볍습니다.
유일한 오버헤드는 작은 lookahead buffer 입니다. 매우 대량의 병렬 cursor 를 유지하려면 `TDB_OPT_CURSOR_EVENT_BUFFER_SIZE` 를 이용해 크기를 제어할 수 있습니다.

### 가용 램 보다 큰 TrailDB

일반적으로 사용가능한 램 용량에 비해 SSD(디스크) 공간이 큽니다.
처리해야 할 TrailDB 의 크기가 램보다 클 경우 성능 저하를 피라기 위해 TrailDB 의 일부만 열어야 하며 애플리케이션 로직이 복잡해질 수 있습니다.

다른 방법은 `tdb_open()` 으로 모든 TrailDB 를 연 다음 데이터를 처리하고 비활성화된 TrailDB 를 `tdb_dontneed()` 로 태그해 운영체제에 페이징 가능한 메모리임을 알려줄 수 있습니다.
만약 TrailDB 가 다시 필요해지면 `tdb_willneed()` 를 사용합니다.

TrailDB 를 명시적으로 열고 닫는 것과 비교해 이 접근 방식의 이점은 모든 커서, 포인터 등이 유지되므로 복잡한 리소스 관리 없이 메모리에 유지할 수 있다는 것입니다.