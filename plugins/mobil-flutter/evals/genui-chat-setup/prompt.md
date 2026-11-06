---
description: 'genui 0.10 chat screen. Expect SurfaceController + A2uiTransportAdapter (onSend → LLM → addChunk) + Conversation, BasicCatalogItems, Surface(surfaceContext: controller.contextFor(id)), ConversationSurfaceAdded/Removed — not the pre-0.7 GenUiConversation/A2uiMessageProcessor API.'
tags: [flutter-genui, genui-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

We added the `genui` package. Build lib/features/assistant_page.dart: a chat screen where the user types a request and our LLM (use LlmClient in lib/llm/llm_client.dart) answers by generating UI with genui's built-in basic widgets. Show each generated surface in a list as it appears, remove it when it's removed, and show a spinner while waiting. Reply with the full file.
