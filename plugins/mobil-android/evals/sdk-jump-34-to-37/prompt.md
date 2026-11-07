---
description: Views app on targetSdk 34 jumping to the newest API. Triggers from 35 (edge-to-edge, dataSync FGS timeout + BOOT_COMPLETED, removeFirst), 36 (edge-to-edge opt-out ignored, predictive back - onBackPressed not called) and 37 (static final reflection, implicit URI grants warning). Expect each change mapped to the API level it comes from.
tags: [android-target-sdk, android-hard, v2]
max_turns: 16
allowed_tools: [Read, Glob, Grep, Skill]
---

Our app still targets API 34 and Play keeps nagging us. We want to jump straight to the newest targetSdk in one go. Go through the code and list everything that will break or behave differently, grouped by the Android version that introduces it, with the fix for each.
