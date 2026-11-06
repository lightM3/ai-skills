---
type: regex
target: last_message
pattern: 'extends\s+(Auto\w*)?Family(Async)?Notifier|StateNotifier'
match: not_contains
weight: 2
---
