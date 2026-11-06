#!/usr/bin/env bash
set -e
mkdir -p lib
cat > pubspec.yaml <<'Y'
name: app
publish_to: none
environment:
  sdk: ">=3.12.0 <4.0.0"
  flutter: ">=3.47.0"
dependencies:
  flutter:
    sdk: flutter
Y
echo 'void main() {}' > lib/main.dart
