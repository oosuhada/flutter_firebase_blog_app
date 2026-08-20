# Flutter Firebase Blog App

Flutter와 Firebase를 연결해 글 목록·작성 흐름, 이미지 업로드, Riverpod 상태 관리, Firestore/Storage repository 사용을 연습한 초기 블로그 프로젝트입니다.

An early Flutter + Firebase blog project for practicing post lists, writing flows, image upload, Riverpod state, Firestore, and Firebase Storage.

## UI Preview / 구현 화면

![Flutter Firebase blog interface](.github/assets/ui-preview.png)

현재 저장소의 Firebase 설정을 포함한 Flutter Web release build를 실제 렌더링해 캡처했습니다. 데이터가 없는 초기 상태에서도 `BLOG` 화면과 최근 글 영역, 글쓰기 action을 확인할 수 있습니다.

The screenshot is rendered from the current Flutter Web release build. Even with an empty data state, it shows the main blog surface and write-post affordance.

## Features / 주요 구현

- Firebase initialization and generated platform options
- Firestore 기반 post repository
- Firebase Storage를 사용한 이미지 업로드 경로
- Riverpod을 사용한 상태 관리
- 최근 글 목록 화면
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
flutter build web --release
```

2026-08-20 기준 의존성 설치와 Flutter Web release build를 다시 통과했습니다. 이 프로젝트는 Firebase CRUD와 Flutter 상태 관리의 기초를 익힌 학습 기록으로 유지합니다.

As of 2026-08-20, dependency resolution and the Flutter Web release build pass again. This repository is preserved as an early learning artifact for Firebase CRUD and Flutter state management.
