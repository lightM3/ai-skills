---
description: Play Console warns the app doesn't support 16 KB memory page sizes. Expect the Feb 1 2027 update deadline, AGP >= 8.5.1, NDK r28+, verifying with zipalign -P 16 / APK Analyzer, and updating or replacing the plugin with misaligned prebuilt .so files.
tags: [flutter-release, release-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Play Console shows a warning on our latest release: "Your app does not support 16 KB memory page sizes". How urgent is this, what exactly is causing it in our project, and how do we fix and verify it? Show any file changes.
