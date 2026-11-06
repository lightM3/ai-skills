---
description: Live message stream in a Bloc. Must use emit.forEach / emit.onEach, not stream.listen + emit or add.
tags: [flutter-bloc, bloc-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Add a ChatBloc in lib/features/chat/ for a chat room screen. When the screen opens it should start showing the room's messages live from ChatRepository.watchMessages, and update whenever new messages arrive. If the stream errors, show an error state. Also support sending a message. Follow the project's existing conventions and reply with the full Dart file(s).
