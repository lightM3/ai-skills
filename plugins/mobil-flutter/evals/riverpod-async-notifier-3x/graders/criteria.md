---
type: llm
---

PASS if all of the following hold:
- The state is an async notifier class annotated with @riverpod whose build() returns a Future of the product list.
- The delete method uses ref.read (not ref.watch) to reach the repository, and after any await either checks ref.mounted before touching state, or only calls ref.invalidateSelf().
- The widget is a ConsumerWidget (or ConsumerStatefulWidget) that uses ref.watch on the provider and handles loading, error and data states (pattern matching on AsyncValue or .when).
- It mentions running build_runner to generate the .g.dart file.

FAIL if it uses StateNotifier, StateProvider or ChangeNotifierProvider, calls ref.read inside a build method to obtain the list, or omits the error state.
