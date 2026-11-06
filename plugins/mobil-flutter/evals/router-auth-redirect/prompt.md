---
description: Auth guard with redirect. Must use state.uri / matchedLocation (not removed state.location/subloc/queryParameters), refreshListenable, a from= return path, and no redirect loop.
tags: [flutter-go-router, router-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Add an auth guard to lib/router/router.dart: logged-out users who open any page other than /login should be sent to the login page, and after logging in they should land back on the exact page they originally asked for (including any query string, e.g. /orders/42?highlight=true). Logged-in users who open /login go to /. The router must react immediately when the user logs in or out. Reply with the updated file.
