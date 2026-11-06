---
description: 'genui 0.10 custom catalog item. Expect CatalogItem(name:, dataSchema: S.object(...), widgetBuilder: (itemContext) {...itemContext.data...}) added with catalog.copyWith(newItems: [...]) — not the old named-parameter widgetBuilder or catalog mutation.'
tags: [flutter-genui, genui-hard]
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Let the assistant show products with our own widget: add a "ProductCard" component to the catalog in lib/features/catalog.dart. The AI should provide the product name, price (number), currency code, an optional image URL and an optional "on sale" flag; render it as a Material card. Keep all the basic widgets available too. Reply with the full file.
