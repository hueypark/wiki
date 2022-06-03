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

### 32비트 `item` 으로 메모리 절약

TrailDB API 는 64비트 정수로 표현되는 `item` 을 사용합니다.
TrailDB 외부의 애플리케이션에서는 이런 `item` 들을 이용해 문자열보다 단순하고 빠른 자료구조를 사용할 수 있습니다.
또 필요한 경우에는 `tdb_get_item_value()` 을 사용해 다시 문자열로 변환할 수도 있습니다.

만약 애플리케이션이 매우 많은 `item` 을 저장하고 처리하는 경우에는 64비트 대신 32비트 `item` 을 사용하여 메모리 소비를 50% 까지 줄일 수 있습니다.
`tdb_item_is32()` 매크로를 사용하여 `item` 을 `uint32_t` 로 캐스팅하기 안전한지 확인할 수 있습니다.
결과가 성공이면 항목을 `uint32_t` 로 캐스팅하고 64비트 `item` 대신 사용할 수 있습니다.

### `trail` 에서 효율적으로 고유 값 찾기

사용자가 방문한 페이지 집합을 조회할 때처럼, `trail` 에서 고유한 값을 찾는 것이 필요할 때가 있습니다.
트레일에는 불필요한 중복 항목이 포함될 수 있으므로 커서가 대부분의 중복 항목을 제거하도록 `tbd_set_opt()` 로 `TDB_OPT_ONLY_DIFF_ITEMS` 을 설정하여 처리속도를 높일 수 있습니다.

이것은 내부 압축 방식을 기반으로 하기 때문에 완벽히 정확하지 않을 수 있습니다.
여전히 적절한 데이터를 구성해야 할 수 있지만 이 옵션을 사용하면 훨씬 빠르게 데이터를 채울 수 있습니다.

### 이벤트 필터를 사용해 이벤트 하위 집합 반환

이벤트 필터는 `trail` 에서 하위 집합을 쿼리하기 위한 강력한 기능입니다.
이벤트 필터는 필드들에 대한 불리언 쿼리를 지원합니다.
예를 들어 아래를 사용해 특정 웹 브라우징 이벤트를 쿼리할 수 있습니다.

```
action=page_view AND (page=pricing OR page=about)
```

먼저, `tdb_event_filter_add_term` 로 `OR` 절을 `tdb_event_filter_new_clause` 로 `AND` 절을 추가해 쿼리를 구성합니다.

필터가 구성되면 `tdb_cursor_set_event_filter()` 를 사용해 커서에 적용할 수 있습니다.
그 후 커서는 쿼리와 일치하는 이벤트만 반환합니다.
내부적으로 커서는 여전히 모든 이벤트를 평가해야 하지만 필터는 원하지 않는 이벤트를 바로 삭제해 처리속도를 높일 수 있습니다.

`tdb_event_filter` 핸들은 커서를 사용하는 동안 유지되어야 합니다.
여러 커서에서 동일한 필터를 사용할 수 있습니다.

만약 모든 커서에 대해 같은 필터를 사용하고 싶다면, `tdb_set_opt` 의 키를 `TDB_OPT_EVENT_FILTER` 로 적용할 수 있습니다.
이렇게 하면 생성된 모든 커서에 필터가 적용됩니다.
여전히 `tdb_cursor_set_event_filter()` 를 사용하면 커서 수준에서 필터를 적용할 수 있습니다.

결과로 이것은 TrailDB 에 대한 뷰를 정의합니다.
구체화된 뷰에 대한 아래 항목도 참조바랍니다.

### 트레일 화이트리스트, 블랙리스트(트레일 하위 집합에 대한 뷰)

위에서 소개한 이벤트 필터의특별한 경우로 모든 이벤트와 일치하거나 아무 이벤트와도 일치하지 않는 필터가 있습니다.
이러한 필터는 `TrailDB` 가 `trail` 의 하위 집합만 반환하도록하는 데 일반적으로 사용됩니다.

`trail` 하위 집합을 화이트리스트에 추가하려면 다음을 수행합니다.
먼저 `tdb_event_filter_new_match_none()` 을 사용해 모든 `trail` 을 비활성화합니다.
그 다음 `tdb_event_filter_new_match_all()` 으로 선택한 `trail` 을 활성화합니다.

```c
struct tdb_event_filter *empty = tdb_event_filter_new_match_none();
struct tdb_event_filter *all = tdb_event_filter_new_match_all();
tdb_opt_value value = {.ptr = empty};

/* first blacklist all */
tdb_set_opt(db, TDB_OPT_EVENT_FILTER, value);

/* then whitelist selected trails */
value.ptr = all;
for (i = 0; i < num_selected; i++)
    tdb_set_trail_opt(db,
                      trail_ids[i],
                      TDB_OPT_EVENT_FILTER,
                      value);
```

만약 `trail` 의 하위 집합을 블랙리스트에 추가하려면 빈 필터를 사용해 `tdb_set_trail_opt` 를 호출하면 됩니다.

이 방식은 내부적으로 최적화되어 이러한 필터가 활성화된 `trail` 에 대해 이벤트가 평가되지 않는 장점이 있습니다.
아래에 설명하는 것처럼 이러한 필터를 사용하여 소스 `TrailDB` 에서 `trail` 의 하위 집한만 포함하는 새 `TrailDB` 를 추출할 수 있습니다.

### `TrailDB` 추출 생성(구체화된 뷰)

기존 `TrailDB` 에서 새 `TrailDB` 로 이벤트의 하위 집합을 추출할 수 있습니다.
이렇게 하면 새 `TrailDB` 가 원본보다 작아 쿼리가 더 빨라질 수 있습니다.

추출을 위해서 기존 `TrailDB` 를 엽니다.
이벤트의 하위 집합을 정의하는 필터를 만들고 `tdb_set_opt` 의 키로 `TDB_OPT_EVENT_FILTER` 를 사용해 `TrailDB` 핸들로 설정합니다.

이제 `tdb_cons_open()` 을 호출하여 초기화된 `TrailDB` 에 `tdb_cons_append()` 를 사용해 추출된 `TrailDB` 를 생성할 수 있습니다.

`tbd merge` 명령을 사용하면 명령줄에서도 구체화된 뷰를 생성할 수 있습니다.

### 여러 `TrailDB` 결합

`TrailDB` 를 시간(일 등)별로 샤딩하는 것은 일반적입니다.
이 때 K 일 동안 사용자의 전체 `trail` 을 얻고 싶다면 K 개의 `TrailDB` 를 각각 별도로 처리해야 합니다.

`Multi-cursors` 여러 `TrailDB` 에서 `trail` 을 함께 묶는 편리한 방법을 제공합니다.
K 개 `TrailDB` 각각에 대한 커서를 초기화하여 다중 커서 인스턴스에 전달하고, 다중 커서를 사용해 결합된 `trail` 을 원할하게 할 수 있습니다.

다중 커서는 효율적인 O(Kn) 병합 정렬을 즉석에서 수행하기 때문에 기본 커서의 시간이 겹치더라도 작동합니다.
기본 커서에 이벤트 필터를 적용해 이벤트 하위 집합에 대한 `trail` 목록을 생성할 수 있습니다.

## 제약조건

- 최대 `trail` 수: $2^{59} - 1$
- `trail` 당 최대 이벤트 수: $2^{50} - 1$
- `field` 최대 값 수: $2^{40} - 2$
- 쵀대 `field` 수: 16,382
- 값의 최대 크기: $2^{58}$ bytes

## 내부동작

`TrailDB` 는 사용공간을 최소화하기 위해 다양한 압축 방법을 사용합니다.
일반적인 압축방식과 달리 `TrailDB` 는 생성될 때 모든 데이터를 압축하지만, 모든 데이터를 압축 해제하지는 않습니다.
지연 커서를 사용해 실제로 필요한 부분만 즉석에서 압축을 해제합니다. 따라서 `TrailDB` 는 캐시 친화적이고 쿼리가 빠릅니다.

`TrailDB` 의 데이터 모델은 효율적인 압축을 가능하게 합니다.
이벤트는 일반적으로 사용자, 서버 또는 기타 논리적 엔티티에 해당하는 UUID 별로 그룹화되기 때문에 예측 가능한 경향이 있습니다.
각 논리적 엔티티는 고유한 방식으로 행동하는 경향이 있습니다.
우리는 이를 활용하여 변화만 압축([run-length](http://en.wikipedia.org/wiki/Run-length_encoding) 인코딩과 유사하게)할 수 있습니다.

또 `TrailDB` 에서 이벤트는 항상 시간별로 정렬되기 때문에 [delta-encoding](https://en.wikipedia.org/wiki/Delta_encoding) 을 사용하여 타임스탬프를 압축할 수 있습니다.

이러한 기본 변환 후에 우리는 일반적으로 값의 분포가 매우 치우친 것을 확인했습니다.
일부 항목은 다른 항목보다 훨씬 더 자주 사용됩니다.
또 유사한 왜곡에 대해 값 쌍(bigrams) 분포를 분석했습니다.
왜곡된 낮은 엔트로피 값 분포는 [Huffman coding](https://en.wikipedia.org/wiki/Huffman_coding) 을 사용해 효율적으로 인코딩할 수 있습니다.
엔트로피 인코딩에 적합하지 않은 필드는 간단한 `variable-length integers` 를 사용해 인코딩합니다.

최종 결과는 Zip 을 사용해 데이터를 압축하는 것과 비슷합니다.
Zip 과 비요해 `TrailDB` 의 큰 이점은 각 `trail` 이 효율적으로 개별 디코딩될 수 있고, 디코딩 출력이 효율적인 정수 기반 형식으로 유지된다는 것입니다.
기본적으로 `TrailDB` API 는 추가 처리를 위해 문자열 대신 정수 기반 항목을 사용하도록 권장하므로 `TrailDB` 위에 고성능 애플리케이션을 쉽게 구축할 수 있습니다.
