---
layout: post
title: std::shared_ptr is not thread safe
date: 2018-09-03
tags: ["c++", "multithread"]
---

I found that std::shared_ptr is not thread-safe. I leave some examples.

<!--more-->

### Access resource after destruct

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

### Undefined behavior

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
