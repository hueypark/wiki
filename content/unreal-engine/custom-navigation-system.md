---
title: "언리얼 엔진 4 커스텀 네비게이션 시스템"
date: "2022-02-03"
tags: ["Unreal Engine 4", "navigation"]
layout: "slide"
---

## 언리얼 엔진 4
## 커스텀 네비게이션 시스템

박재완

jaewan.huey.park@gmail.com

---

## 목차

- 네비게이션 시스템 개요
- 왜 커스텀이 필요한가?
- 커스텀 네비게이션 데이터 구현 맛보기
- 참고자료
- Q & A

---

## 네비게이션 시스템

인공지능 에이전트가 경로 찾기를 사용하여

레벨을 탐색하는 기능을 제공

---

![](/unreal-engine/custom-navigation-system/level.png)

벽을 피해 목적지로 가고 싶다면?

---

![](/unreal-engine/custom-navigation-system/level-with-navigation.png)

그냥 사용하시면 됩니다

---

## 왜 커스텀이 필요한가?

---

### 이유 1.

특별한 연출

---

언리얼 엔진 4 에 내장 네비게이션은

[recastnavigation](https://github.com/recastnavigation/recastnavigation) 기반

---

일반적인 상황에서 잘 작동하지만

특별한 연출을 보여주기엔 아쉬운 부분들이 있음

---

### 특별한 연출들의 예

- 높은 지형에서 낮은 지형으로 자유로운 낙하 <!-- .element: class="fragment" -->
- 점프 <!-- .element: class="fragment" -->
- NPC 들이 경로 가장자리를 따라가는 문제 <!-- .element: class="fragment" -->
- 벽타기? <!-- .element: class="fragment" -->

---

### 이유 2.

아쉬운 제어 기능(서버와 공용으로 사용할 때)

---

### 아쉬운 제어 기능

- 옥트리 크기, 위치를 의도한 값으로 설정 <!-- .element: class="fragment" -->
- 런타임에 다양한 지형의 변경(하우징 등)  <!-- .element: class="fragment" -->

---

### 왜 커스텀이 필요한가?

1. 특별한 연출
2. 아쉬운 제어 기능

---

## 커스텀 네비게이션 데이터
## 구현 맛보기

---

```cpp
class NAVIGATIONSYSTEM_API ANavigationData :
	public AActor, public INavigationDataInterface
```

- 추상화된 네비게이션 데이터

- 네비게이션 시스템에서 사용하는 인터페이스 제공

---

```cpp
class NAVIGATIONSYSTEM_API ARecastNavMesh : public ANavigationData
```

- ARecastNavMesh 는 ANavigationData 를 상속받음

---

### 주요 자료구조

- NavMesh <!-- .element: class="fragment" -->
	- 네비게이션 데이터 구현체
	- ANavigationData 상속
- NavMeshGenerator <!-- .element: class="fragment" -->
	- 네비게이션 데이터를 생성하는 생성기
	FNavDataGenerator 상속
- NavRenderingComponent <!-- .element: class="fragment" -->
	- 생성결과를 확인하기 위한 렌더링 컴포넌트
- NavSceneProxy, NavSceneProxyData <!-- .element: class="fragment" -->
	- 렌더링용 씬 프록시와 데이터

---

### NavMesh 주요 함수

```cpp
// 생성자
AHueyNavMesh()

// 네비게이션 생성기를 생성합니다.
virtual void ConditionalConstructGenerator() override;

// 렌더링 컴포넌트를 생성합니다.
virtual UPrimitiveComponent* ConstructRenderingComponent() override;

// 경로를 찾습니다.
static FPathFindingResult FindPath(
	const FNavAgentProperties& agentProperties,
	const FPathFindingQuery& query);
```

---

### NavMeshGenerator 주요 함수

```cpp
// 모두 리빌드합니다.
virtual bool RebuildAll() override;

// 틱마다 비동기 빌드를 시도합니다.
virtual void TickAsyncBuild(float DeltaSeconds) override;

// 네비게이션 바운드가 변경되었을 때를 처리합니다.
virtual void OnNavigationBoundsChanged() override;

// 변경된 부분만 리빌드합니다.
virtual void RebuildDirtyAreas(const TArray<FNavigationDirtyArea>& DirtyAreas) override;
```

---

### NavRenderingComponent 주요 함수

``` cpp
// 씬에 표현될 프록시를 만듭니다.
virtual FPrimitiveSceneProxy* CreateSceneProxy() override;

// 컴포넌트의 영역을 계산합니다.
//
// 렌더링에 포함할지 판정할 때 사용됩니다.
virtual FBoxSphereBounds CalcBounds(const FTransform& LocalToWorld) const override;
```

---

### NavSceneProxy 주요 함수

```cpp
// ViewRelevance 를 반환합니다.
//
// ViewRelevance 는 씬에 보일지에 관한 관련성을 표현하는 값입니다.
virtual FPrimitiveViewRelevance GetViewRelevance(const FSceneView* View) const override;
```

---

### 에디터 설정

1. Project Settings
2. Engine - Navigation System
3. Agents 에서 Nav Data Class, Preferred Nav Data

---

### 에디터 설정

![](/unreal-engine/custom-navigation-system/editor-setting.png)

---

## 더 알아가야 할 부분

- 생성된 네비게이션 데이터 저장은 어디서 하지?
```cpp
// 여기일 것 같은 느낌적 느낌
virtual void Serialize( FArchive& Ar ) override;
```
- 변경된 부분만 리빌드
- ~~점프를 이야기하셨던 것 같습니다만...~~

---

## 참고자료

- [언리얼 엔진 4 커스텀 네비게이션 메쉬 생성기](https://github.com/hueypark/navgen)
- [Navigation Mesh Generation(언리얼 엔진 커스텀 네비게이션 메쉬 생성에 관한 문서)](http://javid.nl/Navigation%20Mesh.pdf)
- [Study: Navigation Mesh Generation](http://www.critterai.org/projects/nmgen_study/)
- [recastnavigation](https://github.com/recastnavigation/recastnavigation)

---

## Q & A
