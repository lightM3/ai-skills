---
description: Ordinary Kotlin feature work in an Android project must not trigger the AGP, target-SDK, Play or Compose-upgrade skills.
tags: [android-agp, android-target-sdk, android-play, android-compose, negative]
max_turns: 6
allowed_tools: [Read, Glob, Grep, Skill]
---

Add a small Kotlin function in app/src/main/java/com/acme/notes/util/Slug.kt that turns a note title into a URL slug ("Hello, World!" -> "hello-world"), plus a couple of JUnit tests. Reply with both files.
