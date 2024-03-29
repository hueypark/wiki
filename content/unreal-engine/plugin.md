---
title: "언리얼 엔진 플러그인"
date: "2021-05-01"
tags: ["Unreal Engine 4", "plugin"]
layout: "slide"
---

## 언리얼 엔진 플러그인

박재완

jaewan.huey.park@gmail.com

---

## 플러그인

에디터 안에서 프로젝트 단위로

켜고 끌 수 있는 코드 및 데이터 모음

---

## 할 수 있는 일

- 런타임 게임플레이 기능 추가
- 엔진 기능 수정
- 새 에셋 유형 생성
- 에디터 메뉴, 툴바 명령 추가

---

엔진 시스템 중 일부도

플러그인으로 확장되어 있음

---

## 하고 싶은 일(오늘 해 볼 일)

데이터 테이블을 확장하여 좀 더 편하게 데이터 추출(json 또는 csv?)

---

## 작업 순서

1. 새 플러그인 생성
2. 데이터 테이블 확장 클래스 추가
3. 팩토리 추가
4. 액션 추가
5. 팩토리에서 ConfigureProperties 가상함수 구현
6. 액션에서 OpenAssetEditor 가상함수 구현
7. 아이템 정보를 csv로 저장
8. 에셋 저장시 csv도 자동저장
9. 레벨 에디터 툴바에 버튼 추가

---

## 1. 새 플러그인 생성

Edit -> Plugins -> New Plugin

![](/unreal-engine/plugin/new-plugin.png)

---

## 2. 데이터 테이블

## 확장 클래스 추가

---

## 3. 팩토리 추가

에디터에서 확장 클래스를 생성할 수 있음

---

### 팩토리 추가 주요작업

1. UFactory 를 상속
2. FactoryCreateNew, ShouldShowInNewMenu 함수 override

---

## 4. 액션 추가

확장 클래스에 대한 동작을 나타내는 액션

지금은 에디터 UI 표현만 작업하지만

함수 override 를 통해 동작에 대한 제어도 가능

---

### 액션 추가 주요작업

1. FAssetTypeActions_Base 상속
2. 에디터 UI 표현을 나타내는 주요 함수 override
	- GetSupportedClass()
	- GetCategories()
	- GetName()
	- GetTypeColor()
3. AssetTools 모듈에 액션 등록

---

## 5. 팩토리에서

## Configure Properties

## 가상함수 구현

---

```cpp
/** Opens a dialog to configure the factory properties.
 * Return false if user opted out of configuring properties */
virtual bool ConfigureProperties()
{
	return true;
}
```

---

BP 추가시 설정 창 생성

![](/unreal-engine/plugin/configure-properties.png)

---

### Slate 구현체(설정 창 UI)

- Declarative Syntax(서술형 문법)
	- 여러 개의 매크로 조합으로 위젯 속성 설정
	- Avoids layer of indirection

- Composition(컴포지션)
	- 몇 줄의 코드만으로 전체 계층을 표현 가능
	- 쉽게 사용할 수 있는 자연스러운 문법
	- 상속은 지양
	- 자식 슬롯은 어떤 위젯도 가질 수 있음
	- 코드에서 UI 재연결이 매우 쉬움

---

### Widget Reflector

손쉽게 UI 구현부(C++ 또는 블루프린트)

를 찾을 수 있음

---

## 6. 액션에서

## Open Asset Editor

## 가상함수 구현

---

```cpp
/** Opens the asset editor for the specified objects.
 * If EditWithinLevelEditor is valid,
 * the world-centric editor will be used. */
virtual void OpenAssetEditor(
	const TArray<UObject*>& InObjects,
	TSharedPtr<IToolkitHost> EditWithinLevelEditor = TSharedPtr<IToolkitHost>() ) = 0;
```

---

## 7. 아이템 정보를 csv로 저장

---

## 8. 에셋 저장시 csv도 자동저장

---

## 9. 레벨 에디터 툴바에 버튼 추가

---

### 레벨 에디터 툴바에 버튼 추가 주요작업

1. 모듈 Startup 시 ToolMenus 에 StartupCallbak 등록
2. 모듈 Shutdown 시 StartupCallbak 해제

---

# 참고자료

- [플러그인 생성 및 사용법 모범 사례(언리얼 엔진 온라인 러닝)](https://learn.unrealengine.com/course/2504895)
- [데이터테이블EX 플러그인 예제](https://github.com/hueypark/ue-plugin-example)
- [텍스트에셋 플러그인 예제](https://github.com/ue4plugins/textasset)
- [데이터 주도형 게임플레이 요소(언리얼 엔진 문서)](https://docs.unrealengine.com/ko/InteractiveExperiences/DataDriven/index.html)
- [클래스 지정자(언리얼 엔진 문서)](https://docs.unrealengine.com/ko/ProgrammingAndScripting/GameplayArchitecture/Classes/Specifiers/index.html)
- [모듈(언리얼 엔진 문서)](https://docs.unrealengine.com/en-US/ProductionPipelines/BuildTools/UnrealBuildTool/ModuleFiles/index.html)

---

## Q & A
