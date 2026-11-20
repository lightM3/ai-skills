---
description: Adding a search query to an existing Room DAO is ordinary feature work, not a Room 3 migration; the Room 3 skill must not fire.
tags: [android-room3, negative]
max_turns: 8
allowed_tools: [Read, Glob, Grep, Skill]
---

Add a `searchByTitle(query: String): Flow<List<Note>>` function to NoteDao that matches titles case-insensitively with LIKE, pinned notes first. Reply with the updated DAO.
