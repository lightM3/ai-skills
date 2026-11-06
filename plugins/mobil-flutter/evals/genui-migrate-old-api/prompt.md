---
description: Code written for genui 0.6 must be migrated to 0.10 - Conversation/SurfaceController/A2uiTransportAdapter/Surface/BasicCatalogItems/ChatMessage.user.
tags: [flutter-genui, genui-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

lib/features/assistant_page.dart was written for an older genui. After bumping genui to ^0.10.4 it doesn't compile at all. Port it to the current genui API, keeping the same behaviour (the LLM is still LlmClient). Reply with the full updated file.
