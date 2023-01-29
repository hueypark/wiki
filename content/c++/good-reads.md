---
layout: post
title: "C++ good reads"
date: "2022-09-18"
tags: ["c++"]
---

# [C++ STL performance example with shared_ptr](https://blog.lunapiece.net/posts/C++_STL_Performance/)

> I just have to say this and move on... If you think it's okay to just use the STL for a project that doesn't need this level of optimization or performance, think again.

> It is highly likely that your project is not suitable for writing Non GC Native language, so it is recommended to replace it with a VM-based language. I don't use C++ anymore for 99% of my projects. Most of them are solved with C#, Kotlin, and TypeScript.

I strongly agree.

# [Can C++ be 10x simpler & safer ... ?](https://herbsutter.com/2022/09/19/my-cppcon-2022-talk-is-online-can-c-be-10x-simpler-safer/)

C++ 코드를 생성하는 컴파일러를 개발해 C++ 의 좋은 점만 사용하는 50배 안전하고, 10배 간단한 C++ 을 만드는 아이디어

- 레퍼런스
	- [https://github.com/hsutter/cppfront](https://github.com/hsutter/cppfront)