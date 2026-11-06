#!/usr/bin/env bash
set -e
mkdir -p lib/features/home lib/features/onboarding
cat > pubspec.yaml <<'Y'
name: travel_app
publish_to: none
environment:
  sdk: ">=3.12.0 <4.0.0"
  flutter: ">=3.47.0"
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any
  # third-party date picker, still imports package:flutter/material.dart internally
  calendar_date_picker2: ^2.0.0
dev_dependencies:
  flutter_test:
    sdk: flutter
Y
cat > lib/main.dart <<'D'
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/home/home_page.dart';

void main() => runApp(const TravelApp());

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('tr')],
      home: const HomePage(),
    );
  }
}
D
cat > lib/features/home/home_page.dart <<'D'
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Trips')),
        body: CalendarDatePicker2(
          config: CalendarDatePicker2Config(),
          value: const [],
        ),
      );
}
D
cat > lib/features/onboarding/onboarding_page.dart <<'D'
import 'package:flutter/cupertino.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});
  @override
  Widget build(BuildContext context) => const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator()),
      );
}
D
