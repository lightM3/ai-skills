---
description: After upgrading 3.41 -> 3.47 - describeEnum removed, IconData final, onReorder -> onReorderItem (index fix must be dropped), cacheExtent -> scrollCacheExtent.
tags: [flutter-upgrade, upgrade-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

We just upgraded this app from Flutter 3.41 to 3.47 (latest stable). It no longer compiles and `flutter analyze` also shows deprecation warnings. Update the code in lib/ for the new Flutter version — fix the errors and the deprecations properly, not with ignores. Reply with every changed file in full.
