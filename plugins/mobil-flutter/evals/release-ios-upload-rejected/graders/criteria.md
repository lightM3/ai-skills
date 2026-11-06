---
type: llm
---

Facts: since 28 April 2026 apps uploaded to App Store Connect must be built with Xcode 26+ and the iOS 26 SDK. ITMS-91053 is fixed by an app privacy manifest `ios/Runner/PrivacyInfo.xcprivacy` declaring `NSPrivacyAccessedAPITypes` with an entry `NSPrivacyAccessedAPIType` = `NSPrivacyAccessedAPICategoryUserDefaults` and `NSPrivacyAccessedAPITypeReasons` = [`CA92.1`] (access info only from the same app), and the file must be added to the Runner target (Copy Bundle Resources) in Xcode. Third-party SDKs ship their own manifests; updating plugins may also be needed.

PASS if the answer:
- switches CI to Xcode 26 or later (e.g. `xcode-version: '26'` / latest-stable) on a macOS runner image that has it (e.g. macos-15 or newer), explaining the 28 April 2026 requirement;
- adds a PrivacyInfo.xcprivacy for the Runner target containing NSPrivacyAccessedAPICategoryUserDefaults with reason CA92.1 (because NativeStore.swift reads/writes its own app's UserDefaults);
- tells the user to add the file to the Runner target (Xcode → Copy Bundle Resources), since dropping it in the folder isn't enough;
- optionally mentions updating plugins/pods that use required-reason APIs.

FAIL if it suggests a reason code that doesn't fit (e.g. 1C8F.1 app-group without app groups, or a made-up code), keeps Xcode 16, tells the user to reply to Apple instead of fixing, or invents keys.
