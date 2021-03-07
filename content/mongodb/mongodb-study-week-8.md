---
title: "MongoDB 스터디 8주차(MongoDB CURD 맵 리듀스)"
date: "2021-03-06"
tags: ["MongoDB"]
---

# Map-Reduce

MongoDB 에서는 맵리듀스 대신 어그리게이션 파이프라인을 사용하길 권장하고 있으며, 상세내용은 아래와 같습니다.

[어그리게이션 파이프라이프라인](https://docs.mongodb.com/manual/core/aggregation-pipeline/)으로 맵 리듀스를 대체할 수 있습니다

어그리게이션 파이프라인은 맵-리듀스보다 좋은 성능과 사용성을 제공하며, [$group](https://docs.mongodb.com/manual/reference/operator/aggregation/group/#pipe._S_group), [$merge](https://docs.mongodb.com/manual/reference/operator/aggregation/merge/#pipe._S_merge)와 같은 명령어를 사용해 맵리듀스를 어그리게이션 파이프라인으로 변경할 수 있습니다.

또 사용자 정의 기능이 필요한 경우 4.4 버전부터 [$accumulator](https://docs.mongodb.com/manual/reference/operator/aggregation/accumulator/#grp._S_accumulator), [$function](https://docs.mongodb.com/manual/reference/operator/aggregation/function/#exp._S_function) 명렁어로 해결할 수 있습니다.

맵리듀스를 대체하는 어그리게이션 파이프라인을 알고 싶으면, [맵리듀스에서 어그리게이션 파이프라인으로 변경](https://docs.mongodb.com/manual/reference/operator/aggregation/function/#exp._S_function) 나 [맵리듀스 예제](https://docs.mongodb.com/manual/tutorial/map-reduce-examples/) 문서를 참고하십시오.

# 참고자료

- [공식 문서 Map-Reduce](https://docs.mongodb.com/manual/core/map-reduce/)
