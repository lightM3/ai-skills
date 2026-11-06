---
type: llm
---

The project's convention (see lib/features/settings) is: Cubit, a sealed state class extending Equatable with final subclasses (Loading / Loaded / Failure), and a BlocProvider(create: ...) + BlocBuilder with a Dart 3 `switch` over the state in the page.

PASS if all of the following hold:
- Uses a Cubit (not a Bloc with events) and a sealed Equatable state hierarchy in the same style.
- Pinning creates a NEW list (e.g. `[for (final n in notes) n.id == id ? n.copyWith(pinned: p) : n]` or List.of + replace) and emits a new Loaded state; it never mutates the existing list in place (no `.add`, `[i] =`, `.removeWhere` on the current state's list) before emitting.
- On save failure it re-emits the previous list. After an await, it checks `isClosed` before emitting.
- The page uses BlocProvider(create: ...) and BlocBuilder with a switch (or equivalent), and calls cubit methods with `context.read` inside callbacks (not context.watch).

FAIL if it uses Bloc+events, mutates the state's list in place, emits after an await without an isClosed check, or uses context.watch/BlocProvider.of(listen: true) inside a callback.
