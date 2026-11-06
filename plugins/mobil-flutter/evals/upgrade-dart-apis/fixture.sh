#!/usr/bin/env bash
set -e
mkdir -p lib/ui lib/features/tasks
cat > pubspec.yaml <<'Y'
name: todo_app
publish_to: none
environment:
  sdk: ">=3.12.0 <4.0.0"
  flutter: ">=3.47.0"
dependencies:
  flutter:
    sdk: flutter
Y
cat > .metadata <<'Y'
# This file tracks properties of this Flutter project.
version:
  revision: "a4c2b1e7"
  channel: "stable"
project_type: app
Y
cat > lib/ui/app_icons.dart <<'D'
import 'package:flutter/widgets.dart';

enum AppIcons implements IconData {
  add(0xe047),
  done(0xe876);

  const AppIcons(this.codePoint)
      : fontFamily = 'MaterialIcons',
        fontPackage = null,
        matchTextDirection = false;

  @override
  final int codePoint;
  @override
  final String? fontFamily;
  @override
  final String? fontPackage;
  @override
  final bool matchTextDirection;
  @override
  List<String>? get fontFamilyFallback => null;
}
D
cat > lib/features/tasks/task.dart <<'D'
import 'package:flutter/foundation.dart';

enum Priority { low, medium, high }

class Task {
  Task(this.title, this.priority);
  final String title;
  final Priority priority;

  String get priorityLabel => describeEnum(priority).toUpperCase();
}
D
cat > lib/features/tasks/task_list.dart <<'D'
import 'package:flutter/material.dart';
import '../../ui/app_icons.dart';
import 'task.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key, required this.tasks});
  final List<Task> tasks;
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late final List<Task> _tasks = [...widget.tasks];

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      cacheExtent: 800,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) newIndex -= 1;
          final task = _tasks.removeAt(oldIndex);
          _tasks.insert(newIndex, task);
        });
      },
      children: [
        for (final t in _tasks)
          ListTile(
            key: ValueKey(t),
            leading: Icon(AppIcons.done),
            title: Text(t.title),
            trailing: Text(t.priorityLabel),
          ),
      ],
    );
  }
}
D
