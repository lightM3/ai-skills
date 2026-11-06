---
description: In a Riverpod 3.x codegen project, Claude should write an AsyncNotifier with @riverpod, not a StateNotifier.
tags: [flutter-riverpod, smoke]
max_turns: 8
allowed_tools: [Read, Glob, Grep, Skill]
---

My Flutter app's pubspec has these dependencies:

```yaml
dependencies:
  flutter_riverpod: ^3.3.0
  riverpod_annotation: ^3.0.3
dev_dependencies:
  riverpod_generator: ^3.0.3
  build_runner: ^2.4.0
```

I have a `ProductRepository` with `Future<List<Product>> fetchAll()` and `Future<void> delete(String id)`, exposed through `productRepositoryProvider`.

Write the state management for a product list screen: load the products, and let the user delete one. Then show the widget that displays the list with loading and error states. Just give me the Dart code in your reply.
