---
description: Flutter 3.47 + AGP 9. App still applies kotlin-android (KGP). Expect the built-in Kotlin migration - remove KGP + kotlinOptions, add kotlin { compilerOptions { jvmTarget } }, gradle.properties flags.
tags: [flutter-upgrade, upgrade-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

We upgraded to Flutter 3.47 and bumped the Android Gradle Plugin to 9.0.1. Now the Android build fails complaining about the Kotlin Android plugin. I don't want to downgrade AGP. Fix the Android Gradle files properly for this setup and explain what to check about our plugins. Show every changed file.
