---
name: android-agp
description: Upgrading or fixing an Android Gradle Plugin (AGP) build — bumping AGP/Gradle to the latest version, migrating to AGP 9 or between 9.x releases (built-in Kotlin, the new DSL, per-module new-DSL opt-out, the 9.3 optimization DSL and keepRules, R8 keep-rule behavior changes), or fixing build/sync errors after an AGP bump such as "Cannot add extension with name 'kotlin'", "The 'org.jetbrains.kotlin.android' plugin is no longer required", kapt incompatibility, removed applicationVariants/variantFilter, or "ApplicationExtensionImpl$AgpDecorated_Decorated cannot be cast to BaseExtension" in build-logic. Holds the current AGP versions. Not for adding ordinary dependencies or app feature work.
---

# Android Gradle Plugin upgrades (AGP 9.x)

The current versions are newer than the model's training data. **Use these numbers, not remembered ones**
(verified 2026-11-07 on developer.android.com/build/releases/gradle-plugin; re-check after 2027-01-31
and tell the user to confirm if the current date is later):

| | Version |
|---|---|
| Latest stable AGP | **9.5.0** (Oct 2026); 9.6 is preview |
| Gradle for 9.5 | **9.6.0** minimum |
| JDK | 17 |
| SDK Build Tools | 36.0.0 |
| Default NDK | 28.2.13676358 (r28c) — pin `ndkVersion` explicitly |
| Max compileSdk | 37 (Android 17) |
| AGP 9.0 (Jan 2026) minimums | Gradle 9.1.0, KGP 2.2.10 (AGP auto-upgrades lower KGP; KSP → 2.2.10-2.0.2) |

Not verified here: the AGP 10 release date. Google said the opt-outs below are removed in AGP 10
("mid-2026" in the 9.0 notes); it had not shipped as of Nov 2026. Don't promise a date.

## Workflow

1. Read `settings.gradle(.kts)`, root and module build files, `gradle/libs.versions.toml`,
   `gradle/wrapper/gradle-wrapper.properties`, `gradle.properties`, and any `build-logic`/`buildSrc`.
2. Bump AGP (catalog `agp = "9.5.0"` or plugin `version "9.5.0"`) and the wrapper
   (`distributionUrl=...gradle-9.6.0-bin.zip`).
3. Apply every applicable step below. Show each changed file in full or as a clear diff.
4. Tell the user to run `./gradlew help` / a sync and check third-party Gradle plugins for AGP 9 support.

## 1. Built-in Kotlin (default since AGP 9.0, `android.builtInKotlin=true`)

AGP compiles Kotlin itself. **Remove `org.jetbrains.kotlin.android` (`kotlin-android`) everywhere**:
module `plugins {}`, root `plugins { ... apply false }`, and the `[plugins]` entry in the version catalog.
Errors that mean it is still applied:
`Cannot add extension with name 'kotlin', as there is an extension already registered with that name`
and `The 'org.jetbrains.kotlin.android' plugin is no longer required for Kotlin support since AGP 9.0.`

`kotlinOptions` → top-level `kotlin { compilerOptions { } }`:

```kotlin
// before (inside android { })
kotlinOptions { jvmTarget = "17" }

// after (top level of the module build file)
kotlin {
    compilerOptions {
        // jvmTarget defaults to android.compileOptions.targetCompatibility — usually omit it
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}
```

**kapt:** `org.jetbrains.kotlin.kapt` (`kotlin-kapt`) is incompatible. Preferred: migrate to KSP
(`com.google.devtools.ksp`, `ksp(libs.room.compiler)`; Room, Hilt, Moshi etc. support KSP).
If a processor has no KSP version: replace it with `com.android.legacy-kapt` (same version as AGP)
and keep the `kapt(...)` dependencies.

Extra Kotlin source dirs: only `android.sourceSets { named("main") { kotlin.directories += "..." } }`
works — `kotlin.sourceSets` and `java.directories` for Kotlin are not supported.

Built-in Kotlin replaces only `kotlin-android`. Compiler plugins such as
`org.jetbrains.kotlin.plugin.compose` / `.serialization` are not mentioned in Google's migration guide;
real AGP 9 projects keep applying them — *not verified here*, so if one fails, say so rather than guess.

Modules with no Kotlin: `android { enableKotlin = false }`.
Gradual migration: `android.builtInKotlin=false` + apply `com.android.built-in-kotlin` per migrated module.
Temporary opt-out (needs both lines, removed in AGP 10):

```properties
android.builtInKotlin=false
android.newDsl=false
```

KMP: don't combine `org.jetbrains.kotlin.multiplatform` with `com.android.application`/`library`
in one module; libraries use `com.android.kotlin.multiplatform.library`, apps move to their own module.

## 2. New DSL (default since AGP 9.0, `android.newDsl=true`)

The `android` extension only implements the new interfaces in `com.android.build.api.dsl`.

- `com.android.build.gradle.BaseExtension` / `AppExtension` / `LibraryExtension` (old package) casts fail with
  `ClassCastException: ...ApplicationExtensionImpl$AgpDecorated_Decorated cannot be cast to ...BaseExtension`.
  Use `com.android.build.api.dsl.ApplicationExtension` / `LibraryExtension`, or `CommonExtension`.
- `CommonExtension` **lost its type parameters**: `CommonExtension<*, *, *, *, *, *>` no longer compiles; write
  `CommonExtension`. Its block methods moved to the concrete extensions, so on `CommonExtension` use
  property style: `defaultConfig.apply { minSdk = 26 }`, `compileOptions.apply { ... }`.
- Old `compileSdkVersion(36)` → `compileSdk = 36`.

Convention plugin pattern:

```kotlin
import com.android.build.api.dsl.ApplicationExtension
import com.android.build.api.dsl.CommonExtension
import com.android.build.api.dsl.LibraryExtension

pluginManager.withPlugin("com.android.application") {
    extensions.configure<ApplicationExtension> { configureAndroid(this) }
}
pluginManager.withPlugin("com.android.library") {
    extensions.configure<LibraryExtension> { configureAndroid(this) }
}

fun configureAndroid(android: CommonExtension) {
    android.compileSdk = 36
    android.defaultConfig.apply { minSdk = 26 }
    android.compileOptions.apply {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    android.lint.apply { abortOnError = false }
}
```

`android.newDsl=false` restores the old DSL/variant API — only a temporary escape hatch, removed in AGP 10
(AGP 9.4 added a per-module opt-out). Fix the code instead.

Removed from `android {}` (use `androidComponents`):

| Removed | Replacement |
|---|---|
| `applicationVariants`, `libraryVariants`, `testVariants`, `unitTestVariants` | `androidComponents.onVariants { }` |
| `variantFilter` | `androidComponents.beforeVariants(selector()...) { it.enable = false }` |
| `sdkDirectory`, `ndkDirectory`, `bootClasspath`, `adbExecutable` | `androidComponents.sdkComponents` |
| `dexOptions`, density splits, `wearApp` embedding | removed, no replacement |

Renaming APK outputs via `BaseVariantOutputImpl.outputFileName` relies on internal API and no longer works;
drop it, or copy/rename the artifact in a task using `variant.artifacts.get(SingleArtifact.APK)`.
App bundles (AAB) are what Play needs anyway.

## 3. Default changes in AGP 9.0 (each can be reverted in gradle.properties)

- **`targetSdk` now defaults to `compileSdk`, not `minSdk`** → always set `targetSdk` explicitly.
- `android.uniquePackageNames=true` (each library module needs a distinct `namespace`).
- `android.useAndroidX=true` by default; `android.enableAppCompileTimeRClass=true` (R fields not constant
  in apps → replace `when`/`switch` on `R.id.*` with `if` chains).
- `android.onlyEnableUnitTestForTheTestedBuildType=true`.
- R8: `proguard-android.txt` is no longer allowed — use `getDefaultProguardFile("proguard-android-optimize.txt")`;
  missing ProGuard files fail the build; `strictFullModeForKeepRules` and optimized resource shrinking on.
- `buildFeatures` defaults: `resValues` and `shaders` now off — enable per module if used
  (`buildFeatures { resValues = true }`); `aidl`/`renderScript` global properties removed.
- Removed variant-API names: `minSdkVersion`/`targetSdkVersion` → `minSdk`/`targetSdk`,
  `ComponentBuilder.enabled` → `enable`, `finalizeDSl` → `finalizeDsl`.

## 4. Upgrading within 9.x (9.0 → 9.5)

Read each step you cross. Sources: developer.android.com/build/releases/agp-9-N-0-release-notes.

| AGP | Released | Min Gradle | What matters when upgrading |
|---|---|---|---|
| 9.1 | Apr 2026 (9.1.1) | 9.3.1 | R8 **repackages classes into the default package by default** (like `-repackageclasses`) → code that reflects on class/package names needs keep rules, or opt out with `-dontrepackage`. `-maximumremovedandroidloglevel` accepts names (`WARN`, `DEBUG`, ...). Max API 37. |
| 9.2 | Apr 2026 | 9.4.1 | R8: `-keepattributes` **wildcards (`*`, `*Annotation*`, `*Invisible*`) no longer keep `RuntimeInvisibleAnnotations` / `RuntimeInvisibleParameterAnnotations` / `RuntimeInvisibleTypeAnnotations`** → name them explicitly if CLASS-retention annotations must survive. Negated member names in rules (`!*ForTesting(...)`). Experimental unified test/coverage reports (`android.experimental.reportAggregationSupport=true`). Compose 1.12 requires ≥ 9.2. |
| 9.3 | Jul 2026 | 9.5.0 | New **`optimization` DSL** per build type (below); keep rules in `src/<variant>/keepRules/*.keep` (also works with the legacy DSL, and as KMP consumer rules); `./gradlew :app:analyzeReleaseR8Config` (R8 Configuration Analyzer). |
| 9.4 | Sep 2026 | 9.6.0 | **Per-module new-DSL opt-out**: `android.newDsl.optOut=:legacy-module` in gradle.properties (AGP 10 makes the new Variant API mandatory). Dynamic-feature flavor-dimension parity warnings; `android.enforceDynamicFeatureVariantMatching=true` makes them errors (default in AGP 10). |
| 9.5 | Oct 2026 | 9.6.0 | Experimental backup/restore test suites (`testOptions.backupTests`, `android.experimental.testSuiteSupport=true` + `android.experimental.enableBackupTest=true`). Fix: `optimization { enable = true }` now sets `isMinifyEnabled` on the variant. No breaking changes listed. |

### Release shrinking on AGP ≥ 9.3

```kotlin
android {
    buildTypes {
        release {
            optimization {
                enable = true // code optimization + resource shrinking + default Android keep rules
            }
        }
    }
}
```

- Replaces `isMinifyEnabled = true` + `isShrinkResources = true` +
  `proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), ...)` (the legacy DSL still works).
- Move custom rules from `proguard-rules.pro` into `app/src/main/keepRules/<name>.keep`. Whether
  `proguardFiles` is still read alongside the new DSL is not stated in the docs — move the rules rather than rely on it.
- Re-check rules against the 9.1 repackaging and 9.2 keepattributes changes above.

Prefer migrating a legacy module to `androidComponents` over any opt-out; if an opt-out is needed,
use the 9.4 per-module `android.newDsl.optOut` instead of the global `android.newDsl=false`.

## Rules

- Don't "fix" AGP 9 errors by downgrading AGP or pinning KGP below 2.2.10.
- Opt-out flags are temporary; say so whenever you use one.
- Keep compileSdk ≤ the AGP's max API level (37 for 9.5).
