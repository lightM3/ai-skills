---
description: Version is only discoverable from pubspec.yaml (2.x). Family notifier must use the 2.x FamilyNotifier + build(arg) form, not the 3.x constructor form.
tags: [flutter-riverpod, hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Add state for the cart quantity of a single product. I want one provider instance per product id (a provider family), so each product tile only rebuilds when its own quantity changes. The quantity starts at 0, with increment() and decrement() (never below 0). It belongs in lib/features/cart/. Follow the conventions this project already uses, and reply with the full Dart file.
