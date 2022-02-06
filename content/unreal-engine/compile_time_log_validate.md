---
title: "컴파일 시점에 printf 오류 검사"
date: "2022-02-06"
tags: ["c++"]
---

언리얼 엔진의 UE_LOG 매크로는 컴파일 시점에 입력값의 오류를 검사하지 않습니다.

따라서 실행 중 로그를 기록하려다 의도하지 않은 동작(크래시 등)을 발생시킬 위험이 있습니다.

예)
```cpp
FString temp;
UE_LOG(LogClass, Log, TEXT("%d, %s"), *temp);
```

_stprintf_s