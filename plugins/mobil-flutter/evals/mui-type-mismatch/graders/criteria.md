---
type: llm
---

Cause: lib/theme/app_theme.dart still imports the legacy in-SDK `package:flutter/material.dart`, while the rest of the app uses the standalone `package:material_ui` (Flutter 3.47+). They are distinct libraries, so their ThemeData types are different and not assignable.

PASS if the answer identifies app_theme.dart's `package:flutter/material.dart` import as the cause, explains the two libraries define distinct types, fixes it by changing that import to `package:material_ui/material_ui.dart`, and recommends running `dart fix --apply --code=migrate_design_widgets` (or searching) to catch any other legacy imports. Mentioning that MaterialUiCompatibilityBridge cannot fix type mismatches is a plus but not required.

FAIL if it suggests casting, `as ThemeData`, hiding/aliasing imports to keep both, downgrading Flutter, removing material_ui, `flutter clean` as the fix, or wrapping with MaterialUiCompatibilityBridge as the solution.
