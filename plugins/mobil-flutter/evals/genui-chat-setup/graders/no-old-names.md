---
type: regex
target: last_message
pattern: '\b(GenUiConversation|GenUiManager|A2uiMessageProcessor|GenUiSurface|GenUiHost|CoreCatalogItems|ContentGenerator|GenUiController|GenUiTransport)\b\s*[(<.]'
match: not_contains
weight: 2
---
