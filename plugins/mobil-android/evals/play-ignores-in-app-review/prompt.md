---
description: Integrating the Play In-App Review API is a feature, not a release/policy question; the Play rules skill must not fire.
tags: [android-play, negative]
max_turns: 8
allowed_tools: [Read, Glob, Grep, Skill]
---

After the user completes their fifth order, show the Google Play in-app review prompt. Add the dependency and a small `ReviewPrompter` class that tracks the order count and launches the review flow. Reply with the code.
