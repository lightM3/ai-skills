#!/usr/bin/env bash
set -e
mkdir -p lib/features/home lib/features/settings lib/app
cat > pubspec.yaml <<'Y'
name: notes_app
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
cat > lib/app/app.dart <<'D'
import 'package:material_ui/material_ui.dart';
import '../features/home/home_page.dart';

class NotesApp extends StatelessWidget {
  const NotesApp({super.key, required this.themeMode});
  final ValueNotifier<ThemeMode> themeMode;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeMode,
      builder: (context, mode, _) => MaterialApp(
        themeMode: mode,
        theme: ThemeData(colorSchemeSeed: Colors.teal),
        darkTheme: ThemeData(colorSchemeSeed: Colors.teal, brightness: Brightness.dark),
        home: const HomePage(),
      ),
    );
  }
}
D
cat > lib/features/home/home_page.dart <<'D'
import 'package:material_ui/material_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Notes')),
        body: const Center(child: Text('No notes yet')),
      );
}
D
