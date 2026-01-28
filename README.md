# FlickRadar

A Flutter app that helps you find where to stream movies and TV shows in your region.

## Features

- **Search Movies & TV Shows** - Search the TMDB database for any movie or TV series
- **Streaming Availability** - See which streaming services (Netflix, Amazon Prime, Disney+, etc.) have the content in your region
- **Auto Location Detection** - Automatically detects your region via GPS
- **Region Selection** - Manually change your region to see availability in other countries
- **Offline Support** - Cached results for offline viewing
- **Movie Details** - View cast, genres, ratings, runtime, and trailers

## Tech Stack

- **Flutter** ^3.9.2
- **GetX** - State management & navigation
- **Appwrite** - Serverless backend for TMDB API proxy
- **Hive** - Local caching
- **TMDB API** - Movie & TV show data

## Getting Started

### Prerequisites

- Flutter SDK ^3.9.2
- Xcode (for iOS)
- Android Studio (for Android)

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd whereto

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Environment Configuration

The app supports dev and prod environments:

```bash
# Development
flutter run -t lib/run/dev.dart

# Production
flutter run -t lib/run/prod.dart
```

## Building for Release

### iOS

```bash
flutter build ios --release
```

### Android

```bash
flutter build apk --release
# or
flutter build appbundle --release
```

## App Icon

To update the app icon:

1. Place your 1024x1024 PNG icon at `assets/icon/app_icon.png`
2. Run: `flutter pub run flutter_launcher_icons`

## Data Attribution

Movie and TV show data provided by [TMDB](https://www.themoviedb.org/).

## License

MIT License
