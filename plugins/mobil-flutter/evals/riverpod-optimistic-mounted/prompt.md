---
description: Optimistic delete in a 3.x AsyncNotifier. State is written after an await, so a ref.mounted check is required (using a disposed Ref throws in 3.x).
tags: [flutter-riverpod, hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Implement the delete method in lib/features/todos/todos_notifier.dart. It should feel instant: remove the todo from the list right away, then call the repository. If the repository call fails, put the previous list back and surface the error. The provider is autoDispose and users often navigate away while the request is in flight, so make sure that's handled. Reply with the updated file.
