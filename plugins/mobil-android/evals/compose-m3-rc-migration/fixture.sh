#!/usr/bin/env bash
set -e
J=app/src/main/java/com/acme/stays/ui
mkdir -p $J gradle
cat > gradle/libs.versions.toml <<'G'
[versions]
agp = "9.5.0"
kotlin = "2.3.0"
composeBom = "2026.09.00"
material3 = "1.5.0-rc01"

[libraries]
androidx-compose-bom = { group = "androidx.compose", name = "compose-bom", version.ref = "composeBom" }
androidx-material3 = { group = "androidx.compose.material3", name = "material3", version.ref = "material3" }

[plugins]
android-application = { id = "com.android.application", version.ref = "agp" }
kotlin-compose = { id = "org.jetbrains.kotlin.plugin.compose", version.ref = "kotlin" }
G
cat > app/build.gradle.kts <<'G'
plugins { alias(libs.plugins.android.application); alias(libs.plugins.kotlin.compose) }
android {
    namespace = "com.acme.stays"
    compileSdk = 37
    defaultConfig { applicationId = "com.acme.stays"; minSdk = 26; targetSdk = 37 }
    buildFeatures { compose = true }
}
dependencies {
    implementation(platform(libs.androidx.compose.bom))
    implementation(libs.androidx.material3) // pinned above the BOM on purpose
}
G
cat > $J/FilterSheet.kt <<'K'
package com.acme.stays.ui

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExperimentalMaterial3ExpressiveApi
import androidx.compose.material3.LocalMotionScheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.RangeSlider
import androidx.compose.material3.Slider
import androidx.compose.material3.Text
import androidx.compose.material3.TonalToggleButton
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue

data class Filters(val price: ClosedFloatingPointRange<Float>, val minRating: Float, val petsOnly: Boolean)

@OptIn(ExperimentalMaterial3Api::class, ExperimentalMaterial3ExpressiveApi::class)
@Composable
fun FilterSheet(initial: Filters, onApply: (Filters) -> Unit, onDismiss: () -> Unit) {
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    var price by remember { mutableStateOf(initial.price) }
    var rating by remember { mutableFloatStateOf(initial.minRating) }
    var pets by remember { mutableStateOf(initial.petsOnly) }
    val spec = LocalMotionScheme.current.defaultSpatialSpec<Float>()
    val alpha by animateFloatAsState(if (pets) 1f else 0.6f, spec)

    ModalBottomSheet(onDismissRequest = { onApply(Filters(price, rating, pets)); onDismiss() }, sheetState = sheetState) {
        Column {
            Text("Price per night")
            RangeSlider(value = price, onValueChange = { price = it }, valueRange = 0f..500f)
            Text("Minimum rating: ${"%.1f".format(rating)}")
            Slider(value = rating, onValueChange = { rating = it }, valueRange = 0f..5f, steps = 9)
            Row {
                TonalToggleButton(checked = pets, onCheckedChange = { pets = it }) { Text("Pets allowed") }
            }
        }
    }
}
K
