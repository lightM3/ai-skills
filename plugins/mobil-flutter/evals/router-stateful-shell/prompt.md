---
description: Bottom navigation where each tab keeps its own stack. Expect StatefulShellRoute.indexedStack + StatefulShellBranch + navigationShell.goBranch(initialLocation:), not ShellRoute + manual index.
tags: [flutter-go-router, router-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Restructure lib/router/router.dart so the app has a bottom navigation bar with three tabs: Feed, Search and Profile. Each tab must keep its own navigation stack and scroll position when the user switches tabs (e.g. open a post in Feed, switch to Profile, come back and the post is still open). Tapping the tab that is already selected should pop back to that tab's root. Post and settings pages stay inside their tab with the bar visible. Reply with the full Dart file(s), including the scaffold widget with the bar.
