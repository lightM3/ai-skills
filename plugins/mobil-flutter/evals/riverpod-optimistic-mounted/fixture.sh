#!/usr/bin/env bash
# Riverpod 3.x, hand-written providers, an existing AsyncNotifier to extend.
set -e
mkdir -p lib/features/todos

cat > pubspec.yaml <<'EOF'
name: todo_app
publish_to: none
environment:
  sdk: ">=3.7.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^3.3.0
dev_dependencies:
  flutter_test:
    sdk: flutter
EOF

cat > lib/features/todos/todo.dart <<'EOF'
class Todo {
  const Todo({required this.id, required this.title});
  final String id;
  final String title;
}
EOF

cat > lib/features/todos/todo_repository.dart <<'EOF'
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo.dart';

class TodoRepository {
  Future<List<Todo>> fetchAll() async => const [];
  Future<void> delete(String id) async {}
}

final todoRepositoryProvider = Provider<TodoRepository>((ref) => TodoRepository());
EOF

cat > lib/features/todos/todos_notifier.dart <<'EOF'
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo.dart';
import 'todo_repository.dart';

final todosProvider =
    AsyncNotifierProvider.autoDispose<TodosNotifier, List<Todo>>(TodosNotifier.new);

class TodosNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() => ref.watch(todoRepositoryProvider).fetchAll();

  // TODO: delete
}
EOF
