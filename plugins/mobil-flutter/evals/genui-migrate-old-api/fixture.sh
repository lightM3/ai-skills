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
cat > lib/features/assistant_page.dart <<'D'
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import '../llm/llm_client.dart';

class LlmContentGenerator extends ContentGenerator {
  LlmContentGenerator(this.client);
  final LlmClient client;
  // ... forwards requests to the LLM (written against genui 0.6)
}

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});
  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  late final A2uiMessageProcessor _processor =
      A2uiMessageProcessor(catalogs: [CoreCatalogItems.asCatalog()]);
  late final GenUiConversation _conversation = GenUiConversation(
    a2uiMessageProcessor: _processor,
    contentGenerator: LlmContentGenerator(LlmClient()),
    onSurfaceAdded: (update) => setState(() => _surfaceIds.add(update.surfaceId)),
    onSurfaceDeleted: (update) => setState(() => _surfaceIds.remove(update.surfaceId)),
  );
  final _surfaceIds = <String>[];
  final _input = TextEditingController();

  @override
  void dispose() {
    _conversation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(children: [
          Expanded(
            child: ListView(children: [
              for (final id in _surfaceIds)
                GenUiSurface(host: _processor, surfaceId: id),
            ]),
          ),
          TextField(
            controller: _input,
            onSubmitted: (t) => _conversation.sendRequest(UserMessage.text(t)),
          ),
        ]),
      );
}
D
