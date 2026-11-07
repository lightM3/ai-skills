#!/usr/bin/env bash
set -e
mkdir -p gradle/wrapper app analytics
cat > settings.gradle.kts <<'G'
plugins {
    id("com.android.application") version "9.0.1" apply false
    id("com.android.library") version "9.0.1" apply false
}
rootProject.name = "Media"
include(":app", ":analytics")
G
cat > gradle/wrapper/gradle-wrapper.properties <<'G'
distributionUrl=https\://services.gradle.org/distributions/gradle-9.1.0-bin.zip
G
cat > gradle.properties <<'G'
android.useAndroidX=true
# TODO remove once :analytics no longer uses libraryVariants
android.newDsl=false
G
cat > app/build.gradle.kts <<'G'
plugins { id("com.android.application") }
android {
    namespace = "com.acme.media"
    compileSdk = 36
    defaultConfig { applicationId = "com.acme.media"; minSdk = 26; targetSdk = 36 }
    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}
dependencies { implementation(project(":analytics")) }
G
cat > app/proguard-rules.pro <<'G'
-keepattributes *Annotation*
# Keep our CLASS-retention @Tracked annotations: the analytics bytecode scanner reads them from the release APK.
-keep class com.acme.media.player.** { *; }
G
cat > analytics/build.gradle.kts <<'G'
plugins { id("com.android.library") }
android {
    namespace = "com.acme.media.analytics"
    compileSdk = 36
    libraryVariants.all {
        val v = this
        v.buildConfigField("String", "FLAVOR_TAG", "\"${v.name}\"")
    }
}
G
