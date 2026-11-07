#!/usr/bin/env bash
set -e
mkdir -p app/src/main/cpp app/src/main/jniLibs/arm64-v8a app/src/main/jniLibs/armeabi-v7a gradle/wrapper
cat > settings.gradle.kts <<'G'
plugins { id("com.android.application") version "8.4.0" apply false }
rootProject.name = "DocScan"
include(":app")
G
cat > gradle/wrapper/gradle-wrapper.properties <<'G'
distributionUrl=https\://services.gradle.org/distributions/gradle-8.6-bin.zip
G
cat > app/build.gradle.kts <<'G'
plugins { id("com.android.application") }
android {
    namespace = "com.acme.docscan"
    compileSdk = 35
    ndkVersion = "26.1.10909125"
    defaultConfig {
        applicationId = "com.acme.docscan"
        minSdk = 24
        targetSdk = 35
        versionCode = 214
        versionName = "4.9.0"
        externalNativeBuild { cmake { cppFlags += "-std=c++17" } }
    }
    externalNativeBuild { cmake { path = file("src/main/cpp/CMakeLists.txt") } }
}
G
cat > app/src/main/cpp/CMakeLists.txt <<'G'
cmake_minimum_required(VERSION 3.22.1)
project(docscan)
add_library(edgedetect SHARED edgedetect.cpp)
G
echo '// edge detection' > app/src/main/cpp/edgedetect.cpp
: > app/src/main/jniLibs/arm64-v8a/libvendorocr.so
: > app/src/main/jniLibs/armeabi-v7a/libvendorocr.so
cat > app/src/main/jniLibs/README.md <<'M'
libvendorocr.so — prebuilt binaries from the OcrVendor SDK 2.1 (2023). We don't have the sources.
M
