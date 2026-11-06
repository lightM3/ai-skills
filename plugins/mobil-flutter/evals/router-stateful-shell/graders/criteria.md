---
type: llm
---

PASS if all of the following hold:
- Uses `StatefulShellRoute.indexedStack(builder: (context, state, navigationShell) => ScaffoldWithNavBar(navigationShell: navigationShell), branches: [...])` with three `StatefulShellBranch`es (feed, search, profile).
- Post and settings are nested child GoRoutes inside their branch with relative paths (e.g. `GoRoute(path: '/feed', routes: [GoRoute(path: 'post/:id', ...)])`).
- The nav bar uses `navigationShell.currentIndex` for the selected index and on tap calls `navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex)`.
- The scaffold's body is the `navigationShell` itself.

FAIL if it uses a plain ShellRoute with a manually tracked index or `context.go('/feed')` on tab tap (loses per-tab stacks), uses IndexedStack + separate Navigators by hand, or omits the initialLocation pop-to-root behaviour.
