---
description: Block navigation (deep links included) to /admin/* for non-admins while staying on the current page. Expect top-level onEnter returning Block.then / Allow (go_router 16.3+), not a redirect hack.
tags: [flutter-go-router, router-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Non-admin users must not be able to open anything under /admin — whether they tap a link inside the app or the app is opened from a deep link. Don't send them to another page: the navigation should simply not happen, they stay exactly where they were, and we show a snackbar "Admins only" (use scaffoldMessengerKey). Admins navigate normally. Implement it in lib/router/router.dart and reply with the updated file.
