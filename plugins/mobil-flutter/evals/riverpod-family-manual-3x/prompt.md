---
description: Manual (no codegen) family notifier in Riverpod 3.x must take its argument via the constructor, not build(arg).
tags: [flutter-riverpod]
max_turns: 8
allowed_tools: [Read, Glob, Grep, Skill]
---

We use flutter_riverpod ^3.3.0 without code generation (no riverpod_generator), and declare providers by hand.

I need a notifier that holds the cart quantity for a single product, keyed by product id (String). It starts at 0 and has increment() and decrement() (never below 0). Show the provider declaration and the notifier class.
