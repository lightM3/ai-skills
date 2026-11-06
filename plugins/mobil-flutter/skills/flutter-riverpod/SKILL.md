---
name: flutter-riverpod
description: Use for any Flutter/Dart task in a Riverpod project — adding or changing state, providers or notifiers, wiring widgets to state, or writing unit/widget tests for providers — even when the request just says "state", "notifier" or "tests" and Riverpod only shows up in pubspec.yaml (flutter_riverpod, hooks_riverpod, riverpod_annotation) or in code (ref.watch, ConsumerWidget, @riverpod). Keeps code on the Riverpod version the project actually uses (2.x vs 3.x), its codegen/manual style, and Notifier/AsyncNotifier instead of legacy providers. Do not use for projects on Bloc or Provider.
---

# Flutter Riverpod

Riverpod's API changed a lot between 1.x, 2.x and 3.x, and most examples online
are outdated. The most common failure is writing **legacy APIs** (`StateNotifier`,
`StateProvider`, `ChangeNotifierProvider`) or **2.x patterns in a 3.x project**.
This skill exists to prevent that.

## Step 1 — Detect the version before writing code

Read `pubspec.yaml` (and `pubspec.lock` if present) and note:

- `flutter_riverpod` / `hooks_riverpod` major version → **2.x or 3.x**
- whether `riverpod_annotation` + `riverpod_generator` + `build_runner` are present → **codegen or manual**

Match the existing style of the project. If the project uses codegen, write
codegen; if it declares providers manually, do not introduce codegen unasked.
If there is no pubspec, ask or default to **3.x with codegen** and say so.

## Step 2 — Pick the right provider

| Need | Use | Never use (legacy) |
|---|---|---|
| Computed / derived value, no mutation | `Provider` / `@riverpod` function | — |
| Sync state + methods that change it | `Notifier` / `@riverpod class` | `StateNotifier`, `StateProvider` |
| Async state (API, DB) + methods | `AsyncNotifier` / `@riverpod class` returning `Future` | `StateNotifier<AsyncValue<T>>` |
| One-shot async read, no methods | `FutureProvider` / `@riverpod Future` function | — |
| Stream | `StreamProvider` / `StreamNotifier` | — |

`StateNotifierProvider`, `StateProvider` and `ChangeNotifierProvider` are legacy.
In 3.x they only exist under `package:flutter_riverpod/legacy.dart`. Only touch
them when the user explicitly works on existing legacy code; when migrating,
move to `Notifier` / `AsyncNotifier`.

## Step 3 — Write it the version-correct way

### Codegen (preferred when the project has riverpod_generator)

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'todos.g.dart';

@riverpod
class Todos extends _$Todos {
  @override
  Future<List<Todo>> build() => ref.watch(todoRepositoryProvider).fetchAll();

  Future<void> add(Todo todo) async {
    await ref.read(todoRepositoryProvider).add(todo);
    ref.invalidateSelf(); // or update state directly
  }
}

// Family: just add parameters
@riverpod
Future<User> user(Ref ref, String id) =>
    ref.watch(userRepositoryProvider).fetch(id);
```

- Codegen providers are **autoDispose by default**. Use `@Riverpod(keepAlive: true)` only for app-wide state.
- Function providers take a plain `Ref ref` (since 2.6 / 3.x), not `XxxRef ref`.
- After adding or changing an annotated provider, remind the user to run
  `dart run build_runner watch -d` (or `build -d`).

### Manual, 3.x

```dart
final counterProvider = NotifierProvider<Counter, int>(Counter.new);

class Counter extends Notifier<int> {
  @override
  int build() => 0;
  void increment() => state++;
}
```

- **Family in 3.x:** the argument goes through the constructor, not `build`:
  `NotifierProvider.family<UserNotifier, User, String>(UserNotifier.new)` with
  `UserNotifier(this.id)` and `build()` taking no parameters.
  (`FamilyNotifier` / `FamilyAsyncNotifier` no longer exist in 3.x.)

### Manual, 2.x

Same shape, but family notifiers extend `FamilyNotifier<State, Arg>` /
`FamilyAsyncNotifier` and receive the arg in `build(Arg arg)`.
Do not use 3.x-only APIs (`ref.mounted`, `ProviderContainer.test`, `legacy.dart` import) in a 2.x project.

## Step 4 — Rules for using `ref`

- `ref.watch` inside `build` methods (widget or provider). `ref.read` inside callbacks
  (`onPressed`, notifier methods). Never `ref.read` in `build` to "avoid rebuilds" —
  use `ref.watch(provider.select((s) => s.field))` instead.
- Side effects in response to state (snackbars, navigation) go in `ref.listen` inside
  `build`, never inside `ref.watch` logic.
- In async notifier methods, after an `await`, check `if (!ref.mounted) return;`
  (3.x) before touching `state` — using a disposed `Ref` throws in 3.x.
- Never create providers inside widgets or methods. Providers are top-level `final`s.

## Step 5 — UI

```dart
class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosProvider);
    return switch (todos) {
      AsyncData(:final value) => TodoList(value),
      AsyncError(:final error) => ErrorView(error),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
```

- Prefer Dart 3 pattern matching on `AsyncValue` (or `.when`) over `isLoading` checks.
- Use `ConsumerWidget` / `ConsumerStatefulWidget`; use `Consumer` only to narrow a rebuild.
- `ProviderScope` wraps the app once, in `main()`.
- 3.x behaviour to keep in mind: failing providers **retry automatically**, providers
  for widgets out of view are **paused**, and updates are filtered with `==`
  (give state classes proper equality — e.g. `freezed` or `Equatable`).

## Step 6 — Tests

- 3.x: `final container = ProviderContainer.test(overrides: [...]);` (auto-disposed).
- 2.x: `ProviderContainer(overrides: [...])` + `addTearDown(container.dispose)`.
- Override repositories, not notifiers: `todoRepositoryProvider.overrideWithValue(FakeRepo())`.
- Widget tests: wrap with `ProviderScope(overrides: [...])`.

## Checklist before finishing

- [ ] Version (2.x/3.x) and style (codegen/manual) match the project
- [ ] No `StateNotifier` / `StateProvider` / `ChangeNotifierProvider` in new code
- [ ] `watch` in build, `read` in callbacks, `listen` for side effects
- [ ] `ref.mounted` checked after `await` in 3.x notifiers
- [ ] build_runner reminder given if codegen files changed
