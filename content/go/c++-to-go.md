---
title: "C++ to Go"
date: "2022-12-04"
layout: slide
tags: ["c++", "go"]
---

# C++ to Go
## Introducing Ziegel

박재완

---

## Luft

- Ziegel and TrailDB

---

## [Luft](https://engineering.ab180.co/stories/introducing-luft)

- OLAP database for analize the analyzing user behavior in real-time
- Use TrailDB as a storage
- Written in C/C++ and Go

---

## [TrailDB](https://traildb.io/)

- TrailDB is an efficient tool for storing and querying series of events
- Written in C

---

## [Ziegel](https://engineering.ab180.co/stories/traildb-to-ziegel)

- New storage engine for the Luft
- Written in Go

---

## Why?

- TrailDB has been a suitable solution for the Luft
- But development was halted in 2019
- Issues with peformance and productivity

---

## Issues

1. Inefficient multi-core utilization
```go
// finalize. this could take a while with idle CPU usage but don't panic.
// it's not freeze;
// it's because TrailDB indexing process is not parallelized yet :(
```
2. Row store data structure
3. Use multiple language: C/C++ and Go

---

## Journey for the migration

1. Add more tests for consistency verification
2. Add interface for engine replacement
	- With this interface, we can easily replace the engine(partial or full)
3. Implement storage engine
4. Peformance tuning
	- 2x fater for the ingestion, 1.2 slower for the query

---

## Peformance tuning

---

### Measuring performance

Go provides great tools for measuring performance.

- pprof
	- Experience of being able to easily check the disassemble results on the web was amazing.
- embedded benchmarking system

---

```
Total:      11.55s 22.23s (flat, cum) 14.49%
. 4.22s            state = pool.Get() 1b8b819: LEAQ query.pool(SB), AX combiner.go:38
. 4.22s  1b8b820:  CALL sync.(*Pool).Get(SB)      group_by_combiner.go:38
.     .  1b8b825:  LEAQ 0x48c734(IP), CX          group_by_combiner.go:38
.     .  1b8b82c:  CMPQ CX, AX                    group_by_combiner.go:38
.     .  1b8b82f:  JNE 0x1b8c353                  group_by_combiner.go:38
             ⋮
.     .  1b8b853:  MOVQ BX, 0xd0(SP)              group_by_combiner.go:38
             ⋮
.     .  1b8c353:  MOVQ CX, BX                    group_by_combiner.go:38
.     .  1b8c356:  LEAQ 0x366183(IP), CX          group_by_combiner.go:38
.     .  1b8c35d:  NOPL 0(AX)                     group_by_combiner.go:38
.     .  1b8c360:  CALL runtime.panicdottypeE(SB) group_by_combiner.go:38
.     .  1b8c365:  NOPL                           group_by_combiner.go:38
```

---

### Add benchmarks for the meseurement

- Add benchmarks early for the measurement
- This allows you to see how much a specific commit affected overall performance

---

![](/go/c++-to-go/benchmark.png)

---

## Impressive optimizations

---

### Do not type assert to interfece

- Memory allocation on type assertion is too huge

```go
fund GetValue(v string) interface{} {
	return v.(interface{})
}
```

---

```go
func convTstring(val string) (x unsafe.Pointer) {
	if val == "" {
		x = unsafe.Pointer(&zeroVal[0])
	} else {
		x = mallocgc(unsafe.Sizeof(val), stringType, true)
		*(*string)(x) = val
	}
	return
}
```

---

### Object pooling with `sync.Pool`

`sync.Pool` is a great simple tool for object pooling

---

### Load balancing

- During ingestion, there were cases where tasks were concentrated on a specific node and the total execution time was increased.
- With load balancing, the execution time was significantly reduced easily.

---

## Hard works

---

### With `unsafe`, Go is not a safe zone too

During ingestion, strange values were written to some bytes of the result data for an unknown reason.

```go
// ~6x faster than ByteOrder.PutUint32
func PutUint64(data []byte, val uint64) {
	data64 := *(*[]uint64)(unsafe.Pointer(&data))
	data64[0] = val
}
```

---

- After long periods of debugging, I found misuse of the unsafe package.

- I'm conservative about the unsafe package now.


---

### If you want mange memory directly,
### It's hard in Go.

- Go's garbage collector is great
- But if you want high performance you'll need to do the memory management yourself.

---

- However, changing the paradigm from garbage collector to direct memory management was not easy.

---

- e.g. How can you handle this case?

```go
type Writer struct {
	c chan []byte
}

func (w *Writer) Write(data []byte) {
	w.c <- data
}
```

---

### `syns.Pool` is good
### But not good enough for us

- It's a great implementation, but we allocate/free memory too often and too much
- So we need more direct way to manage memory.

---

## Colclusion

- Peformance in production
	- Ingestion is up to 1.7x faster
	- Queries maintain roughly the same
- There are still parts that operate inefficiently to maintain a TrailDB-compatible interface
	- After remove this inefficient parts, the performance will be improved more
---

## TODO

1. Remove TrailDB compatibility
2. More efficient memory management
3. Support very fast autoscale
4. Download partial column only if needed
	- Pre requirment for the very fast autoscale
5. User level filter

---

## Takeaways

- Introduce Luft
- Why
- Issues
- Journey
- Peformance tuning
- Hard works
- TODO

---

## Personal opinion that Go over C++

- Productivity is much better
- Do not need verty high level of language skill(easy to hire)
- Finally, Go can do better performance like our product

---

# Q & A
