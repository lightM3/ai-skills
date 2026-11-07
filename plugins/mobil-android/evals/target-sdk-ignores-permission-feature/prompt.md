---
description: Writing a camera-permission request flow in an app already on targetSdk 37 is ordinary feature work; the target-SDK migration skill must not fire.
tags: [android-target-sdk, negative]
max_turns: 8
allowed_tools: [Read, Glob, Grep, Skill]
---

Add a barcode scan button to the app: when tapped, request the CAMERA permission with the Activity Result API (show a short rationale if the user denied it before) and then open a `ScannerScreen` composable placeholder. Reply with the code.
