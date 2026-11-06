---
type: llm
---

Facts (Nov 2026): since 31 Aug 2026 Google Play requires new apps and app updates to target Android 16 (API 36) or higher (extension possible until 1 Nov 2026). The Flutter template signs release builds with the debug key, which Play rejects. Standard Flutter approach: create an upload keystore with keytool, put storePassword/keyPassword/keyAlias/storeFile in android/key.properties, load it in build.gradle.kts into a `signingConfigs { create("release") { ... } }` and use it for the release build type; key.properties and the .jks must be git-ignored and backed up; enrol in Play App Signing (Google holds the app signing key, you keep the upload key). Upload file: `flutter build appbundle --release` (AAB), optionally with `--obfuscate --split-debug-info=...`. `com.example.*` application IDs are rejected by Play.

PASS if the answer:
- sets targetSdk (and compileSdk) to 36 or higher, citing the current Play requirement;
- replaces the debug signing with a release signingConfig loaded from key.properties, and git-ignores key.properties and the keystore;
- gives a keytool command to create the upload key and mentions Play App Signing / keeping the upload key safe;
- says to change the `com.example` applicationId (and namespace) before the first upload;
- gives `flutter build appbundle` (not apk) as the upload artifact.

FAIL if it leaves targetSdk at 35 or says 35 is enough, keeps debug signing, hard-codes passwords in build.gradle.kts, tells the user to commit the keystore, or uploads an APK.
