#!/usr/bin/env bash
set -e
J=app/src/main/java/com/acme/food
mkdir -p $J
cat > settings.gradle.kts <<'G'
plugins { id("com.android.application") version "9.5.0" apply false }
rootProject.name = "Food"
include(":app")
G
cat > app/build.gradle.kts <<'G'
plugins { id("com.android.application") }
android {
    namespace = "com.acme.food"
    compileSdk = 37
    defaultConfig { applicationId = "com.acme.food"; minSdk = 26; targetSdk = 37; versionCode = 512; versionName = "8.1.0" }
    buildTypes {
        release {
            isMinifyEnabled = false   // R8 broke our reflection-based JSON parsing once, so it's off
        }
    }
}
G
cat > NOTES.md <<'M'
- Release APK: ~38 MB of DEX across 6 classes*.dex files (Play Console release overview).
- Sign-in: Google sign-in or email + password. Users re-enter credentials after switching phones.
- Sold in Germany, France and Türkiye. Company: Acme Food GmbH. Play account owner hasn't touched account settings since 2023.
M
cat > app/src/main/AndroidManifest.xml <<'X'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.READ_CALL_LOG" />
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.ACCESS_LOCAL_NETWORK" />
    <application android:label="Food">
        <activity android:name=".MainActivity" android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
X
cat > $J/NearbyStores.kt <<'K'
package com.acme.food

/** Shows restaurants within ~5 km. Asks for ACCESS_FINE_LOCATION once on first launch. */
class NearbyStores
K
cat > $J/PhoneVerification.kt <<'K'
package com.acme.food

/**
 * Account verification: our server places a missed call from a random number;
 * we read the call log (READ_CALL_LOG) and send the caller number back as the code.
 */
class PhoneVerification
K
cat > $J/TvCast.kt <<'K'
package com.acme.food

/** Optional: mirrors order tracking to a smart TV found via mDNS on the home Wi-Fi. */
class TvCast
K
