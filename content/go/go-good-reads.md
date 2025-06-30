---
title: "Go good reads"
date: "2022-09-18"
tags: ["go"]
---

# Index

- [Performance](##performance)
- [Concurrency](##concurrency)
- [Generics](##generics)
- [Reiaibility](##reiaibility)
- [Others](##others)

## Performance

### [Finding performance problems by diffing two Go profiles by Zach Musgrave](https://www.dolthub.com/blog/2025-06-20-go-pprof-diffing/)

### [Optimising and Visualising Go Tests Parallelism: Why more cores don't speed up your Go tests](https://threedots.tech/post/go-test-parallelism/)

### [Leveraging benchstat Projections in Go Benchmark Analysis!](https://www.bwplotka.dev/2024/go-microbenchmarks-benchstat/)

### [Benchmarks and performance testing](https://www.willem.dev/articles/benchmarks-performance-testing/)

### [New unique package by Michael Knyszek](https://go.dev/blog/unique)

> This work also led us to reexamine finalizers, resulting in another proposal for an easier-to-use and more efficient replacement for finalizers. With a hash function for comparable values on the way as well, the future of building memory-efficient caches in Go is bright!

It is wonderful to see that the Go team is working on improving the memory management of Go.

### [Inline Heuristics Review](https://docs.google.com/presentation/d/1Lf3WoRyCNicS1K3NCuVl_VnJFhvew_6nAQF_Wx--F54/edit?usp=sharing)

> On Thursday 3/28 we held a design review looking at the new inlining heuristics framework being developed as part of the inlining overhaul effort (this was a separate session from the usual C&R meeting)

From [Go compiler and runtime meeting notes](https://github.com/golang/go/issues/43930#issuecomment-2043535174)

### [Go 1.22 inlining overhaul](https://docs.google.com/document/d/1a6p7-nbk5PVyM1S2tmccFrrIuGzCyzclstBtaciHxVw)

### [pprof documentation](https://github.com/google/pprof/tree/main/doc)

### [A Deep Look Into Golang Profile-Guided Optimization (PGO)](https://theyahya.com/posts/go-pgo/)

### [Profiling and Execution Tracing in Go](https://teivah.medium.com/profiling-and-execution-tracing-in-go-a5e646970f5b)

- What I learned
	- pprof can diff with `go tool pprof -http=:8080 -diff_base <file2> <file1>`

### [How to Write Accurate Benchmarks in Go](https://teivah.medium.com/how-to-write-accurate-benchmarks-in-go-4266d7dd1a95)

- Not resetting or pausing the timer
- Making wrong assumptions about micro-benchmarks
- Not being careful about compiler optimizations
- Being fooled by the observer effect

### [Obscure Go Optimisations - Bryan Boreham](https://youtu.be/rRtihWOcaLI)

- Take-aways
	- Slice-to-interface cast will allocate.
	- Heap allocation is costly.
	- Generic methods are not fast.
	- Heap Ballast is dead.
	- Long live GOMEMLIMIT!

### [Fixing Memory Exhaustion Bugs in My Golang Web App](https://mtlynch.io/notes/picoshare-perf/)

Go 메모리 관련 OOM 버그를 수정하는 여정에 관한 이야기

디버깅 과정을 상세하게 공유해 주고 있으며,
특히 [Other lessons learned](https://mtlynch.io/notes/picoshare-perf/##other-lessons-learned) 와
[Dead ends](https://mtlynch.io/notes/picoshare-perf/##dead-ends) 파트에서 공유해준 내용에는 배울 점이 많습니다.

### [Bounds Check Elimination in Go 101](https://go101.org/article/bounds-check-elimination.html)

### PGO

- [Profile Guided optimisation by Andrew Phillips](https://andrewwphillips.github.io/blog/pgo.html)
- [cmd/compile: PGO opportunities umbrella issue in github.com/golang/go Issuues](https://github.com/golang/go/issues/62463)

## Concurrency

### [Go synctest: Solving Flaky Tests by Phuong Le](https://victoriametrics.com/blog/go-synctest/)

## Generics

### [Deconstructing Type Parameters by The Go Blog](https://go.dev/blog/deconstructing-type-parameters)

## Reiaibility

### [NilAway: Practical Nil Panic Detection for Go by the Uber engineering blog](https://www.uber.com/en-NL/blog/nilaway-practical-nil-panic-detection-for-go/)

## HTTP

### [Which Go router should I use? by Alex Edwards](https://www.alexedwards.net/blog/which-go-router-should-i-use)

### [Organize your Go middleware without dependencies by Alex Edwards](https://www.alexedwards.net/blog/organize-your-go-middleware-without-dependencies)

## Others

### [We Replaced Our React Frontend with Go and WebAssembly by Alex Suraci](https://dagger.io/blog/replaced-react-with-go)

### [Common Go Mistakes](https://100go.co/)

### [Go compiler and runtime meeting notes](https://github.com/golang/go/issues/43930)

### [go HACKING.md](https://github.com/golang/go/blob/master/src/runtime/HACKING.md)

### [Go basically never frees heap memory back to the operating system](https://utcc.utoronto.ca/~cks/space/blog/programming/GoNoMemoryFreeing)

### [Go 1.20 Experiment: Memory Arenas vs Traditional Memory Management](https://pyroscope.io/blog/go-1-20-memory-arenas/)

Despite the tradeoffs, arena is a very cool feature.

### [DRAFT RELEASE NOTES — Introduction to Go 1.20](https://tip.golang.org/doc/go1.20##introduction)

- Interesting for me
	- Profile-guided optimization(PGO)
	- Wrapping multiple errors
- Other links
	- [What’s New in Go 1.20, Part I: Language Changes
](https://blog.carlmjohnson.net/post/2023/golang-120-language-changes/)
	- [What’s New in Go 1.20, Part II: Major Standard Library Changes](https://blog.carlmjohnson.net/post/2023/golang-120-arenas-errors-responsecontroller/)

### [GopherCon 2021: Suzy Mueller - Debugging Treasure Hunt](https://youtu.be/ZPIPPRjwg7Q)

- [Log point](https://youtu.be/ZPIPPRjwg7Q?t=2001) is great.
- We can make a breakpoint with the [function name](https://youtu.be/ZPIPPRjwg7Q?t=2276).

### [GopherCon 2019: Dave Cheney - Two Go Programs, Three Different Profiling Techniques](https://youtu.be/nok0aYiGiYA)

- [Trace tool](https://youtu.be/nok0aYiGiYA?t=1485)

### [Mythfall Devlog: Hacking Go Plugins for hot code reloading by UnitOfTime](https://youtu.be/Hfnpupo6yBE)
