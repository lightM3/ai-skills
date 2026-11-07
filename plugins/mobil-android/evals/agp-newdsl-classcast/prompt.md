---
description: AGP 9.1 project whose build-logic convention plugin uses BaseExtension and generic CommonExtension. Expect ApplicationExtension/LibraryExtension or non-generic CommonExtension, with android.newDsl=false only as a temporary opt-out (removed in AGP 10).
tags: [android-agp, android-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Since bumping the Android Gradle Plugin, sync fails with:

```
java.lang.ClassCastException: class com.android.build.gradle.internal.dsl.ApplicationExtensionImpl$AgpDecorated_Decorated cannot be cast to class com.android.build.gradle.BaseExtension
	at AndroidConventionPlugin.apply(AndroidConventionPlugin.kt:14)
```

Fix it properly — I don't want a workaround that stops working with the next AGP. Show the changed code.
