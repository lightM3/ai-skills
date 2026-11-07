# Dated Android distribution rules

Verified 2026-11-07. Re-check each rule after its date.

## Google Play target API level — re-check after 2027-05-01

Source: https://developer.android.com/google/play/requirements/target-sdk
(and Play Console Help "Target API level requirements for Google Play apps")

Since **31 Aug 2026**, new apps and app updates must target:

| Form factor | Minimum targetSdk |
|---|---|
| Phone / tablet | **36** (Android 16) |
| Wear OS | 35 |
| Android Automotive OS | 35 |
| Android TV | 34 |
| Android XR | 34 |

- Extension available until **1 Nov 2026** (requested in Play Console) — now expired.
- Existing apps must target ≥ 35 to stay visible to new users on newer Android versions; apps below are only
  available on devices at or below their target (phone: Android 14 or lower).
- Exception: permanently private apps for one organization's internal distribution.
- Pattern: each year around August the minimum rises by one API level (expect 37 in 2027 — unconfirmed).

## 16 KB memory page size — re-check after 2027-02-01

Source: https://developer.android.com/guide/practices/page-sizes

- Apps targeting Android 15 (API 35)+ must support 16 KB pages on 64-bit devices.
- **From 1 Feb 2027**, updates that don't support 16 KB can't be released.
- AGP 8.5.1+ with uncompressed libs is recommended (AGP 8.3–8.5.0 align, but bundletool didn't zipalign
  APKs from bundles → may fail to install from Play). NDK r28+ aligns by default; ≤ r27 needs
  `-Wl,-z,max-page-size=16384` / `-Wl,-z,common-page-size=16384`.
- Backcompat: unaligned apps may run in 16 KB compatibility mode (`android:pageSizeCompat` manifest property);
  not a substitute for aligning.
- RELRO check: `llvm-readelf -Wl lib.so | grep 'LOAD\|RELRO\|Type'`.

## Android developer verification — re-check after 2027-01-01

Sources: https://developer.android.com/developer-verification/guides ,
https://9to5google.com/2026/03/30/android-developer-verifier-app/

- Verification opened to all developers 30 Mar 2026 (Play Console + Android Developer Console).
- Jun–Aug 2026: system service rollout, limited distribution, Console API, advanced flow launched globally.
- **30 Sep 2026**: enforcement in Brazil, Indonesia, Singapore, Thailand — apps there must be registered by
  verified developers to install/update on certified devices.
- **2027 onward**: global rollout; verification extends to all third-party stores. Initially verified stores:
  Google Play, HONOR App Market, OPPO App Market, Samsung Galaxy Store, Transsion Palm Store, vivo V-Appstore,
  Xiaomi GetApps.
- Full distribution: identity verification required. Limited distribution: no ID, ≤ 20 devices.
  Unregistered: ADB / advanced flow only.
- Not verified here: fees, exact fingerprint format, API details — point to the Android Developer Console docs.
