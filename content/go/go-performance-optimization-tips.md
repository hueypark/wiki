---
title: "Go 성능 최적화 팁"
date: "2023-06-04"
layout: slide
tags: ["go"]
---

## Go 성능 최적화 팁

박재완

---

## Airbridge 와 Luft

- [Airbridge](https://www.airbridge.io/)
    - 합리적인 비용의 올인원 모바일 마케팅 솔루션
- [Luft](https://engineering.ab180.co/stories/introducing-luft)
    - Airbridge 에서 유저행동 분석을 위해 사용하는 OLAP 데이터베이스
    - [Ziegel](https://engineering.ab180.co/stories/traildb-to-ziegel) 을 스토리지 엔진으로 사용
    - Go 로 작성

<!--more-->

---

## Luft 사용자의 페르소나

- 장기간 데이터에 대해 복잡한 집계 쿼리를 한다.
- 반응속도에 민감하지 않다.
- 정확한 예를 들면:
    - 지난 6개월간 우리 앱에서 한 달에 10만 원 이상 소비한 30대 여성 사용자의 1주일간의 리텐션

---

## 최적화 가설

- 매우 느린 쿼리는 사용자도 납득할만큼 터무니없음
- 매우 빠른 쿼리는 개선할 필요 없음
    - 게임처럼 매우빠른 응답속도를 요구하지 않음
- 적당히 느린 쿼리를 개선대상으로 설정

---

## 적당히 느린 쿼리?

- 처음에는 그냥 눈에 띄는 긴 쿼리
- 좀 더 정확한 기준을 말하면 P90 에서 P95 사이의 쿼리
    - 3개월 데이터에서 퍼널을 조회하는 9초 쿼리
    - 1개월 데이터에서 리텐션을 조회하는 13초 걸리는 쿼리

---

## 또 있다!

- 잠자는 동료를 깨우는 쿼리
- 매우 느린 쿼리 중 일부는 새벽에 batch 로 실행
- 임계점을 넘어갈 정도로 느리면 사람이 수동으로 복구해야 했음

---

## 이런 쿼리들을 개선하며 얻은!

## 실전 Go 성능 최적화 팁!

---

"net/http/pprof" 패키지를 사용하면 

프로파일 정보를 얻을 수 있음

```go
import _ "net/http/pprof"

main() {
    http.ListenAndServe("localhost:6060", nil)
}
```

---

여러 기능이 있는데 오늘 다룰 내용은

- profile
- heap
- trace

---

`go tool pprof` 명령어로 데이터 분석

```zsh
go tool pprof http://localhost:6060/debug/pprof/profile
```

`http` flag 를 추가하면 분석용 UI 실행

```zsh
go tool pprof -http=localhost:8080 http://localhost:6060/debug/pprof/profile
```

`go tool trace` 로 trace 분석

```zsh
curl -o trace.log http://localhost:7400/debug/pprof/trace?seconds=10
go tool trace trace.log
```

---

## 이제 개별 팁으로 들어갑니다!

---

## Exists filter 가 느림(CPU profile)

![](/go/go-performance-optimization-tips/exists-filter-flame-graph.png)

---

데이터 존재를 확인하기 위해 호출되는

[string to interface 변환](https://github.com/golang/go/blob/e827d41c0a2ea392c117a790cdfed0022e419424/src/runtime/iface.go#L388) 이 느리기 때문

![](/go/go-performance-optimization-tips/runtime-convtstring.png)

---

- 쿼리 계획 시점에 filter 최적화
- 가능한 경우 Exists -> NotEqualTo fliter 로 최적화
    - value != "" 비교로 동작
    - NotEqualTo filter 타입 최적화가 이미 되어 있기 때문에 string to interface 변환 이 없음

---

- Exists 구현을 GetValue 없이 방법도 고려했지만
    - 역사적인 이유로 시도하지 않음
    - 다른 모듈에 큰 복잡도 증가를 가져올 것 같았음
- 왜 Exists 에서 value 를 가져와야 하나?
    - Luft 는 스키마가 약하고, Null 개념이 없기 때문에 Exists 개념이 일반적인 경우와 약간 다름
    - 값이 있지만 빈 문자열이 아님을 의미

---

Exists filter 개선 결과

- 약 22% 쿼리 속도 개선(13.5s -> 10.5s)

---

## 메모리 풀

일부 함수가 납득하기 어려운 지분을 차지함

- sync.(*Pool).Get
- runtime.makeslice
- runtime.gcBgMarkWorker

![](/go/go-performance-optimization-tips/pprof-old-memory-pool-cpu.png)

---

메모리가 pool 에 반납되지 않는 경우가 있는 것으로 추정

---

memory profile 도 해당 부분의 할당이 큰 지분을 차지

![](/go/go-performance-optimization-tips/pprof-old-memory-pool-mem.png)

---

### Cursor 의 Next 함수

여러 파이프라인을 거치며 데이터가 사용될 때

효율적으로 동작하게 개선

---

기존:
```go
for cur.Next() {
    buffer := cur.Current()

    var data []byte
    copy(data, buffer)

    doSomething(buffer)
}
```

변경 후:
```go
for cur.Next() {
    current := cur.Current()

    doSomething(current)
}
```

---

- 보통의 경우 Cursor 가 내부 buffer 를 가지는 것이 유리
- Luft 는 다음 파이프라인으로 데이터를 전달 하는 경우가 대부분이기 때문에 내부 buffer 를 사용하지 않게 수정

---

개선 후 profile

![](/go/go-performance-optimization-tips/pprof-new-memory-pool-cpu.png)

---

메모리 풀 개선 결과

- 약 51% 쿼리 속도 개선(8.5s -> 4.2s)

---

## gRPC stream 수 줄이기

---

프로파일 결과에서 특이점을 발견하지 못했음

- 오래 걸리는 함수 없음
- 과도하게 할당하는 메모리 없음

---

[gotraceui](https://github.com/dominikh/gotraceui) 에게 감사하는 시간

- 오픈소스 go trace frontend
- go tool trace 에 비해 압도적으로 빠름

---

쿼리시간 14.7초 중 3~6초만 processor 유의미하게 사용

![](/go/go-performance-optimization-tips/trace-old.png)

---

trace 의 synchronization blocking profile

- gRPC stream 이 과도한 blocking 을 발생시키고 있음

![](/go/go-performance-optimization-tips/trace-old-sync-block-prof.png)

---

gRPC stream 을 너무 많이 만들지 않게 개선

---

gRPC stream 수 줄이기 결과

- 약 56% 쿼리 속도 개선(14.7s -> 6.4s)

---

## Global lock 제거

---

## gRPC stream 수 줄이기 의 역습!

1. Stream 을 적게 만듬
2. 여러 쿼리가 동시에 실행될 가능성이 높아짐
3. 잠재된 위험이었던 메타데이터 접근 시 global lock 의 경합이 심화됨

---

Production 에서 얻어맞은 후

global lock 을 제거하는 방식으로 수정함

---

- 단일 쿼리에서 재현되지 않아 release 전에 검증하지 못함
- 이 문제를 해결하기 위해 대량 쿼리 프로파일 도입 중

---

Global lock 제거 결과

- Pxx: 13.2s -> 19.9s -> 7.6s 으로 개선

---

## 샘플링 개선

샘플링: 실제 대규모 쿼리를 하지 않고 결과값을 추정

---

프로파일이 아니라

시스템에 대한 이해가 있었기에 가능했던 작업

---

- 샘플링을 위해 실제 데이터를 읽어서 검증했음

---

- 데이터가 정렬되어 저장되게 수정하고
- 미리 샘플링할 데이터 범위를 정해 데이터를 읽는 시도조차 하지 않게 수정

---

샘플링 개선 결과

- 약 22% 쿼리 속도 개선(13.5s -> 10.5s) 성능개선

---

## 정리

- Exists filter 개선: 22%(13.5s -> 10.5s)
- 메모리 풀 개선: 51%(8.5s -> 4.2s)
- gRPC stream 수 줄이기: 56%(14.7s -> 6.4s)
- Global lock 제거: Pxx: 13.2s -> 19.9s -> 7.6s
- 샘플링 개선: 22%(13.5s -> 10.5s)

---

## 교훈

- profile 과 trace 를 사용하면 Go 최적화를 효율적으로 할 수 있다.
- 대상 시스템에 대한 이해는 최적화에 큰 도움을 준다.
