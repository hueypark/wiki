---
title: "Go interesting bugs"
date: "2025-12-26"
tags: ["go", "bug"]
---

## [How we found a bug in Go's arm64 compiler by Thea Heinen](https://blog.cloudflare.com/how-we-found-a-bug-in-gos-arm64-compiler/)

> A release? Infrastructure changes? The position of Mars?

> Our investigation stalled for a while at this point – making guesses, testing guesses, trying to infer if the panic rate went up or down, or if nothing changed.

> A reproducible crash with standard library only? This felt like conclusive evidence that our problem was a runtime bug.

- https://github.com/golang/go/commit/f7cc61e7d7f77521e073137c6045ba73f66ef902
