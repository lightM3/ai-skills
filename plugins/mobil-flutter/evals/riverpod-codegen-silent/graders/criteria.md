---
type: llm
---

The project uses Riverpod 3.x with code generation (riverpod_annotation + riverpod_generator).

PASS if all of the following hold:
- The state is an @riverpod class extending _$ClassName whose build() returns Future<Set<String>> (or similar collection of ids) loaded via ref.watch on favouritesRepositoryProvider.
- The toggle method reaches the repository with ref.read (not ref.watch).
- After any await in the toggle method, it either checks ref.mounted before assigning state, or only calls ref.invalidateSelf().
- The reply tells the user to run build_runner (e.g. `dart run build_runner build -d` or `watch`).

FAIL if providers are declared by hand (AsyncNotifierProvider<...>(...)), StateNotifier/StateProvider is used, the build_runner step is missing, or state is assigned after an await without a ref.mounted check.
