---
title: "뉴스피드 2021"
date: "2021-01-29"
tags: ["newsfeed"]
---

## 2020년 3월

### 내가 받은 최고의 커리어 조언

> "CEO님께서는 부사장(VP)이나 상무(SVP)가 될 사람을 어떻게 찾습니까?"
"저는 본인의 영역 이상의 일을 이미 하는 직원을 찾아서 그들을 진급시킵니다."
그는 '가능성'이나 '미래' 대신에 '이미'라는 단어를 사용했다.
이후 나는 매니저들은 그들의 가능성이 아니라 결과를 보고 진급시킨다는 사실을 알게 되었다.

링크: https://iamsang.com/blog/2019/01/01/career-advice/

### 벡터(수학) 연산 정리

오랫만에 벡터 연산을 사용하게 되었는데, 오랫만에 접근하니 어색했습니다.

괜찮았던 자료 기록합니다.

Dot Product: https://www.mathsisfun.com/algebra/vectors-dot-product.html
Corss Product: https://www.mathsisfun.com/algebra/vectors-cross-product.html

### 메모리 누수에 대응하는 실용적인 방법

메모리가 부족해지기 전에 폭발한다면, 미사일에 탑재된 프로그램에서 메모리 누수는 중요하지 않습니다.

> Memory leaks on missiles don't matter, so long as the missile explodes before too much leaks. A 1995 memo: 

링크: https://twitter.com/pomeranian99/status/858856994438094848

## 2020년 2월

### MongoDB C++ Driver 윈도우즈 빌드

빌드에 너무 많은 시행착오가 있어 기록으노 남깁니다. C++ 의존성 관리의 불편함을 다시 한 번 느끼는 작업이었습니다.

```bat
cmake -G "Visual Studio 16 2019" -A x64 -DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_FLAGS="/Zc:__cplusplus" "-DENABLE_SSL=WINDOWS" "-DCMAKE_INSTALL_PREFIX=C:\Users\jaewa\go\src\github.com\hueypark\marsettler\Server\Package\mongo-c-driver-1.17.3\stage" "-DCMAKE_PREFIX_PATH=C:\Users\jaewa\go\src\github.com\hueypark\marsettler\Server\Package\mongo-c-driver-1.17.3\stage" ..

cmake --build . --config RelWithDebInfo

cmake --build . --config RelWithDebInfo --target install

cmake .. -G "Visual Studio 16 2019" -A x64 -DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_FLAGS="/Zc:__cplusplus" -DCMAKE_BUILD_TYPE=Release -DENABLE_TESTS=OFF -DCMAKE_PREFIX_PATH=C:\Users\jaewa\go\src\github.com\hueypark\marsettler\Server\Package\mongo-c-driver-1.17.3\stage -DCMAKE_INSTALL_PREFIX=C:\Users\jaewa\go\src\github.com\hueypark\marsettler\Server\Package\mongo-cxx-driver-r3.6.2\stage

cmake --build .
cmake --build . --target install
```

### 부정문 질문에 답변할 때 실수하지 않고 답변하는 방법(영어)

Yes, No 를 답하지 않고 내용만 답변

원어민들도 헷갈려하는 부분임

[미국산지 20년이 지나도 아직도 틀리는 영어표현 3가지 중 일부](https://youtu.be/Ujy94q3J8so?t=255)

### 첫 영업팀을 꾸리기(쌍둥이와 세쌍둥이)

비슷한 시기에 여러명을 채용해야 서로 벤치마크할 수 있음

한 명만 채용하면 성과 및 문제점이 개인 문제인지 조직 문제인지 빨리 발견하기 어려움

마케팅이 아닌 분야에서도 적용할 수 있을 것으로 생각됨

[Ep.39 B2B 스타트업이 글로벌 시장 진출하는 방법 - 세콰이아 캐피탈 강연 중 일부](https://youtu.be/RLnBSwZ-flw?t=1258)

## 2020년 1월

### 시니어 개발자의 질문

이걸 왜 만들어야 되냐? 이게 왜 중요하냐? 라는 질문을 함

링크: https://youtu.be/fhFq2LF4qAg?t=1220

Diary of a Programmer 의 [신년 특집 대담: PM 정진영 님을 모셨습니다](https://youtu.be/fhFq2LF4qAg) 중 일부
