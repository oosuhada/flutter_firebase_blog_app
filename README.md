# Dev Journal — Flutter + Firebase

A compact mobile developer journal built with Flutter, Riverpod, Firestore, and Firebase Storage. The project keeps the original Firebase CRUD path, but presents it as a small Android-first blog product rather than an empty learning demo.

## Android Emulator preview

| Feed | Post detail | Write post |
| --- | --- | --- |
| ![Dev Journal feed](.github/assets/portfolio/01-feed.png) | ![Post detail](.github/assets/portfolio/02-post-detail.png) | ![Write post](.github/assets/portfolio/03-write-post.png) |

The screenshots are captured from an Android Emulator. When Firestore is empty or unavailable, the app enters an explicit **portfolio preview mode** with local sample content and deterministic local cover artwork, so the UI stays meaningful without relying on network images or private Firebase credentials.

## Product experience

- **Dev Journal identity** — editorial hero, recent posts, topic chips, and a clear writing CTA.
- **Visual post cards** — category, title, excerpt, author, date, and stable local artwork for every portfolio sample.
- **Readable detail view** — large cover, metadata, reading time, article typography, and contextual edit/delete actions.
- **Mobile-first editor** — cover picker, live visual preview, title/body/category/author fields, and publish/update actions inside one keyboard-safe scroll surface.
- **Preview vs live data** — sample data lives in `lib/data/sample/`; the Firestore repository remains the live source of truth whenever documents are available.
- **Firebase-safe Android config** — the Android `applicationId`/`namespace` match an Android client in `google-services.json`, with a regression test guarding the relationship.

## Data modes

### Portfolio preview

`HomeViewModel` starts with `portfolioSamplePosts`. If Firestore is unavailable or has no posts, that explicit preview stays visible. Sample detail and editor flows remain local and do not write mock content into Firebase.

### Live Firebase

When the `posts` Firestore stream returns data, the feed switches to live mode. Create/update operations upload the chosen cover to Firebase Storage and then write the post document to Firestore. Delete operations remove the live Firestore document.

Existing post documents without a `category` field remain readable and fall back to `Development`.

## Project structure

```text
lib/
├── data/
│   ├── model/post.dart
│   ├── repository/post_repository.dart
│   └── sample/sample_posts.dart
├── ui/
│   ├── pages/home/
│   ├── pages/detail/
│   ├── pages/write/
│   └── widgets/post_cover.dart
├── firebase_options.dart
└── main.dart
```

## Run on Android

```bash
flutter pub get
flutter run -d emulator-5554
```

Real Firebase writes require a valid project configuration and permissions. Portfolio preview does not require live Firestore documents or reachable image URLs.

## Validation

```bash
flutter analyze
flutter test
flutter build apk --debug
```

The widget suite covers the preview feed, sample detail rendering, compact-screen editor layout, and the Android package/Firebase client match.
