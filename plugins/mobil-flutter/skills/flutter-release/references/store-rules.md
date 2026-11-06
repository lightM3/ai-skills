# Store rules (last verified 2026-11-06)

Update this file when a store announces a new rule. Each entry: rule, date, source,
"re-check after".

## Google Play

### Target API level
Source: https://developer.android.com/google/play/requirements/target-sdk (page updated 2026-10-28)

| Since | Rule |
|---|---|
| **31 Aug 2026** | New apps **and app updates** must target **Android 16 (API 36)+**. Wear OS & Android Automotive: API 35+. Android TV & XR: API 34+. Extension can be requested until **1 Nov 2026**. |
| 31 Aug 2026 | Existing apps must target **API 35+** to stay available to new users on newer Android versions; apps at API 34 or lower are only offered to devices on that OS version or lower. |

Exception: permanently private, organization-internal apps.
Re-check after: **Aug 2027** (rule moves up yearly, usually announced in spring).

### 16 KB memory page size
Source: https://developer.android.com/guide/practices/page-sizes

- Apps targeting **Android 15 (API 35)+** must support 16 KB page sizes on 64-bit devices.
- From **1 Feb 2027**, app **updates** that don't support 16 KB can't be released.
- Compatible by default: **AGP ≥ 8.5.1** (uncompressed, zipaligned libs) + **NDK r28+**.
  NDK r27 and lower: link with `-Wl,-z,max-page-size=16384 -Wl,-z,common-page-size=16384`.
- Only native `.so` code matters; Java/Kotlin/Dart-only apps already comply (still test).

Re-check after: **Feb 2027**.

### Other
- New apps must be published as **Android App Bundles** (AAB) and use **Play App Signing**.
- `com.example` package names are rejected.

## Apple App Store
Source: https://developer.apple.com/news/upcoming-requirements/

| Since | Rule |
|---|---|
| **28 Apr 2026** | Uploads must be built with **Xcode 26+** using the **iOS 26 / iPadOS 26 / tvOS 26 / visionOS 26 / watchOS 26 SDK**. Error: `ITMS-90725 SDK version issue`. |
| 9 Sep 2026 | iOS/iPadOS uploads must target **iOS 13 or later** (Flutter 3.47 already requires iOS 15). |
| 31 Jan 2026 | Answer the **updated age-rating questions** for each app, or update submissions are interrupted. |
| 17 Feb 2025 | Apps without verified **EU trader status** (DSA) are removed from the EU storefront. |
| 1 May 2024 | **Privacy manifest / required-reason APIs**: declare approved reasons for listed APIs used by your code and third-party SDKs. Error: `ITMS-91053 Missing API declaration`. |

Not yet announced as of 2026-11-06: an Xcode 27 / iOS 27 SDK upload requirement (historically
announced for late April of the following year). Separately, apps **built** with Xcode 27 must
adopt UIScene (see the flutter-upgrade skill, references/3.38.md).
Re-check after: **Apr 2027**.

### Required-reason API codes (most common cases)
Source: https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api
(full list under the NSPrivacyAccessedAPIType key documentation)

| Category (`NSPrivacyAccessedAPIType`) | Code | Use when |
|---|---|---|
| `NSPrivacyAccessedAPICategoryUserDefaults` | `CA92.1` | Read/write data only accessible to the app itself |
| | `1C8F.1` | Data shared within an App Group of the same developer |
| `NSPrivacyAccessedAPICategoryFileTimestamp` | `C617.1` | Timestamps of files inside the app container / app group |
| `NSPrivacyAccessedAPICategorySystemBootTime` | `35F9.1` | Measure elapsed time between in-app events |
| `NSPrivacyAccessedAPICategoryDiskSpace` | `E174.1` | Check available space before writing files |

Other categories (active keyboards) and other reasons (displaying timestamps or disk space to
the user, user-picked files, SDK wrappers) exist — look the exact code up on Apple's page
before using one; don't guess a code. A wrong reason can fail review.
