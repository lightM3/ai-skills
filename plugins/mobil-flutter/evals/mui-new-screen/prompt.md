---
description: App already on material_ui (Flutter 3.47+). A new screen must import package:material_ui, never package:flutter/material.dart.
tags: [flutter-material-ui, mui-hard]
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Create lib/features/settings/settings_page.dart: a settings screen with an app bar, a switch to toggle dark mode (it receives the app's ValueNotifier<ThemeMode>), and a "Clear all notes" button that asks for confirmation in a dialog first. Reply with the full file.
