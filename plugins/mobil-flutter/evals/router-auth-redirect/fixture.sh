#!/usr/bin/env bash
set -e
mkdir -p lib/router lib/features/auth
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
cat > lib/features/auth/auth_service.dart <<'D'
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  bool _loggedIn = false;
  bool get isLoggedIn => _loggedIn;
  void logIn() { _loggedIn = true; notifyListeners(); }
  void logOut() { _loggedIn = false; notifyListeners(); }
}
D
cat > lib/router/router.dart <<'D'
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_service.dart';

GoRouter buildRouter(AuthService auth) => GoRouter(
      routes: [
        GoRoute(path: '/', builder: (c, s) => const Placeholder()),
        GoRoute(path: '/orders', builder: (c, s) => const Placeholder()),
        GoRoute(path: '/orders/:orderId', builder: (c, s) => const Placeholder()),
        GoRoute(path: '/login', builder: (c, s) => const Placeholder()),
      ],
    );
D
