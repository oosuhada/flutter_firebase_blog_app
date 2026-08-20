# Dev Journal — Flutter + Firebase

An Android-first mobile developer journal built with Flutter, Riverpod, Firestore, and Firebase Storage. It keeps the original Firebase CRUD flow intact while presenting the project as a compact blog product with a meaningful offline-friendly portfolio preview.

## Preview

<p align="center">
  <img src=".github/assets/portfolio/01-feed.png" alt="Dev Journal feed" width="31%" />
  <img src=".github/assets/portfolio/02-post-detail.png" alt="Post detail" width="31%" />
  <img src=".github/assets/portfolio/03-write-post.png" alt="Write and edit post" width="31%" />
</p>

<p align="center"><sub>Feed · Post detail · Write / edit flow</sub></p>

<p align="center">
  <img src=".github/assets/portfolio/04-image-preview.png" alt="Bundled development-photo covers" width="31%" />
</p>

<p align="center"><sub>Bundled local cover photography used by the portfolio sample posts</sub></p>

## What it does

- Presents recent developer notes with category, title, excerpt, author, date, and cover imagery.
- Opens each entry into a readable article view with a large hero image and metadata.
- Supports create/update flows with cover selection, preview, title, body, category, author, and publish actions.
- Uses bundled local development-photo covers for portfolio sample posts, avoiding runtime image-network dependency.
- Falls back to explicit sample content when Firestore is empty or unavailable, while keeping the live Firebase path separate.
- Uses Firebase Storage for live cover uploads and Firestore for live post persistence.

## Architecture

The UI is organized around Riverpod view models and a repository boundary:

```text
Flutter UI
   ↓
Riverpod ViewModels
   ↓
PostRepository
   ├── Cloud Firestore
   └── Firebase Storage

Portfolio fallback
   └── lib/data/sample/sample_posts.dart
```

Sample content is presentation fallback only. When Firestore returns posts, the feed switches to live data; sample edit flows do not write mock content into Firebase.

## Tech Stack

- Flutter / Dart
- Riverpod
- Firebase Core
- Cloud Firestore
- Firebase Storage
- Image Picker
- Android Emulator

## Run

```bash
flutter pub get
flutter run -d emulator-5554
```

The repository contains the generated Firebase client configuration used by the app. Live writes additionally require the configured Firebase project to have the necessary Firestore/Storage services and permissions available. If live data is unavailable, the app remains reviewable through its local portfolio preview mode.

## Validation

Final validation performed during the portfolio pass:

- `flutter analyze` — **0 issues**
- `flutter test` — **4 tests passed**
- `flutter build apk --debug` — **successful**
- Android Emulator — representative feed, detail, editor, and cover-gallery states captured at **1080 × 2400**
- Final screenshot pass — no RenderFlex overflow or broken local cover image errors observed
