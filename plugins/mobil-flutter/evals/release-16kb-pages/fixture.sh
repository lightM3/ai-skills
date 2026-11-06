#!/usr/bin/env bash
set -e
mkdir -p android/app lib
cat > pubspec.yaml <<'Y'
name: scanner_app
publish_to: none
version: 2.3.0+41
environment:
  sdk: ">=3.12.0 <4.0.0"
  flutter: ">=3.47.0"
dependencies:
  flutter:
    sdk: flutter
  # bundles prebuilt native .so libraries
  legacy_barcode_scanner: ^1.4.2
Y
cat > android/settings.gradle.kts <<'G'
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.3.2" apply false
}
include(":app")
G
cat > android/app/build.gradle.kts <<'G'
plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}
android {
    namespace = "app.scanner"
    compileSdk = 36
    ndkVersion = "26.3.11579264"
    defaultConfig {
        applicationId = "app.scanner"
        minSdk = 24
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
}
flutter { source = "../.." }
G
echo 'void main() {}' > lib/main.dart
