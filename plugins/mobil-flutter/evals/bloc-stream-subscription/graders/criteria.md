---
type: llm
---

PASS if all of the following hold:
- The bloc subscribes to watchMessages inside an event handler using `await emit.forEach(...)` (or `emit.onEach`), mapping each list to a new state, with onError mapping to an error state.
- There is no manual `stream.listen(...)`, StreamSubscription field, or "internal" event added from a listen callback.
- The handler that watches the stream uses a restartable transformer or otherwise ensures re-subscribing does not create duplicate subscriptions (restartable() from bloc_concurrency is ideal; acceptable if only one started event is ever dispatched and this is stated).
- Events use the project's style (sealed base class + final classes) and state uses Equatable.

FAIL if emit is called from inside a .listen callback or a Timer, or if a StreamSubscription is managed manually.
