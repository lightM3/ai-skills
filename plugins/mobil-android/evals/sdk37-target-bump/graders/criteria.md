---
type: llm
---

Grade only the review and code in the answer; it doesn't matter that the agent could not write files.

Facts (Android 17 = API 37, stable June 2026; behavior changes for apps targeting 37):
1. Standard SMS containing OTPs are withheld from most apps for 3 hours (SMS_RECEIVED_ACTION held back, SMS provider filtered) → migrate to SMS Retriever or SMS User Consent API.
2. Local network access needs the runtime permission `ACCESS_LOCAL_NETWORK` (NEARBY_DEVICES group) → declare + request it, or use a system device picker. NSD discovery and the raw socket to the LAN printer are affected.
3. On large screens (sw ≥ 600dp) orientation/resizability/aspect-ratio restrictions are ignored and the opt-out property `PROPERTY_COMPAT_ALLOW_RESTRICTED_RESIZABILITY` is no longer honored at API 37 (only works when targeting 36) → layouts must handle any orientation/size.
4. `ContentCaptureManager.setContentCaptureEnabled(false)` no longer disables content capture → use `FLAG_SECURE` on the window.
5. Background activity launch rules now cover `IntentSender`; `MODE_BACKGROUND_ACTIVITY_START_ALLOWED` must become `MODE_BACKGROUND_ACTIVITY_START_ALLOW_IF_VISIBLE`.

PASS if the answer sets compileSdk/targetSdk to 37 and correctly identifies and fixes at least 4 of the 5 items above.

FAIL if it treats 36 as the newest version, or invents behavior changes as the main findings while missing most of the five.
