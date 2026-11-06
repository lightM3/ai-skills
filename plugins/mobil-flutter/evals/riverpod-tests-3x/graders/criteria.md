---
type: llm
---

The project uses Riverpod 3.x with code generation. In 3.x the idiomatic test container is `ProviderContainer.test(overrides: [...])`, which disposes itself after the test.

PASS if all of the following hold:
- Containers are created with ProviderContainer.test (no manual dispose/addTearDown needed).
- The repository is replaced through an override of cartRepositoryProvider (e.g. overrideWithValue with a fake or mock), not by overriding the Cart notifier itself.
- The initial-load test awaits `container.read(cartProvider.future)` (or equivalent) before asserting.
- The add() test asserts both the new state and that save() was called on the fake with the updated map.

FAIL if it uses `ProviderContainer(...)` plus manual disposal, overrides cartProvider instead of the repository, asserts on the AsyncValue without awaiting the load, or calls the real CartRepository.
