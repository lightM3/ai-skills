---
type: regex
target: last_message
pattern: 'state\.(location|subloc|queryParameters|queryParams|params)\b'
match: not_contains
weight: 2
---
