---
description: Adding Retrofit + kotlinx.serialization to an already-current AGP 9.5 project is not an AGP upgrade; the AGP skill must not fire.
tags: [android-agp, negative]
max_turns: 8
allowed_tools: [Read, Glob, Grep, Skill]
---

Add Retrofit with the kotlinx.serialization converter to the app module so we can call our REST API, and write a small `ShopApi` interface with a `GET /products` endpoint returning a list of `Product(id: String, name: String)`. Show the changed build files and the new Kotlin file.
