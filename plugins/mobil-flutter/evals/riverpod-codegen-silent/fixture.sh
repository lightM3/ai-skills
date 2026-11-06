#!/usr/bin/env bash
# A Riverpod 3.x project that uses code generation. The prompt mentions neither.
set -e
mkdir -p lib/data lib/features/auth lib/features/favourites

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

cat > lib/data/favourites_repository.dart <<'EOF'
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favourites_repository.g.dart';

class FavouritesRepository {
  Future<Set<String>> fetchIds() async => {};
  Future<void> add(String productId) async {}
  Future<void> remove(String productId) async {}
}

@Riverpod(keepAlive: true)
FavouritesRepository favouritesRepository(Ref ref) => FavouritesRepository();
EOF

cat > lib/features/auth/session.dart <<'EOF'
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session.g.dart';

@riverpod
class Session extends _$Session {
  @override
  String? build() => null;

  void signIn(String userId) => state = userId;
  void signOut() => state = null;
}
EOF
