---
description: Migrate an app to the standalone material_ui / cupertino_ui packages (Flutter 3.47). Expect dart fix migrate_design_widgets, both deps, GlobalMaterialLocalizations.delegates, and MaterialUiCompatibilityBridge for the legacy third-party package.
tags: [flutter-material-ui, mui-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

We're on Flutter 3.47 and the IDE keeps telling us package:flutter/material.dart is going away. Migrate this app to the new standalone Material/Cupertino packages. Tell me exactly what commands to run and show every file that changes. Note we depend on calendar_date_picker2, which hasn't been updated yet.
