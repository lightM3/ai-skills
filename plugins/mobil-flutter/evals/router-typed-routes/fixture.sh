#!/usr/bin/env bash
set -e
mkdir -p lib/router lib/features/home lib/features/product
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
  build_runner: ^2.4.0
  go_router_builder: ^4.0.0
Y
cat > lib/router/routes.dart <<'D'
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';

part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}
D
cat > lib/router/router.dart <<'D'
import 'package:go_router/go_router.dart';
import 'routes.dart';

final router = GoRouter(routes: $appRoutes);
D
cat > lib/features/home/home_screen.dart <<'D'
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ids = ['p1', 'p2', 'p3'];
    return Scaffold(
      body: ListView(
        children: [
          for (final id in ids)
            ListTile(
              title: Text(id),
              onTap: () {
                // TODO: open product detail
              },
            ),
        ],
      ),
    );
  }
}
D
cat > lib/features/product/product_screen.dart <<'D'
import 'package:flutter/material.dart';

enum ProductTab { details, reviews }

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.id, this.tab = ProductTab.details});
  final String id;
  final ProductTab tab;
  @override
  Widget build(BuildContext context) => Scaffold(body: Text('$id ${tab.name}'));
}
D
