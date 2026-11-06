---
type: regex
target: last_message
pattern: '\.listen\s*\(|StreamSubscription\s*<'
match: not_contains
weight: 2
---
