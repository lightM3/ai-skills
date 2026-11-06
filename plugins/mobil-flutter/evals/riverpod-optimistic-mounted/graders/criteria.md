---
type: llm
---

The project uses Riverpod 3.x (hand-written providers). In 3.x, touching state or ref after the provider is disposed throws UnmountedRefException; the correct guard is `if (!ref.mounted) return;` after each await.

PASS if all of the following hold:
- The todo is removed from state before the repository call is awaited (optimistic update), keeping a copy of the previous list.
- The repository is reached with ref.read, not ref.watch.
- After the await (in both the success and the failure path) the code checks ref.mounted before writing state again.
- On failure it restores the previous list and surfaces the error (e.g. AsyncError carrying the previous data via copyWithPrevious, rethrowing, or an error field) rather than silently swallowing it.

FAIL if state is written after an await without a ref.mounted check, if it relies on a custom _disposed flag / ref.onDispose bookkeeping instead of ref.mounted, if it uses StateNotifier, or if the rollback is missing.
