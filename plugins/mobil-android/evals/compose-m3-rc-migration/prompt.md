---
description: Project overrides material3 to 1.5.0-rc01. Code uses stateless Slider/RangeSlider, rememberModalBottomSheetState, TonalToggleButton and LocalMotionScheme. Expect SliderState/RangeSliderState(startValue/endValue), rememberBottomSheetState, FilledTonalToggleButton, MaterialTheme.motionScheme.
tags: [android-compose, android-hard, v2]
max_turns: 14
allowed_tools: [Read, Glob, Grep, Skill]
---

We bumped Material 3 to try the new expressive components and now the filter sheet no longer compiles (plus a pile of deprecation warnings). Fix FilterSheet.kt properly for the version we're on. Show the full updated file.
