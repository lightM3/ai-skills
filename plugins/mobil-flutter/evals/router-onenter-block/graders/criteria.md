---
type: llm
---

The project uses go_router 17, which has a top-level `onEnter: (context, currentState, nextState, router) => ...` callback returning `Allow()` / `Block.stop()` / `Block.then(() {...})` (added in 16.3).

PASS if all of the following hold:
- Uses GoRouter's top-level `onEnter` with the four parameters (context, current state, next state, router).
- Checks the destination with `nextState.uri.path` / `nextState.matchedLocation` (startsWith '/admin') and `session.isAdmin`.
- Non-admin → returns `Block.then(() => scaffoldMessengerKey.currentState?.showSnackBar(...))` (or Block.stop() plus showing the snackbar in a safe way); admin/other → `const Allow()`.
- Does not use redirect to bounce the user to another page.

FAIL if it uses `redirect` (e.g. returning '/' or the previous location), checks inside the admin page's builder, wraps the admin routes in a guard widget, or uses state.location / other removed APIs.
