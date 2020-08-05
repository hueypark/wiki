---
layout: post
title: std::shared_ptr 는 쓰레드 세이프하지 않음
date: 2018-09-03
tags: ["c++", "multithread"]
---

std::shared_ptr 는 쓰레드 세이프하지 않습니다. 관련 예제와 볼만한 링크를 남깁니다.

<!--more-->

### 예제 1. 소멸자 호출 후 자원 접근

```cpp
#include <iostream>
#include <memory>
#include <thread>

struct Foo
{
	int val;

	Foo()
	{
		val = 1;
	}

	~Foo()
	{
		val = -1;
	}
};

int main()
{
	while (true)
	{
		std::shared_ptr< Foo > ptr = std::make_shared< Foo >();
		std::weak_ptr< Foo > wptr = ptr;

		std::thread t1(
			[ &ptr ]()
			{
				ptr.reset();
			} );

		std::thread t2(
			[ wptr ]()
			{
				std::shared_ptr< Foo > ptr = wptr.lock();

				if ( ptr )
				{
					// This should not print -1.
					std::cout << ptr->val << std::endl;
				}
			} );

		t1.detach();
		t2.detach();
	}
}

```

### 예제 2. Undefined behavior

```cpp
#include <thread>

std::shared_ptr<int> g_ptr = nullptr;

int main() {
	std::thread t1([]() {
		int i = 0;
		while (true) {
			g_ptr = std::make_shared<int>(i);

			++i;
		}
	});

	std::thread t2([]() {
		while(true) {
			std::shared_ptr<int> ptr = g_ptr;
		}
	});

	t1.join();
	t2.join();

	return 0;
}
```

### 볼만한 링크

[c++ why std::shared_ptr need atomic_store, atomic_load or why we need atomic shared_ptr](http://www.comrite.com/wp/c-why-need-atomic_store-atomic_load-on-shared_ptr-atomic-shared_ptr/)
