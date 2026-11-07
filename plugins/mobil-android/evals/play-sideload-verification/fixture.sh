#!/usr/bin/env bash
set -e
mkdir -p app
cat > app/build.gradle.kts <<'G'
plugins { id("com.android.application") }
android {
    namespace = "id.acme.ride"
    compileSdk = 36
    defaultConfig { applicationId = "id.acme.ride"; minSdk = 24; targetSdk = 36; versionCode = 301; versionName = "3.0.1" }
    flavorDimensions += "store"
    productFlavors {
        create("play") { dimension = "store" }
        create("direct") { dimension = "store" } // APK on https://acmeride.id/download
    }
    signingConfigs { create("release") { storeFile = file(System.getenv("KEYSTORE") ?: "release.jks") } }
    buildTypes { release { signingConfig = signingConfigs.getByName("release") } }
}
G
cat > README.md <<'M'
# AcmeRide
Release: `play` flavor -> Google Play (Play App Signing). `direct` flavor -> signed with our own release key, uploaded to acmeride.id/download.
M
