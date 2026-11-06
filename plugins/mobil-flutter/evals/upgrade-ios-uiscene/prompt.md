---
description: Xcode 27 requires UIScene. Custom AppDelegate creates a method channel from window.rootViewController. Expect FlutterImplicitEngineDelegate + didInitializeImplicitFlutterEngine + engineBridge messenger + UIApplicationSceneManifest with FlutterSceneDelegate.
tags: [flutter-upgrade, upgrade-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

We're on Flutter 3.47 and just moved CI to Xcode 27. The iOS app now crashes immediately on launch, and `flutter build ios` printed something about the UIScene migration not being applied because our AppDelegate is customized. Fix the iOS side. Show the full updated files.
