# Flutter Firebase Blog App

Flutter와 Firebase를 연결해 글 목록·작성 흐름, 이미지 업로드, Riverpod 상태 관리, Firestore/Storage repository 사용을 연습한 초기 블로그 프로젝트입니다.

An early Flutter + Firebase blog project for practicing post lists, writing flows, image upload, Riverpod state, Firestore, and Firebase Storage.

## UI Preview / 구현 화면

![Flutter Firebase blog interface](.github/assets/ui-preview.png)

현재 이미지는 Android Emulator에서 기본 앱을 실행해 최근 글 카드와 글쓰기 action이 함께 보이는 상태를 캡처한 것입니다. Firestore에 데이터가 없거나 연결할 수 없는 경우에는 **명시적인 portfolio sample posts**를 표시해 UI가 빈 화면이 되지 않도록 했습니다.

The screenshot is captured from the default app on an Android Emulator. When Firestore is empty or unavailable, the app explicitly shows portfolio sample posts instead of presenting a blank list.

## Features / 주요 구현

- Firebase initialization and generated platform options
- Firestore 기반 post repository
- Firebase Storage를 사용한 이미지 업로드 경로
- Riverpod을 사용한 상태 관리
- 최근 글 목록 화면
- Firebase empty/error 상태에서 명시적으로 표시되는 portfolio sample fallback
- 새 글 작성 및 기존 글 편집을 고려한 write page
- Flutter theme/app-bar styling 연습

## Structure / 구조

```text
lib/
├── data/
│   ├── model/post.dart
│   └── repository/post_repository.dart
├── ui/pages/
│   ├── home/                 # recent posts
│   └── write/                # create/edit post flow
├── firebase_options.dart
└── main.dart
```

## Run / 실행

```bash
flutter pub get
flutter run
```

Firebase-backed operations require a valid Firebase project/configuration. Do not commit private service credentials.

## Validate / 검증

```bash
flutter analyze
flutter test
flutter run
```

2026-08-20 기준 dependency resolution, static analysis, widget test, Android Emulator build/run을 다시 검증했습니다. 이 프로젝트는 Firebase CRUD와 Flutter 상태 관리의 기초를 익힌 학습 기록으로 유지합니다.

As of 2026-08-20, dependency resolution, static analysis, widget tests, and Android Emulator build/run were re-validated. This repository is preserved as an early learning artifact for Firebase CRUD and Flutter state management.
