---
type: llm
---

Facts (Flutter 3.47, Aug 2026): Material and Cupertino ship as standalone packages `material_ui` and `cupertino_ui` (1.x on pub.dev). Migration: `dart fix --apply --code=migrate_design_widgets` (rewrites imports to `package:material_ui/material_ui.dart` / `package:cupertino_ui/cupertino_ui.dart`), `flutter pub add material_ui cupertino_ui` if pubspec isn't updated. Localization delegates moved into the packages: `localizationsDelegates: GlobalMaterialLocalizations.delegates` (includes Cupertino + Widgets). For dependencies that still import the legacy library, wrap with `MaterialUiCompatibilityBridge(child: child!)` in `MaterialApp.builder`; the bridge passes theme/localizations but cannot fix API type mismatches.

PASS if the answer:
- gives the `dart fix --apply --code=migrate_design_widgets` command and adds both material_ui and cupertino_ui (the app uses Cupertino too);
- rewrites imports in main.dart, home_page.dart (material_ui) and onboarding_page.dart (cupertino_ui);
- replaces the three delegates with `GlobalMaterialLocalizations.delegates` imported from material_ui (dropping the flutter_localizations import);
- adds `builder: (context, child) => MaterialUiCompatibilityBridge(child: child!)` to MaterialApp because calendar_date_picker2 still uses the legacy library, and notes the type-mismatch limitation or suggests upgrading the package later.

FAIL if it claims these packages don't exist, invents other package names or APIs, migrates to something else (e.g. a different design package), keeps package:flutter/material.dart imports in the app's own files, or omits the compatibility bridge.
