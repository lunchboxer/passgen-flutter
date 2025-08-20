#!/bin/bash

# Wait for build to complete and Flutter to finish its verification
sleep 3

# Get version from pubspec.yaml
VERSION=$(grep -E "^version:" ./pubspec.yaml | sed 's/version: //' | sed 's/+.*//' | tr -d ' ')

echo "Renaming APK files with version: $VERSION"

# Process only Flutter APK directory
FLUTTER_APK_DIR="build/app/outputs/flutter-apk"

if [ -d "$FLUTTER_APK_DIR" ]; then
  cd "$FLUTTER_APK_DIR"

  for file in app-*.apk; do
    if [ -f "$file" ]; then
      # Extract ABI
      if [[ $file == *"arm64-v8a"* ]]; then
        ABI="arm64-v8a"
      elif [[ $file == *"armeabi-v7a"* ]]; then
        ABI="armeabi-v7a"
      elif [[ $file == *"x86_64"* ]]; then
        ABI="x86_64"
      elif [[ $file == *"x86"* ]]; then
        ABI="x86"
      else
        ABI="universal"
      fi

      # Determine if release or debug
      if [[ $file == *"release"* ]]; then
        NEW_NAME="passgen-${ABI}-v${VERSION}.apk"
      else
        NEW_NAME="passgen-${ABI}-v${VERSION}-debug.apk"
      fi

      # Copy first, then rename (so Flutter can still find original)
      cp "$file" "$NEW_NAME"
      echo "✓ Created: $NEW_NAME"
    fi
  done
else
  echo "Flutter APK directory not found: $FLUTTER_APK_DIR"
  exit 1
fi
