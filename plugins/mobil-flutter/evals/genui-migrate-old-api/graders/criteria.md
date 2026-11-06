---
type: llm
---

genui renames: 0.6 GenUiManager→A2uiMessageProcessor; 0.7 GenUiConversation→Conversation, GenUiController→SurfaceController, GenUiSurface→Surface, GenUiHost→SurfaceHost, GenUiTransport→Transport; 0.8 CoreCatalog→BasicCatalog (items: BasicCatalogItems); 0.10 protocol moved to a2ui_core. Current setup: `SurfaceController(catalogs: [BasicCatalogItems.asCatalog()])`, `A2uiTransportAdapter(onSend: (message) async { ... adapter.addChunk(chunk) ... })` replaces the ContentGenerator subclass, `Conversation(controller:, transport:)`, surface add/remove via `conversation.events` (`ConversationSurfaceAdded` / `ConversationSurfaceRemoved`), `Surface(surfaceContext: controller.contextFor(id))`, `sendRequest(ChatMessage.user(text))`.

PASS if the port uses those current classes, replaces LlmContentGenerator with an A2uiTransportAdapter whose onSend streams LlmClient output into addChunk, listens to conversation.events instead of the removed onSurfaceAdded/onSurfaceDeleted callbacks (and cancels the subscription in dispose), renders Surface(surfaceContext: ...), sends ChatMessage.user(...), and disposes conversation, adapter and controller.

Judge the Dart code: mentioning the old names in the explanation (e.g. "`UserMessage.text` is now `ChatMessage.user`") is fine, and it doesn't matter whether the model could write the file to disk.

FAIL if any removed class/parameter remains in the code (ContentGenerator, A2uiMessageProcessor, GenUiConversation, GenUiSurface, CoreCatalogItems, UserMessage.text, onSurfaceDeleted), or it invents an API.
