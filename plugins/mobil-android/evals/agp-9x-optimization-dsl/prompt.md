---
description: Project on AGP 9.0.1 with android.newDsl=false (one module still on applicationVariants) and legacy minify/shrink config. Expect 9.5.0 + Gradle 9.6, the 9.3 optimization { enable = true } DSL with src/main/keepRules/*.keep, per-module android.newDsl.optOut (9.4) instead of the global flag, and the 9.2 R8 keepattributes change.
tags: [android-agp, android-hard, v2, h2h]
max_turns: 14
allowed_tools: [Read, Glob, Grep, Skill]
---

We're on an early AGP 9 release. Bring the build up to the latest AGP and modernize the release shrinking setup to what the new version recommends. Also, the global opt-out in gradle.properties exists only because of the legacy `:analytics` module — handle that in the cleanest way the new AGP allows. Show every changed file.
