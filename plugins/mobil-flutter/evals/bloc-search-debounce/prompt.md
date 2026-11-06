---
description: Search-as-you-type Bloc. Expect an event transformer (debounce + restartable/switchMap), not a Timer that calls emit.
tags: [flutter-bloc, bloc-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Write a SearchBloc in lib/features/search/ for a search-as-you-type field backed by SearchRepository. Requirements: don't call the API on every keystroke (wait ~300 ms after the user stops typing), and a slow, older response must never overwrite the results of a newer query. Empty query clears the results. Reply with the Dart code and any pubspec changes.
