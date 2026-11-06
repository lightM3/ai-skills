---
description: Diagnose a ThemeData type mismatch caused by mixing package:flutter/material.dart with package:material_ui.
tags: [flutter-material-ui, mui-hard]
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

`flutter run` fails with this and I don't get it — it's literally the same class:

```
lib/main.dart:5:42: Error: The argument type 'ThemeData/*1*/' can't be assigned to the parameter type 'ThemeData/*2*/?'.
 - 'ThemeData/*1*/' is from 'package:flutter/src/material/theme_data.dart' ('../../flutter/packages/flutter/lib/src/material/theme_data.dart').
 - 'ThemeData/*2*/' is from 'package:material_ui/src/theme_data.dart' ('../../.pub-cache/hosted/pub.dev/material_ui-1.10.0/lib/src/theme_data.dart').
void main() => runApp(MaterialApp(theme: buildTheme(), home: const ProfilePage()));
                                         ^
```

What's wrong and how do I fix it properly?
