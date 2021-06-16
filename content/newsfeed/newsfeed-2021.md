---
title: "뉴스피드 2021"
date: "2021-01-29"
tags: ["newsfeed"]
---

## 2020년 6월

> 끝으로 어느 팀이든 좋은 코드를 마스터한 시니어만으로 구성되지 않는다. 프로그래밍팀은 하나의 마을이다. 거기엔 아름답고 웅장하게 세워진 성도 있고 이제 첫 삽을 떠본 주니어가 만든 초가집도 있다. 시니어의 역할은 주니어의 초가집 엉성한 부분을 지적하는것에서 끝나지 않는다. 진짜 마스터는 계속해서 자기 성을 짓는 사람이다. 주니어가 지켜보며 영감 (inspiration)을 얻을만큼 계속해서 조금 더 아름다운 성을 만드는 사람이다. 주니어의 초라한 집에서 훗날 성이 될수 있는 재능을 발견해 용기를 주는 사람이다.

[좋은 코드: 박상민님의 블로그](https://sangminpark.blog/2021/05/28/%EC%A2%8B%EC%9D%80-%EC%BD%94%EB%93%9C/)

## 2020년 4월

### 인센티브와 문화 설계

> 서팀장. 나는 나쁜 사람은 없다고 생각해. 그런데 착하고 훌륭한 인재들이 모인 상태에서 뭔가 잘못되고 있다면 그건 인센티브와 문화 설계가 잘못된거야. 그걸 바로잡는 것이 내가 할일이지

[Dongho Seo님의 페이스북](https://www.facebook.com/dongho.seo1/posts/4004065036319266?__cft__[0]=AZXgcADJD-l6jTWyMr-mYCPZfncRFeSYHOtmjgY5uuj4CENqdmyjenDQGTPB56qRv3ZYM9wDbbgbyfbx7anFZjuF_KwMjd_F3KtklcTU5b_POGxtnPdKm794EYmHW4xLc-I&__tn__=%2CO%2CP-R)

## 2020년 3월

### 시니어의 일(완벽한 확신이 없는 결정을 내리는 일)

[어엉부엉](https://twitter.com/d_ijk_stra)님

> 시니어가 되고 지난 3년간 가장 많이 익숙해진 건 완벽한 확신이 없는 결정을 내리는 일 같다. 돌이켜보면 주니어 땐 집착과도 같이 불확실성을 기피하고, 어쩔 수 없이 불확실성을 안고 결정을 내려야 하는 일에 굉장히 스트레스를 받았었다. 예를 들면 하루 인터뷰 내용을 갖고 결론내야 하는 채용.

링크: https://twitter.com/subicura/status/1372443142188720128

[subicura](https://twitter.com/subicura)님

> 시니어의 중요한 능력 중 하나는 확신이 없는걸 잘(?) 결정하는 일이라고 생각함
제한된 정보를 가지고 빠르고 적절한 선택하기
내가 가장 오래걸리고 잘 못하는거임.. ㅠㅠ

링크: https://twitter.com/d_ijk_stra/status/1372439532121911297

### 내가 받은 최고의 커리어 조언

> "CEO님께서는 부사장(VP)이나 상무(SVP)가 될 사람을 어떻게 찾습니까?"
"저는 본인의 영역 이상의 일을 이미 하는 직원을 찾아서 그들을 진급시킵니다."
그는 '가능성'이나 '미래' 대신에 '이미'라는 단어를 사용했다.
이후 나는 매니저들은 그들의 가능성이 아니라 결과를 보고 진급시킨다는 사실을 알게 되었다.

링크: https://iamsang.com/blog/2019/01/01/career-advice/

### 벡터(수학) 연산 정리

오랫만에 벡터 연산을 사용하게 되었는데, 오랫만에 접근하니 어색했습니다.

괜찮았던 자료 기록합니다.

- Dot Product: https://www.mathsisfun.com/algebra/vectors-dot-product.html
- Corss Product: https://www.mathsisfun.com/algebra/vectors-cross-product.html

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
