---
description: App Store Connect rejected an upload with ITMS-90725 (old SDK) and ITMS-91053 (missing required-reason API declaration for UserDefaults). Expect Xcode 26 / iOS 26 SDK (required since 28 Apr 2026) in CI and a PrivacyInfo.xcprivacy with NSPrivacyAccessedAPICategoryUserDefaults / CA92.1 added to the Runner target.
tags: [flutter-release, release-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Our CI upload to App Store Connect just bounced with these two emails:

- ITMS-90725: SDK version issue - This app was built with the iOS 18.5 SDK. All iOS and iPadOS apps must be built with the iOS 26 SDK or later, included in Xcode 26 or later, in order to be uploaded to App Store Connect or submitted for distribution.
- ITMS-91053: Missing API declaration - Your app's code in the "Runner" file references one or more APIs that require reasons, including the following API categories: NSPrivacyAccessedAPICategoryUserDefaults.

Fix both. Show every file that changes.
