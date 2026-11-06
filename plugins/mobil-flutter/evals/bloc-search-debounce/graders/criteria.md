---
type: llm
---

PASS if all of the following hold:
- The query-changed handler is registered with `on<...>(handler, transformer: ...)` and the transformer is restartable / switchMap-like, so an in-flight older search is cancelled when a newer query arrives. Debouncing (~300 ms) is done either in the transformer (stream_transform `debounce` / rxdart `debounceTime` before `switchMap`) or by awaiting a ~300 ms delay at the start of a handler registered with `restartable()` (the cancelled handler's emits are ignored, so this is also correct).
- Any package it relies on (bloc_concurrency, stream_transform, rxdart) is listed as a pubspec change.
- An empty query clears results without calling the repository.

FAIL if debounce is done with a Timer whose callback calls emit or add, if staleness is handled only by comparing the query string after the await while still allowing concurrent handlers (no restartable/switchMap), or if emit is called outside the running handler.
