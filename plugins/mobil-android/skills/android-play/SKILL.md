---
name: android-play
description: Shipping a native Android app — Google Play releases and updates, Play Console rejections or warnings (target API level, 16 KB memory page size, native .so alignment), auditing an app against current and upcoming Play policy and quality requirements (location / call log / local network declarations, memory and DEX optimization thresholds, zero-tap sign-in, trader status), and distributing APKs outside Play under Android developer verification / app registration. Holds the dated rules. Not for integrating Play libraries (billing, in-app review, updates) or ordinary feature work.
---

# Android release & distribution rules

These rules are dated and mostly newer than the model's training data. **Use `references/rules.md`**
(verified 2026-11-07, with sources and re-check dates) instead of remembered numbers. If today is past a
rule's re-check date, tell the user to confirm on the linked page.

## Before a Play release/update — check the project

1. **Target API** (`targetSdk` in module build files / catalog / convention plugin): phone/tablet apps
   need **API 36** for new apps *and updates* (since 31 Aug 2026; extensions ended 1 Nov 2026). Raise
   `compileSdk` too. Hand behavior-change review to the android-target-sdk skill if present.
2. **16 KB pages** — matters if the APK/AAB contains any `.so` (own CMake/ndk-build code, `jniLibs/`,
   or dependencies with native code):
   - Deadline: **from 1 Feb 2027 updates without 16 KB support can't be released** (apps targeting 15+).
   - Own code: **AGP ≥ 8.5.1** (uncompressed, 16 KB zip-aligned libs) and **NDK r28+** (16 KB ELF alignment
     by default). NDK ≤ r27: add `-Wl,-z,max-page-size=16384` (and `-Wl,-z,common-page-size=16384`).
     When bumping AGP, bump the Gradle wrapper to a version that AGP needs.
   - **Prebuilt `.so` (vendor SDKs, `jniLibs/`, AAR dependencies)** must be rebuilt by whoever built them:
     update the dependency, ask the vendor for a 16 KB build, or replace it. App linker flags can't fix them.
   - Verify: `zipalign -c -P 16 -v 4 app.apk` ("Verification successful"); Android Studio
     **Build → Analyze APK** → `lib/` Alignment column; `check_elf_alignment.sh app.apk`;
     `llvm-objdump -p libx.so | grep LOAD` → `align 2**14` (2**13 or less = unaligned);
     `bundletool dump config --bundle=app.aab | grep alignment` → `PAGE_ALIGNMENT_16K`.
     Test: 16 KB emulator image or "Boot with 16KB page size" on Pixels; `adb shell getconf PAGE_SIZE` → 16384.
   - `useLegacyPackaging = true` (compressed libs) only if AGP can't be upgraded.
   - Never lower targetSdk to dodge it.
3. **Upload**: AAB (`bundleRelease`), release-signed (upload key; Play App Signing holds the app signing key),
   `versionCode` higher than the last upload.

## Policy & quality audit (dated requirements, details in references/rules.md)

When asked to audit an app or plan upcoming Play work, check the manifest, build files and features
against each item and give **action + deadline**:

| Trigger | Requirement | Deadline |
|---|---|---|
| `ACCESS_FINE_LOCATION` | Minimum scope; API 37+ should use the **location button** for one-time/infrequent use; fine location needs a **Play Console declaration** explaining why coarse/location button isn't enough | **27 Jan 2027** |
| `READ_CALL_LOG` for phone-call / missed-call verification | No longer a permitted use → SMS User Consent API / SMS Retriever / other verification | **27 Jan 2027** (policy since 15 Jul 2026) |
| `ACCESS_LOCAL_NETWORK` (targetSdk 37) | Only for core functionality when device pickers aren't enough; **Play Console declaration** for API 37+ | ≥ 30 days after 29 Oct 2026 |
| Manage/broad contacts access | Only for core functionality; otherwise Android **Contact Picker** / scoped intents; declaration | ≥ 30 days after 29 Oct 2026 |
| Release build without R8 (`isMinifyEnabled = false`), DEX > 10 MB (games > 50 MB) | **≥ 25% each** of optimization, shrinking, obfuscation | **Feb 2027** |
| High memory (Android vitals) | 90th-percentile anon RSS + swap thresholds per RAM tier/app state (apps, 8 GB tier: 2.25 GB foreground, 1.5 GB background); bitmap memory > 200 MB in background | **Feb 2027** |
| App with sign-in (optional or required) | **Zero-tap sign-in restore** on a new device (Restore Credentials API) | **Apr 2027** |
| Every developer account | **Trader status** declaration (EEA/UK law, but required for all accounts) | **1 Feb 2027** (EEA/UK marketplace model from 1 Mar 2027) |
| Sales into/out of Japan | Complete Japan authorization or payouts are held | 1 Dec 2026 |

Missing the quality thresholds can reduce visibility and publishing capabilities; missing the trader
declaration can block updates and remove the app.

R8 fix pattern for "R8 broke our reflection": enable it and add keep rules for the reflected
classes (e.g. `-keep class com.acme.model.** { *; }` or annotate with `@Keep`), or move to a
codegen-based JSON library (kotlinx.serialization, Moshi codegen). On AGP ≥ 9.3 prefer
`optimization { enable = true }` with rules in `src/main/keepRules/*.keep` (android-agp skill).

## Distributing outside Google Play (APK on a website, other stores)

**Android developer verification**: apps installed on certified Android devices must be registered by a
verified developer.
- Enforced since **30 Sep 2026** in **Brazil, Indonesia, Singapore, Thailand**; global rollout from **2027**.
- Play-only apps are registered automatically. Apps (also) distributed outside Play must be registered:
  verify identity (individual, or organization with website verified via Search Console), then register
  each **package name with its signing key(s)** by providing an APK signed with that key.
- Console: on and off Play → **Play Console** (now registers off-Play apps/keys); only off Play →
  **Android Developer Console**.
- A sideloaded flavor signed with a *different key* than Play App Signing needs that key registered too.
- Unregistered apps: only via **ADB** or the **advanced flow** (extra safeguards) — not normal installs/updates.
- Students/hobbyists: **limited distribution** account (no ID, up to 20 devices).

## Rules

- Quote dates from `references/rules.md` with the source link; flag possible staleness.
- Never commit keystores or passwords; never ship debug-signed releases.
