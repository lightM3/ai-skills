---
name: android-target-sdk
description: Raising an Android app's targetSdk/compileSdk to a new API level (Android 17 / API 37 is the newest), reviewing what breaks or behaves differently, or diagnosing bugs that started after a targetSdk bump or on Android 17 devices — SMS OTP no longer read, local network/LAN discovery failing, widget updateAppWidget IllegalArgumentException, orientation locks ignored on tablets, content capture still on, background activity launches from IntentSender blocked, background audio failing, reflection on static final fields. Holds the per-version behavior changes. Not for AGP/Gradle upgrades or ordinary feature work.
---

# Android targetSdk migration

Platform behavior changes are mostly newer than the model's training data. **The newest Android is
Android 17 = API 37** (stable rollout to Pixels started 17 Jun 2026). Use the per-version file in
`references/` (`references/37.md`) instead of remembered lists. Verified 2026-11-07; if the current date is
after 2027-06-30, a newer Android (API 38) has probably shipped — tell the user to check
developer.android.com/about/versions.

## Workflow

1. Find current `compileSdk` / `targetSdk` / `minSdk` (module build files, version catalog, convention plugins).
2. For **each** API level between current target (exclusive) and the new one (inclusive), read
   `references/<api>.md`. Changes marked *all apps* already affect users on that Android version
   regardless of target; changes marked *target* start when you raise targetSdk.
3. Grep the project for the triggers each reference lists (permissions, receivers, APIs, manifest
   attributes, reflection) and report only the changes that apply to this code, each with a fix.
4. Set `compileSdk = 37` and `targetSdk = 37`. compileSdk 37 needs an AGP that supports API 37
   (AGP 9.5 max API 37; older AGP may warn or fail).
5. Testing: run on an Android 17 emulator/device, including a large-screen (≥ 600dp) one.

Only report changes that the project actually triggers; list others at most briefly. Don't invent
behavior changes — if something isn't in the reference, say it's not on Google's list.

## Rules

- Never fix a behavior change by staying on the old targetSdk: Play's target-API rule moves every year
  (see the android-play skill if present).
- Prefer the replacement Google names (SMS Retriever, FLAG_SECURE, ...) over workarounds.
