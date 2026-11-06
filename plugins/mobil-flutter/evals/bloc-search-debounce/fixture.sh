#!/usr/bin/env bash
set -e
mkdir -p lib/features/search
cat > pubspec.yaml <<'Y'
name: shop_app
publish_to: none
environment:
  sdk: ">=3.5.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.1.0
  equatable: ^2.0.5
dev_dependencies:
  flutter_test:
    sdk: flutter
Y
cat > lib/features/search/search_repository.dart <<'D'
class SearchRepository {
  Future<List<String>> search(String query) async => const [];
}
D
