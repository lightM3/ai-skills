#!/usr/bin/env bash
set -e
mkdir -p android/app lib
cat > pubspec.yaml <<'Y'
name: recipe_app
description: Recipes.
publish_to: none
version: 1.0.0+1
environment:
  sdk: ">=3.12.0 <4.0.0"
  flutter: ">=3.47.0"
dependencies:
  flutter:
    sdk: flutter
Y
cat > android/app/build.gradle.kts <<'G'
plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.recipe_app"
    compileSdk = 35
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.example.recipe_app"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
G
cat > android/.gitignore <<'G'
gradle-wrapper.jar
/.gradle
/captures/
/gradlew
/gradlew.bat
/local.properties
GeneratedPluginRegistrant.java
G
echo 'void main() {}' > lib/main.dart
