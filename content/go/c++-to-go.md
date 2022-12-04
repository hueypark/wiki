---
title: "C++ to Go"
date: "2022-12-04"
layout: slide
tags: ["c++", "go"]
draft: true
---

# C++ to Go
## Introducing Ziegel

박재완

---

## Luft
## Ziegel and TrailDB

---

## [Luft](https://engineering.ab180.co/stories/introducing-luft)

- OLAP database for analize the analyzing user behavior in real-time
- Use [TrailDB](https://traildb.io/) as a storage

---

## TrailDB

- TrailDB is an efficient tool for storing and querying series of events
- Written in C

---

## Ziegel

- New storage engine for the Luft
- Written in Go

---

## Why?

- TrailDB has been a suitable solutionfor us for a long time
- But development was hlated in 2019
- Has some issues with peformance and productivity

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
	- Target: 2x fater for the ingestion, 1.2 slower for the query

---

## Peformance tuning

---

### 1. Measuring performance

Go provides great tools for measuring performance.
There is a built-in benchmarking system, and `pprof` is integrated into Go to provide excellent performance measurement and visualization tools.
In particular, the experience of being able to easily check the disassemble results on the web was amazing.

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

### 2. Add benchmarks for the meseurement

We added a benchmark early in the work to see how much performance has improved.
This allows you to see how much a specific commit affected overall performance.
What is still lacking is the gap between benchmark data and production data, and we are working to resolve this.

---

### 3. Impressive optimizations

a. Do not type assert to interfece

Is our use case memory allocation on type assertion is too huge

```
nc convTstring(val string) (x unsafe.Pointer) {
	if val == "" {
		x = unsafe.Pointer(&zeroVal[0])
	} else {
		x = mallocgc(unsafe.Sizeof(val), stringType, true)
		*(*string)(x) = val
	}
	return
}
```

b. Object pooling with `sync.Pool`

`sync.Pool` is a great simple tool for object pooling

c. Load balancing for the job

During ingestion, there were cases where tasks were concentrated on a specific node and the total execution time was increased.
In order to solve this problem, load balancing was performed, and the execution time was significantly reduced compared to the effort invested.

---

## Hard works

1. With `unsafe`, Go is not a safe language

During ingestion, strange values were written to some bytes of the result data for an unknown reason.
The cause, which was identified through long periods of debugging and code reading, was the misuse of the unsafe package.
We used the unsafe package for some functions to improve performance, but erroneous calls to it created hard-to-find bugs.
I am currently using the unsafe package more conservatively.

```go
// ~6x faster than ByteOrder.PutUint32
func PutUint64(data []byte, val uint64) {
	data64 := *(*[]uint64)(unsafe.Pointer(&data))
	data64[0] = val
}
```

2. If you want mange memory directly, it is hard too in Go

Go's garbage collector is great, but if you want high performance you'll need to do the memory management yourself.
However, changing the paradigm from code that already relied on the garbage collector to direct memory management was not an easy task.

```go
type Writer struct {
	c chan []byte
}

func (w *Writer) Write(data []byte) {
	w.c <- data
}
```

3. `syns.Pool` is good. But not good enough for us

It's a great implementation, but we allocate/free memory too often and too much, so we needed a more direct way to manage memory.

---

## Colclusion

In production, ingestion is up to 1.7x faster, and queries maintain roughly the same performance.
Despite the fact that there are still parts that operate inefficiently to maintain a TrailDB-compatible interface,
this level of performance improvement is an encouraging result.

---

## TODOs

1. Remove TrailDB compatibility
2. Support very fast autoscale
3. Real time ingestion
4. More efficient memory management
5. Download partial column only if needed
	- Pre requirment for the very fast autoscale
6. Use level filter

---

# Q & A
