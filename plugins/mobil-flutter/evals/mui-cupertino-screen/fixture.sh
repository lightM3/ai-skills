#!/usr/bin/env bash
set -e
mkdir -p lib/features/home lib/features/login
cat > pubspec.yaml <<'Y'
name: bank_app
publish_to: none
environment:
  sdk: ">=3.12.0 <4.0.0"
  flutter: ">=3.47.0"
dependencies:
  flutter:
    sdk: flutter
  material_ui: ^1.10.0
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
Y
cat > lib/features/home/home_page.dart <<'D'
import 'package:material_ui/material_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Home')));
}
D
