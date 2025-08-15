# Build Pipeline Documentation

This document describes the build pipeline for the Passgen app.

## Overview

The Passgen app uses Flutter's build system to create releases for multiple platforms. The build pipeline is designed to be simple and reproducible.

## Prerequisites

- Flutter SDK (3.x stable channel)
- Android SDK (for Android builds)
- Xcode (for iOS builds, macOS only)
- Java JDK 11 or higher (for Android builds)

## Build Process

### 1. Setup

Before building, ensure all dependencies are installed:

```
flutter pub get
```

### 2. Debug Builds

For development and testing:

```
flutter run
```

This builds and runs the app on a connected device or emulator.

### 3. Release Builds

#### Android

To build an Android APK:

```
flutter build apk --release
```

This creates:
- Separate APKs for each ABI in `build/app/outputs/flutter-apk/`
- A universal APK that works on all architectures

To build an Android App Bundle (AAB) for Google Play:

```
flutter build appbundle --release
```

#### iOS

To build an iOS app (macOS only):

```
flutter build ios --release
```

#### Web

To build a web version:

```
flutter build web --release
```

### 4. Testing

Run unit tests:

```
flutter test
```

Run widget tests:

```
flutter test test/widget_test.dart
```

Run all tests:

```
flutter test
```

### 5. Code Analysis

Run static analysis:

```
dart analyze
```

Run linting:

```
flutter analyze
```

## Release Process

### 1. Versioning

Update the version in `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

The first part (1.0.0) is the version name, and the second part (1) is the version code.

### 2. Build Release

Build the release APK:

```
flutter build apk --release
```

### 3. Sign the APK

The APK is automatically signed with the release keystore configured in `android/key.properties`.

### 4. Verify the Build

Verify the APK integrity and size:

```
flutter build apk --release --analyze-size
```

### 5. Distribute

- For Google Play: Upload the AAB file
- For F-Droid: Submit the source code and metadata
- For direct distribution: Distribute the universal APK

## Continuous Integration

The project can be built on CI systems like GitHub Actions, GitLab CI, or Travis CI.

Example GitHub Actions workflow:

```yaml
name: Build and Test

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - uses: actions/setup-java@v1
      with:
        java-version: '11'

    - uses: subosito/flutter-action@v1
      with:
        flutter-version: '3.x'

    - name: Install dependencies
      run: flutter pub get

    - name: Run tests
      run: flutter test

    - name: Build APK
      run: flutter build apk --release

    - name: Upload APK
      uses: actions/upload-artifact@v2
      with:
        name: release-apk
        path: build/app/outputs/flutter-apk/app-release.apk
```

## Troubleshooting

### Common Issues

1. **Signing errors**: Ensure the keystore file exists and the passwords in `key.properties` are correct.

2. **Build failures**: Run `flutter clean` and `flutter pub get` to clear any cached files.

3. **Version conflicts**: Ensure all dependencies are compatible with the Flutter version.

### Useful Commands

- Clean build: `flutter clean`
- Get dependencies: `flutter pub get`
- Upgrade dependencies: `flutter pub upgrade`
- Check Flutter installation: `flutter doctor`