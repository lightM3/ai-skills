---
type: llm
---

The project uses go_router 17. Since 10.0 `GoRouterState.location`, `subloc`, `queryParameters` are gone; use `state.uri` (full location incl. query), `state.matchedLocation`, `state.uri.queryParameters`, `state.pathParameters`.

PASS if all of the following hold:
- A top-level `redirect: (context, state) { ... }` on GoRouter with `refreshListenable: auth`.
- Logged-out + not on /login → returns a login location carrying the original full location (from `state.uri.toString()` or equivalent), properly URL-encoded (e.g. `Uri(path: '/login', queryParameters: {'from': state.uri.toString()}).toString()` or `Uri.encodeComponent`).
- Logged-in + on /login → returns the `from` query parameter (read via `state.uri.queryParameters['from']`) or '/' if absent.
- Returns null otherwise, so there is no redirect loop.
- Uses `state.matchedLocation` or `state.uri.path` to check whether the user is on /login.

FAIL if it uses state.location/subloc/queryParameters, drops the query string from the return path, does not URL-encode the from value, or puts the guard in each route's builder instead of redirect.
