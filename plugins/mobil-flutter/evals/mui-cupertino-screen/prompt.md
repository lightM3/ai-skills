---
description: material_ui app adding an iOS-style screen. Must import package:cupertino_ui and add cupertino_ui as a direct dependency (not package:flutter/cupertino.dart).
tags: [flutter-material-ui, mui-hard]
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

For the iOS build we want the login screen to look native. Create lib/features/login/login_page.dart using Cupertino widgets: a navigation bar titled "Sign in", email and password text fields, and a filled "Continue" button that shows an activity indicator while `onSubmit` (a Future<void> Function(String email, String password)) runs. Reply with the full file and any pubspec changes.
