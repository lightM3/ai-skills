---
type: llm
---

Grade only the build files and instructions in the answer; it doesn't matter that the agent could not write files.

Facts (verified Nov 2026): the latest stable AGP is 9.5.0 (Oct 2026), which needs Gradle 9.6.0+ and JDK 17. AGP 9 turns on built-in Kotlin: `org.jetbrains.kotlin.android` must be removed (root, module and version catalog); `org.jetbrains.kotlin.kapt` is incompatible — migrate Room to KSP (`com.google.devtools.ksp` + `ksp(...)`) or use `com.android.legacy-kapt` (same version as AGP); `android { kotlinOptions {} }` becomes a top-level `kotlin { compilerOptions {} }` (jvmTarget defaults to compileOptions.targetCompatibility). AGP 9's new DSL removes `android.applicationVariants`; use `androidComponents { onVariants { ... } }` (or drop the custom APK name). `targetSdk` now defaults to compileSdk instead of minSdk, so it should be set explicitly.

PASS if the answer:
- bumps AGP to 9.5.x and the Gradle wrapper to 9.6 or newer;
- removes the kotlin-android plugin everywhere and does not keep `kotlinOptions` (uses `kotlin { compilerOptions { ... } }` if anything is set);
- replaces kapt with KSP or `com.android.legacy-kapt`;
- removes or replaces the `applicationVariants.all` block with the `androidComponents` variant API (or explains it must go);
- sets `targetSdk` explicitly or explains the new compileSdk default.

FAIL if it keeps AGP on 8.x or 9.0–9.4 as "latest", keeps `org.jetbrains.kotlin.android` with AGP 9 without an explicit opt-out explained as temporary, or keeps `kotlin-kapt`.
