---
description: go_router_builder 4.x typed routes. New route must use `extends GoRouteData with $ProductRoute`, be a child of HomeRoute, and be navigated with the generated .push/.go, not string paths.
tags: [flutter-go-router, router-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Add a product detail route under the home route: the URL should be like /product/p1 with an optional ?tab=reviews query parameter, showing ProductScreen. Then make tapping a product on the home screen open it (so the back button returns home). Follow the project's routing conventions and reply with the changed Dart files and anything I need to run.
