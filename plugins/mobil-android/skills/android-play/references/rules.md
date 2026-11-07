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

## Play policy announcement of 29 Oct 2026 — re-check after 2027-02-01

Source: https://support.google.com/googleplay/android-developer/answer/18100766
(at least 30 days to comply unless a date is given)

- **Local Network Permission** (new): only for core functionality when device pickers are insufficient;
  apps targeting API 37+ must submit a Play Console declaration.
- **Manage Contacts Permission** (new): core functionality only, declaration; others use platform pickers/intents.
- **AppFunctions API** (new): existing policies apply; don't deceive AI agents or bypass security.
- Subscriptions with eligibility-based discounts (student plans): disclose criteria and post-eligibility pricing.
- **Location** (clarification): minimum scope; API 37+ use the location button for one-time/infrequent needs;
  `ACCESS_FINE_LOCATION` requires a Play Console declaration — mandatory **27 Jan 2027**.
- **SMS / Call Log**: phone-call account verification via `READ_CALL_LOG` must stop — **27 Jan 2027**
  (announced 15 Jul 2026); consider the SMS User Consent API.
- Reminders: Play Age Signals API launching globally; Japan authorization by **1 Dec 2026**; trader status
  declaration in Console from Nov 2026; app quality requirements **Feb 2027**.
- Earlier 2026: Contacts permissions policy + Android Contact Picker (15 Apr 2026); anonymous/random chat
  restrictions (15 Jul 2026).

## Trader status — re-check after 2027-02-01

Source: https://support.google.com/googleplay/android-developer/answer/17594752

- All active developer accounts declare trader / non-trader (EEA & UK law, regardless of where apps ship).
  New accounts at creation; **existing accounts by 1 Feb 2027**. Missing it → update blocks, global removal.
- Console: Manage account → Account details → About you; per app: Policy and programs → App content.
- Traders self-certify compliance, add a terms-of-service link; personal accounts publish phone + address.
- **1 Mar 2027**: contact details, D-U-N-S and ToS shown to all users; in EEA/UK the developer replaces
  Google in "Offered by" (marketplace model).

## Technical quality requirements — re-check after 2027-04-30

Sources: https://support.google.com/googleplay/android-developer/answer/17492799 ,
https://developer.android.com/blog/posts/elevating-app-quality-reducing-memory-usage-and-improving-device-migration

From **February 2027** (mobile/tablet; last 28 days, 90th percentile):

Memory (anon RSS + swap), apps — foreground / user-perceived services / background:

| RAM tier | Foreground | UPS | Background |
|---|---|---|---|
| < 4 GB | – | – | – |
| 4 GB | 2 GB | 1 GB | 1 GB |
| 6 GB | 2.25 GB | 1.25 GB | 1.25 GB |
| 8 GB | 2.25 GB | 1.5 GB | 1.5 GB |
| 12 GB | 3.25 GB | 1.75 GB | 1.75 GB |
| 16 GB | 4.25 GB | 2 GB | 2 GB |

Games: 4 GB 2.25/2.0/2.0, 6 GB 2.75/2.5/2.5, 8 GB 3.5/2.75/2.75, 12 GB 4/3.2/3.2, 16 GB 5/3.5/3.5 GB.
Bitmap memory: > 200 MB in user-perceived services or background, > 400 MB cached.

DEX optimization (all form factors): ≥ **25% each** of obfuscation, optimization and shrinking when DEX
is above **10 MB (apps) / 50 MB (games)**; any shrinker (R8). Play Console release overview shows DEX insights.

From **April 2027**: **Zero-tap sign-in restoration** for apps with sign-in (Restore Credentials API, Android 9+)
after device-to-device transfer or cloud restore. Exempt: Block Store integrations live by 30 Sep 2026,
enterprise/private apps, games (for now); regulated apps can request an exemption.

Consequence: reduced visibility and publishing capabilities; required for Apps Experience Program / Level Up.
Related platform change: Android 17 memory limiter (`MemoryLimiter:AnonSwap` exit description).
