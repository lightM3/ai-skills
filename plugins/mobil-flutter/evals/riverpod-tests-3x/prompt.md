---
description: Unit tests for a 3.x codegen notifier. Expect ProviderContainer.test, overriding the repository (not the notifier), and awaiting .future.
tags: [flutter-riverpod, hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Write unit tests for the Cart notifier in lib/features/cart/cart.dart: it loads the initial cart from the repository, and add() increments a product's quantity and saves it. Don't hit the real repository. Reply with the full test file for test/cart_test.dart.
