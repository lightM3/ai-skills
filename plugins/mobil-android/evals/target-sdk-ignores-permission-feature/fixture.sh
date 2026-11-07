#!/usr/bin/env bash
set -e
mkdir -p gradle app/src/main/java/com/acme/shop
cat > settings.gradle.kts <<'G'
pluginManagement { repositories { google(); mavenCentral(); gradlePluginPortal() } }
rootProject.name = "Shop"
include(":app")
G
cat > gradle/libs.versions.toml <<'G'
[versions]
agp = "9.5.0"
kotlin = "2.3.0"
composeBom = "2026.09.00"

[libraries]
androidx-compose-bom = { group = "androidx.compose", name = "compose-bom", version.ref = "composeBom" }
androidx-material3 = { group = "androidx.compose.material3", name = "material3" }

[plugins]
android-application = { id = "com.android.application", version.ref = "agp" }
kotlin-compose = { id = "org.jetbrains.kotlin.plugin.compose", version.ref = "kotlin" }
G
cat > app/build.gradle.kts <<'G'
plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.compose)
}
android {
    namespace = "com.acme.shop"
    compileSdk = 37
    defaultConfig { applicationId = "com.acme.shop"; minSdk = 26; targetSdk = 37; versionCode = 7; versionName = "1.2.0" }
    buildFeatures { compose = true }
}
dependencies {
    implementation(platform(libs.androidx.compose.bom))
    implementation(libs.androidx.material3)
}
G
