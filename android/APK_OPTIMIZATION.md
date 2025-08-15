# APK Size Optimization

This document explains the APK size optimization techniques implemented for the Passgen app.

## Techniques Used

### 1. Code Minification and Obfuscation
- Enabled `isMinifyEnabled` and `isShrinkResources` in release builds
- Uses ProGuard rules to remove unused code and obfuscate the remaining code
- Custom ProGuard rules in `proguard-rules.pro` to preserve necessary classes and methods

### 2. ABI Splitting
- Split APKs by ABI (Application Binary Interface) to reduce download size
- Separate APKs for `armeabi-v7a` and `arm64-v8a` architectures
- Universal APK also available for devices with other architectures

### 3. Resource Optimization
- Enabled `isCrunchPngs` to compress PNG resources
- Removed unused resources with `shrinkResources`

### 4. NDK Configuration
- Limited release builds to only the most common ABIs (`armeabi-v7a`, `arm64-v8a`)
- Debug builds include additional ABIs for development (`x86_64`)

## ProGuard Rules

The `proguard-rules.pro` file contains custom rules to:
- Preserve Flutter framework classes
- Keep native methods
- Remove log statements in release builds
- Optimize the code with 5 optimization passes

## Build Commands

To build the optimized APK:

```
flutter build apk --release
```

This will generate:
- Separate APKs for each ABI in `build/app/outputs/flutter-apk/`
- A universal APK that works on all architectures

To build a specific ABI:

```
flutter build apk --release --target-platform android-arm64
```

## Size Reduction Tips

1. Use vector drawables instead of PNGs when possible
2. Compress images before adding them to the project
3. Remove unused dependencies
4. Use the `--analyze-size` flag to analyze APK size:

```
flutter build apk --release --analyze-size
```