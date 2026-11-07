---
description: Widget pushes full-resolution bitmaps through RemoteViews; after targetSdk 37 updateAppWidget throws IllegalArgumentException. Expect the API 37 bitmap memory cap (6 x screen width x height), WindowMetrics-based budget, downsampling/RGB_565 or URI images.
tags: [android-target-sdk, android-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Since our last release the home-screen photo widget stopped updating for many users, and Crashlytics shows an IllegalArgumentException thrown from AppWidgetManager.updateAppWidget. Nothing in the widget code changed in that release. Find the cause and fix it.
