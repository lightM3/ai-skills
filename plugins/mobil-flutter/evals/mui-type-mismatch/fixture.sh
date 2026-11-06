#!/usr/bin/env bash
set -e
mkdir -p lib/theme lib/features/profile
cat > pubspec.yaml <<'Y'
name: shop_app
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
Y
cat > lib/main.dart <<'D'
import 'package:material_ui/material_ui.dart';
import 'theme/app_theme.dart';
import 'features/profile/profile_page.dart';

void main() => runApp(MaterialApp(theme: buildTheme(), home: const ProfilePage()));
D
cat > lib/theme/app_theme.dart <<'D'
import 'package:flutter/material.dart';

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4));
  return ThemeData(colorScheme: scheme, useMaterial3: true);
}
D
cat > lib/features/profile/profile_page.dart <<'D'
import 'package:material_ui/material_ui.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Profile')));
}
D
