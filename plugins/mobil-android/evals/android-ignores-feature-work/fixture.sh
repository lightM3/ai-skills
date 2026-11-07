#!/usr/bin/env bash
set -e
mkdir -p app/src/main/java/com/acme/notes/util app/src/test/java/com/acme/notes
cat > settings.gradle.kts <<'G'
plugins { id("com.android.application") version "9.5.0" apply false }
rootProject.name = "Notes"
include(":app")
G
cat > app/build.gradle.kts <<'G'
plugins { id("com.android.application") }
android {
    namespace = "com.acme.notes"
    compileSdk = 37
    defaultConfig { applicationId = "com.acme.notes"; minSdk = 26; targetSdk = 37 }
}
dependencies { testImplementation("junit:junit:4.13.2") }
G
