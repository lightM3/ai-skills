---
type: regex
target: last_message
pattern: "import\\s+'package:(material_ui|cupertino_ui)/|^\\s*(material_ui|cupertino_ui):\\s"
match: not_contains
flags: m
weight: 2
---
