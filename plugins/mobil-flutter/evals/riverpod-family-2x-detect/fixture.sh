#!/usr/bin/env bash
# A Riverpod 2.x project with hand-written providers. The prompt never mentions the version.
set -e
mkdir -p lib/features/auth lib/features/cart lib/features/products

cat > pubspec.yaml <<'EOF'
name: shop_app
publish_to: none
environment:
  sdk: ">=3.4.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
EOF

cat > lib/main.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: ShopApp()));

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(home: Placeholder());
}
EOF

cat > lib/features/auth/auth_notifier.dart <<'EOF'
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = NotifierProvider<AuthNotifier, bool>(AuthNotifier.new);

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void signIn() => state = true;
  void signOut() => state = false;
}
EOF

cat > lib/features/products/product.dart <<'EOF'
class Product {
  const Product({required this.id, required this.name, required this.price});
  final String id;
  final String name;
  final double price;
}
EOF
