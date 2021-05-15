---
title: "언리얼 엔진 플러그인"
date: "2021-05-01"
tags: ["Unreal Engine", "plugin"]
draft: true
---

# 플러그인이란?

UE4 에서 플러그인이란 에디터 안에서 프로젝트 단위로 개발자가 쉽게 켜고 끌 수 있는 코드 및 데이터 모음입니다.
플러그인은 런타임 게임플레이 기능을 추가하고, 내장된 엔진 기능을 수정(또는 새 기능을 추가)하거나,
새 파일 유형을 만들고, 에디터 기존 기능에 새 메뉴, 툴바 명령, 하위 모드를 확장할 수도 있습니다.
여러 기존 UE4 서브시스템은 플러그인을 사용해서 확장 가능하도록 설계되었습니다.

# 새 플러그인 생성

Edit -> Plugins -> New Plugin

# 모듈 & 엔진 구조

Resources: 이미지 등의 리소스
Source: 소스

# 할 수 있는 일

- 새로운 에셋 만들기
- 새로운 에셋을 위한 에디터 만들기
- 드래그 앤 드롭으로 새로운 에셋 생성

# 새로운 에셋 만들기

- C++ 클래스로 에셋 선언
- 에섹 팩토리 구현
- 에디터에서 에셋 모습 커스터마이징
- 에셋 특화된 컨텐츠 브라우저 액션(오른쪽 클릭해서 하는)
- 어드밴스트: 커스텀 에셋 에디터 UI

# Asset Factories

Factory Types

- Content Browser Context Menu
	- Right-click menu in the editor
	- Name: {TypeName}FactoryNew

- Content Browser Drag & Drop
	- Files in disk dragged into the Editor
	- Name: {TypeName}Factory

- Automatic Reimport
	- Recreate assets when files on disk changed
	- Name: Reimport{TypeName}Factory*


UFactory

- Base class for all asset factories
- Core logic for Editor integration
- Virtual functions to be overriden
- Very old API

# UTextAssetFactoryNew

FactoryCreateNew

ShouldShowInNewMenu

# UTextAssetFactory

드래그 앤 드랍용 팫토리

FactoryCreateFile

# Asset 커스터마이징

FAssetTypeActions_Base 을 상속한 다음 아래 함수를 오버라이드 해서 구현 가능

uint32 FTextAssetActions::GetCategories()
virtual FText GetName() const override;
virtual UClass* GetSupportedClass() const override;
virtual FColor GetTypeColor() const override;

썸네일을 바꾸고 싶으면 UThumbnailRenderer 를 더 파보시오

# 에셋 액션 등록

모듈에서 구현

IModuleInterface 을 상속한 후 아래 함수를 구현해주면 됨

	virtual void StartupModule() override { }
	virtual void ShutdownModule() override { }

# 에셋 커스텀 UI

아래 함수를 오버라이드해서 구현할 수 있음

virtual void OpenAssetEditor(const TArray<UObject*>& InObjects, TSharedPtr<IToolkitHost> EditWithinLevelEditor = TSharedPtr<IToolkitHost>()) override;

이 함수를 통해 내부 UI 배치됨
void FTextAssetEditorToolkit::Initialize(UTextAsset* InTextAsset, const EToolkitMode::Type InMode, const TSharedPtr<class IToolkitHost>& InToolkitHost)

요것도 봐야함

class STextAssetEditor
	: public SCompoundWidget
{

# FTextAssetEditorStyle

FSlateEditorStyle 을 파보시길...

# Slate UI 라이브러리

C++ 로 작성
플랫폼 독립
SlateCore: 핵심 기능
Slate: 위젯을 포함하는 모듈
엔진이나 에디터 모듈 의존성이 없음

사용사례
- 언리얼 에디터
- 인게임 UI

# Slate

인풋 핸들링
	- 키보드, 마우스, 조이스틱, 터치
	- 키 바인딩 지원

스타일
	- UI의 비주얼 커스터마이즈
	- 이미지, 폰트, 패딩 등
	- 유저가 제어하는 커스텀 레이아웃

레더링 독립
	- 엔진과, 스탠드얼론 앱 모두 지원

- 다양한 위젯 라이브러리
	- 버튼, 이미지, 메뉴, 다이얼로그, 메시지 박스 리스트 뷰, 슬라이더 등...

# 위젯 리플렉터를 사용해 샘플을 볼 수 있음

# 참고자료

- 플러그인 생성 및 사용법 모범 사례(언리얼 엔진 온라인 러닝): https://learn.unrealengine.com/course/2504895
