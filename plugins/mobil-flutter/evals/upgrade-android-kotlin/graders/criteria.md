---
type: llm
---

Facts: AGP 9 makes built-in Kotlin the default and apps that apply the `kotlin-android` plugin (KGP) fail to build. Flutter 3.44 added temporary support for KGP on AGP 9 with `android.builtInKotlin=false`; Flutter 3.47 supports enabling built-in Kotlin (`android.builtInKotlin=true`) once the app AND all its plugins have migrated. The Flutter tool also adds `android.newDsl=false` to gradle.properties (AGP 9 new DSL compatibility). App migration: remove `id("kotlin-android")` from app/build.gradle.kts and the `kotlinOptions { jvmTarget = ... }` block, and add a top-level `kotlin { compilerOptions { jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17 } }`.

PASS if the answer:
- removes `id("kotlin-android")` from android/app/build.gradle.kts and deletes the `kotlinOptions` block;
- adds a top-level `kotlin { compilerOptions { jvmTarget = ...JvmTarget.JVM_17 } }` block;
- sets gradle.properties correctly: `android.builtInKotlin=true` once plugins are migrated (or `android.builtInKotlin=false` as a temporary step while some plugins still apply KGP), and mentions `android.newDsl=false`;
- tells the user to check whether their Flutter plugins (e.g. shared_preferences) have migrated to built-in Kotlin, and to report/upgrade them if not.

FAIL if it downgrades AGP, only bumps the Kotlin plugin version, keeps kotlinOptions, invents other properties, or claims Flutter does not support AGP 9.
