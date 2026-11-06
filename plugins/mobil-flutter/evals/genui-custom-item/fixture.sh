#!/usr/bin/env bash
set -e
cat > pubspec.yaml <<'Y'
name: shop_assistant
publish_to: none
environment:
  sdk: ">=3.12.0 <4.0.0"
  flutter: ">=3.47.0"
dependencies:
  flutter:
    sdk: flutter
  genui: ^0.10.4
  json_schema_builder: ^0.1.7
Y
mkdir -p lib/llm lib/features
cat > lib/llm/llm_client.dart <<'D'
/// Thin wrapper around our backend LLM endpoint.
class LlmClient {
  /// Streams the model reply as text chunks.
  /// [history] alternates user/model turns as plain text.
  Stream<String> streamText({
    required String systemPrompt,
    required List<({String role, String text})> history,
  }) async* {}
}
D
cat > lib/features/catalog.dart <<'D'
import 'package:genui/genui.dart';

/// The widget catalog the assistant may use.
final Catalog assistantCatalog = BasicCatalogItems.asCatalog();
D
