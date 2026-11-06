---
type: llm
---

Facts for Flutter 3.44-3.47: `describeEnum` was removed (use `.name`). `IconData` is now a `final` class, so `enum AppIcons implements IconData` no longer compiles; the migration is a wrapper class with `static const` instances (e.g. `final class AppIconData { const AppIconData._(this.iconData); final IconData iconData; static const done = AppIconData._(IconData(0xe876, fontFamily: 'MaterialIcons')); ... }`) and/or a custom widget, or plain `static const IconData` fields in a class. `onReorder` is deprecated in favour of `onReorderItem`, whose `newIndex` is ALREADY corrected — the `if (oldIndex < newIndex) newIndex -= 1;` line must be removed when switching. `cacheExtent` is deprecated in favour of `scrollCacheExtent: const ScrollCacheExtent.pixels(800)`.

PASS if all of the following hold:
- `describeEnum(priority)` is replaced with `priority.name`.
- AppIcons no longer implements/extends IconData; icons are `const IconData(...)` values held in a class (wrapper or static consts), and usages compile (e.g. `Icon(AppIcons.done)` updated accordingly).
- ReorderableListView uses `onReorderItem` and the `newIndex -= 1` adjustment is REMOVED.
- `cacheExtent: 800` becomes `scrollCacheExtent: const ScrollCacheExtent.pixels(800)` (or 800.0).

Optionally also migrating imports to `package:material_ui` (with the dependency added) is acceptable and not required.

FAIL if it keeps `newIndex -= 1` inside onReorderItem (double correction bug), keeps `onReorder`, keeps `implements IconData`, adds `// ignore` comments instead of migrating, or invents APIs.
