---
type: llm
---

genui 0.10.x: `CatalogItem({required String name, required Schema dataSchema, required CatalogWidgetBuilder widgetBuilder, List<ExampleBuilderCallback> exampleData, bool isImplicitlyFlexible})`, where `typedef CatalogWidgetBuilder = Widget Function(CatalogItemContext itemContext)`. The component's data is `itemContext.data` (an Object — cast to a JSON map), other context: `itemContext.buildContext`, `id`, `buildChild`, `dispatchEvent`, `dataContext`. Schemas use package:json_schema_builder: `S.object(properties: {'name': S.string(description: ...), 'price': S.number(...), ...}, required: [...])`. Catalogs are immutable: extend with `BasicCatalogItems.asCatalog().copyWith(newItems: [productCard])` (or `Catalog([...BasicCatalogItems.asCatalog().items, productCard])`).

PASS if the answer defines a `CatalogItem` named 'ProductCard' with an `S.object` dataSchema containing name, price (number), currency, optional imageUrl and optional onSale with descriptions and a `required` list for the mandatory ones; uses a single-argument widgetBuilder reading `itemContext.data` (cast to a map) to render a Card; and keeps the basic widgets via copyWith(newItems: ...) or by combining items.

Judge only the Dart code. Extra fields read from `itemContext` (e.g. `itemContext.buildContext` for Theme.of) are fine, and it doesn't matter whether the model could write the file to disk. `S.number`, `S.boolean`, `S.string`, `S.integer`, `S.list`, `S.object` all exist in json_schema_builder.

FAIL if it uses the old named-parameter builder (`widgetBuilder: ({required data, required id, ...})`), mutates the catalog (`.add`, `.items.add`), uses CoreCatalogItems or other removed names, or invents schema APIs (e.g. `Schema.object`, `JsonSchema(...)` builder classes not in json_schema_builder).
