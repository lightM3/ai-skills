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
cat > lib/features/screens.dart <<'D'
import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget { const FeedScreen({super.key}); @override Widget build(BuildContext c) => const Placeholder(); }
class PostScreen extends StatelessWidget { const PostScreen({super.key, required this.id}); final String id; @override Widget build(BuildContext c) => const Placeholder(); }
class SearchScreen extends StatelessWidget { const SearchScreen({super.key}); @override Widget build(BuildContext c) => const Placeholder(); }
class ProfileScreen extends StatelessWidget { const ProfileScreen({super.key}); @override Widget build(BuildContext c) => const Placeholder(); }
class SettingsScreen extends StatelessWidget { const SettingsScreen({super.key}); @override Widget build(BuildContext c) => const Placeholder(); }
D
cat > lib/router/router.dart <<'D'
import 'package:go_router/go_router.dart';
import '../features/screens.dart';

final router = GoRouter(
  initialLocation: '/feed',
  routes: [
    GoRoute(path: '/feed', builder: (c, s) => const FeedScreen()),
    GoRoute(path: '/feed/post/:id', builder: (c, s) => PostScreen(id: s.pathParameters['id']!)),
    GoRoute(path: '/search', builder: (c, s) => const SearchScreen()),
    GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
    GoRoute(path: '/profile/settings', builder: (c, s) => const SettingsScreen()),
  ],
);
D
