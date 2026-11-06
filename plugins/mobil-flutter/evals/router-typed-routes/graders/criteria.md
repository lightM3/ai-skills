---
type: llm
---

The project uses go_router 17 with go_router_builder 4 (typed routes declared as `class X extends GoRouteData with $X`, `part 'routes.g.dart'`, `$appRoutes`).

PASS if all of the following hold:
- ProductRoute is declared as `class ProductRoute extends GoRouteData with $ProductRoute` (public `$` mixin, not `_$ProductRoute`, and not without a mixin).
- It is a child of HomeRoute via `@TypedGoRoute<HomeRoute>(path: '/', routes: [TypedGoRoute<ProductRoute>(path: 'product/:id')])` (relative child path, no leading slash).
- `id` is a constructor field (path param) and `tab` is an optional nullable or defaulted field so it becomes a query parameter; the enum ProductTab is acceptable as the field type.
- The home screen navigates with `ProductRoute(id: id).push(context)` or `.go(context)` (either keeps home underneath since it is a child route).
- The reply says to run build_runner.

FAIL if it uses `with _$ProductRoute`, omits the mixin, defines a top-level `/product/:id` GoRoute by hand alongside the typed routes, navigates with a string path like `context.push('/product/$id')`, or reads parameters from `state.pathParameters` in the typed route.
