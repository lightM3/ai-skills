---
name: flutter-release
description: Releasing a Flutter app to Google Play or the App Store. Use when preparing a release or first store upload, setting up Android signing (keystore, key.properties, Play App Signing) or iOS signing/export, building appbundle or ipa, bumping version/build numbers, configuring CI uploads, or when Play Console / App Store Connect rejects or warns about a build — target API level, 16 KB page size, debug-signed bundle, ITMS-90725 SDK version, ITMS-91053 missing API declaration / privacy manifest, export compliance. Store rules change yearly; this skill holds the current ones. Not for ordinary feature work.
---

# Flutter release (Google Play & App Store)

Store requirements change every year and are mostly newer than the model's training data.
**Use the dated rules in `references/store-rules.md`** (verified 2026-11-06, with sources) instead
of remembered numbers. When the current date is past a rule's "re-check after" date, say the
user should confirm it on the linked page.

## Android → Google Play

### 1. Project settings (`android/app/build.gradle(.kts)`)

- `targetSdk` / `compileSdk`: meet the current Play target-API rule (see store-rules.md —
  **API 36 for new apps and updates since 31 Aug 2026**). Hard-coded old values (e.g. `35`)
  must be raised; `flutter.targetSdkVersion` is fine only if the Flutter version's default meets
  the rule.
- `applicationId` / `namespace`: Play rejects `com.example.*`. Pick the final ID before the
  first upload — it can never change afterwards.
- Version: `version: 1.4.0+22` in pubspec → versionName `1.4.0`, versionCode `22`. Every upload
  needs a **higher build number** (`+23`, or `flutter build appbundle --build-number=23`).

### 2. Release signing (the template signs release with the **debug** key — Play rejects it)

```console
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

`android/key.properties` (never commit it, never commit the `.jks`; back both up):

```properties
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=/Users/me/upload-keystore.jks
```

`android/app/build.gradle.kts`:

```kotlin
import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ...
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

`android/.gitignore`: add `key.properties` and `*.jks` / `*.keystore`.
In CI, write key.properties and the keystore from secrets (base64) at build time.

**Play App Signing** (default for new apps): Google holds the *app signing key*; your keystore
is the *upload key*. If the upload key is lost it can be reset via Play Console support — the
app signing key can't be.

### 3. Build the upload file

```console
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols
```

Upload `build/app/outputs/bundle/release/app-release.aab` (Play requires AAB for new apps, not
APK). Keep `build/symbols` to symbolize crashes (`flutter symbolize`) — losing it means
unreadable Dart stack traces. `--obfuscate` is optional but needs `--split-debug-info`.

### 4. 16 KB memory page size

Rule and deadline in store-rules.md (**updates blocked from 1 Feb 2027** if not compatible, for
apps targeting Android 15+). Dart/Kotlin/Java code is unaffected; **native `.so` files** decide.

- Project builds: **AGP ≥ 8.5.1** and **NDK r28+** align by default (r27 and lower need
  `-Wl,-z,max-page-size=16384`).
- **Prebuilt `.so` from plugins/SDKs** must be rebuilt by their authors → upgrade the plugin,
  open an issue, or replace it. Linker flags in your app don't fix someone else's binary.
- Verify: `zipalign -c -P 16 -v 4 app-release.apk` ("Verification successful"), Android Studio
  **Build → Analyze APK** (Alignment column on `lib/*.so`), `check_elf_alignment.sh app.apk`,
  or `llvm-objdump -p lib.so | grep LOAD` → `align 2**14`. (Build a universal APK from the AAB
  with bundletool, or `flutter build apk --release`, to check.)
- Don't lower `targetSdk` to dodge it — that breaks the target-API rule.

## iOS → App Store

### 1. Toolchain

Uploads must be built with the **Xcode / SDK version in store-rules.md (Xcode 26 + iOS 26 SDK
since 28 Apr 2026)**. Error `ITMS-90725: SDK version issue` = old Xcode. In CI pin it explicitly
and use a runner image that has it, e.g. GitHub Actions `runs-on: macos-15` (or newer) with
`maxim-lobanov/setup-xcode` `xcode-version: '26'` (or `latest-stable`).

### 2. Privacy manifest (`ITMS-91053: Missing API declaration`)

Add `ios/Runner/PrivacyInfo.xcprivacy` **and add it to the Runner target** (Xcode → File → Add
Files, target Runner, so it lands in Copy Bundle Resources — a file only on disk is ignored).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>NSPrivacyTracking</key>
  <false/>
  <key>NSPrivacyTrackingDomains</key>
  <array/>
  <key>NSPrivacyCollectedDataTypes</key>
  <array/>
  <key>NSPrivacyAccessedAPITypes</key>
  <array>
    <dict>
      <key>NSPrivacyAccessedAPIType</key>
      <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
      <key>NSPrivacyAccessedAPITypeReasons</key>
      <array>
        <string>CA92.1</string>
      </array>
    </dict>
  </array>
</dict>
</plist>
```

Pick reasons that match **your own** code (`references/store-rules.md` lists the common
codes, e.g. UserDefaults `CA92.1` = only this app's data). Plugins/pods ship their own
manifests — update them (`flutter pub upgrade`, `pod repo update`) if the email names their
frameworks. Fill `NSPrivacyCollectedDataTypes` to match the App Store privacy labels.

### 3. Other submission checks

- Bundle ID final, signing team set, version/build: pubspec `x.y.z+N` → CFBundleShortVersionString
  / CFBundleVersion; N must increase per upload.
- Export compliance: if the app only uses standard HTTPS/OS crypto, set
  `ITSAppUsesNonExemptEncryption` = `false` in Info.plist to skip the question on each build.
- Build: `flutter build ipa --release --export-options-plist=ios/ExportOptions.plist`
  (`method` = `app-store-connect`), then upload with Xcode Organizer, Transporter, or your CI tool.
- Account-level items in store-rules.md (age-rating questionnaire, EU trader status).

## Rules

- Never commit keystores, key.properties, .p8/.p12 files or passwords; use CI secrets.
- Never ship debug-signed release builds; never "fix" a store rule by lowering targets or
  pinning old toolchains.
- Quote store deadlines from store-rules.md with their source, and flag if they may be stale.
