---
type: llm
---

genui 0.10.x API (Sep 2026): `SurfaceController(catalogs: [BasicCatalogItems.asCatalog()])`; `A2uiTransportAdapter(onSend: (ChatMessage message) async { ... })` where onSend calls the LLM and feeds each text chunk with `adapter.addChunk(chunk)`; `Conversation(controller: controller, transport: adapter)`; `conversation.events` emits `ConversationSurfaceAdded(surfaceId, definition)`, `ConversationSurfaceRemoved`, `ConversationWaiting`, `ConversationError`, …; `conversation.state` is a ValueListenable; render with `Surface(surfaceContext: controller.contextFor(surfaceId))`; send with `conversation.sendRequest(ChatMessage.user(text))`; dispose conversation, adapter and controller. The system prompt should include the catalog's generation instructions (e.g. `PromptBuilder.chat(catalog: catalog).systemPromptJoined()`, or the catalog's systemPromptFragments).

Renamed/removed in 0.6–0.10 (must NOT appear): GenUiConversation, GenUiManager, A2uiMessageProcessor, GenUiSurface, GenUiHost, GenUiController, CoreCatalogItems, ContentGenerator, AiClient.

PASS if the answer uses the 0.10 classes above correctly: the onSend callback calls LlmClient.streamText and pipes chunks into addChunk, surfaces are tracked from ConversationSurfaceAdded/Removed events and rendered with Surface(surfaceContext: controller.contextFor(id)), user text is sent with sendRequest(ChatMessage.user(...)), the system prompt includes the catalog's UI-generation instructions, and everything is disposed.

FAIL if it uses any removed/renamed class, invents a different API (e.g. a GenUiClient, manager.surfaceStream, ContentGenerator subclasses), builds UI from raw JSON by hand instead of Surface, or never connects the LLM output to the adapter.
