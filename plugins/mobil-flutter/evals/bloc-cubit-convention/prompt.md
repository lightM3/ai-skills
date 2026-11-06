---
description: Project uses Cubit + sealed Equatable states + switch in BlocBuilder. New feature must match, and must update the list immutably.
tags: [flutter-bloc, bloc-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Add the notes list feature in lib/features/notes/: load notes from NotesRepository, and let the user pin/unpin a note (update it in the list right away, then save; if saving fails, revert it). Include the state management and the page widget. Follow the project's existing conventions and reply with the full Dart files.
