#!/usr/bin/env bash
set -e
mkdir -p lib/router lib/features
cat > pubspec.yaml <<'Y'
name: shop_app
publish_to: none
environment:
  sdk: ">=3.7.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
  go_router: ^17.2.0
dev_dependencies:
  flutter_test:
    sdk: flutter
Y
cat > lib/features/session.dart <<'D'
class Session {
  Session({this.isAdmin = false});
  bool isAdmin;
}
D
cat > lib/router/router.dart <<'D'
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/session.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

GoRouter buildRouter(Session session) => GoRouter(
      navigatorKey: rootNavigatorKey,
      routes: [
        GoRoute(path: '/', builder: (c, s) => const Placeholder()),
        GoRoute(path: '/reports', builder: (c, s) => const Placeholder()),
        GoRoute(
          path: '/admin',
          builder: (c, s) => const Placeholder(),
          routes: [GoRoute(path: 'users', builder: (c, s) => const Placeholder())],
        ),
      ],
    );
D
