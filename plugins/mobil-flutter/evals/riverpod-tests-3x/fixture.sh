#!/usr/bin/env bash
# Riverpod 3.x codegen project with a notifier that needs unit tests.
set -e
mkdir -p lib/features/cart test

cat > pubspec.yaml <<'EOF'
name: shop_app
publish_to: none
environment:
  sdk: ">=3.7.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^3.3.0
  riverpod_annotation: ^3.0.3
dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  riverpod_generator: ^3.0.3
EOF

cat > lib/features/cart/cart_repository.dart <<'EOF'
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_repository.g.dart';

class CartRepository {
  Future<Map<String, int>> load() async => {};
  Future<void> save(Map<String, int> items) async {}
}

@Riverpod(keepAlive: true)
CartRepository cartRepository(Ref ref) => CartRepository();
EOF

cat > lib/features/cart/cart.dart <<'EOF'
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'cart_repository.dart';

part 'cart.g.dart';

@riverpod
class Cart extends _$Cart {
  @override
  Future<Map<String, int>> build() => ref.watch(cartRepositoryProvider).load();

  Future<void> add(String productId) async {
    final current = {...await future};
    current[productId] = (current[productId] ?? 0) + 1;
    await ref.read(cartRepositoryProvider).save(current);
    if (!ref.mounted) return;
    state = AsyncData(current);
  }
}
EOF
