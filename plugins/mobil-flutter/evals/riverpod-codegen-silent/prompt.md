---
description: 3.x codegen project; the prompt mentions neither the version nor codegen. Claude must discover both and write an @riverpod async class with a part directive.
tags: [flutter-riverpod, hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Add the state for the favourites screen in lib/features/favourites/: load the user's favourite product ids from the favourites repository, and let the user toggle a product in or out of favourites. Follow the project's existing conventions and reply with the full Dart file plus anything I need to run afterwards.
