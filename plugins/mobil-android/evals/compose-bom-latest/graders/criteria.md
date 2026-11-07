---
type: llm
---

Grade only the build files and code in the answer; it doesn't matter that the agent could not write files.

Facts (verified Nov 2026): the latest stable Compose BOM is 2026.09.00 (Compose UI/foundation 1.12.1, Material3 1.4.0). Compose 1.12 compiles against API 37 and requires AGP 9.2.0+, so the app needs `compileSdk = 37` and AGP ≥ 9.2 (latest stable 9.5.0). Compose foundation 1.11 deprecated `Modifier.onFirstVisible()` (it can fire again on every re-entry) in favour of `Modifier.onVisibilityChanged()` with your own "already logged" tracking. Compose 1.12 renamed `TextObfuscationMode.Default` to `TextObfuscationMode.System` (secure text fields now default to System).

PASS if the answer:
- sets the BOM to 2026.09.00;
- raises compileSdk to 37 and AGP to ≥ 9.2 (explaining Compose 1.12 requires it);
- replaces `onFirstVisible` with `onVisibilityChanged` plus first-time tracking (e.g. a remembered/saveable flag or tracking in the ViewModel/analytics layer);
- replaces `TextObfuscationMode.Default` with `TextObfuscationMode.System` (or removes the argument because System is the default).

FAIL if it picks an older BOM as "latest", or keeps compileSdk 36 with the new BOM.
