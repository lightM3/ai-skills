#!/usr/bin/env bash
set -e
J=app/src/main/java/com/acme/bank/ui
mkdir -p $J gradle
cat > settings.gradle.kts <<'G'
pluginManagement { repositories { google(); mavenCentral(); gradlePluginPortal() } }
rootProject.name = "Bank"
include(":app")
G
cat > build.gradle.kts <<'G'
plugins {
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.kotlin.compose) apply false
}
G
cat > gradle/libs.versions.toml <<'G'
[versions]
agp = "9.1.0"
kotlin = "2.3.0"
composeBom = "2025.08.00"
activityCompose = "1.10.1"

[libraries]
androidx-compose-bom = { group = "androidx.compose", name = "compose-bom", version.ref = "composeBom" }
androidx-ui = { group = "androidx.compose.ui", name = "ui" }
androidx-foundation = { group = "androidx.compose.foundation", name = "foundation" }
androidx-material3 = { group = "androidx.compose.material3", name = "material3" }
androidx-activity-compose = { group = "androidx.activity", name = "activity-compose", version.ref = "activityCompose" }

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
    namespace = "com.acme.bank"
    compileSdk = 36
    defaultConfig { applicationId = "com.acme.bank"; minSdk = 26; targetSdk = 36; versionCode = 40; versionName = "2.0.0" }
    buildFeatures { compose = true }
}
dependencies {
    val bom = platform(libs.androidx.compose.bom)
    implementation(bom)
    implementation(libs.androidx.ui)
    implementation(libs.androidx.foundation)
    implementation(libs.androidx.material3)
    implementation(libs.androidx.activity.compose)
}
G
cat > $J/OffersRow.kt <<'K'
package com.acme.bank.ui

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.onFirstVisible
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier

@Composable
fun OfferCard(offer: Offer, analytics: Analytics) {
    // log one impression the first time the card scrolls into view
    Row(Modifier.onFirstVisible { analytics.impression(offer.id) }) {
        Text(offer.title)
    }
}

data class Offer(val id: String, val title: String)
interface Analytics { fun impression(id: String) }
K
cat > $J/PinField.kt <<'K'
package com.acme.bank.ui

import androidx.compose.foundation.text.input.TextFieldState
import androidx.compose.foundation.text.input.TextObfuscationMode
import androidx.compose.material3.OutlinedSecureTextField
import androidx.compose.runtime.Composable

@Composable
fun PinField(state: TextFieldState) {
    OutlinedSecureTextField(
        state = state,
        textObfuscationMode = TextObfuscationMode.Default,
    )
}
K
