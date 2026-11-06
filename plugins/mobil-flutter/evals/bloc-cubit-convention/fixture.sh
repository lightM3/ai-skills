#!/usr/bin/env bash
set -e
mkdir -p lib/features/notes lib/features/settings
cat > pubspec.yaml <<'Y'
name: notes_app
publish_to: none
environment:
  sdk: ">=3.5.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.1.0
  equatable: ^2.0.5
dev_dependencies:
  flutter_test:
    sdk: flutter
Y
cat > lib/features/notes/note.dart <<'D'
class Note {
  const Note({required this.id, required this.title, this.pinned = false});
  final String id;
  final String title;
  final bool pinned;
  Note copyWith({String? title, bool? pinned}) =>
      Note(id: id, title: title ?? this.title, pinned: pinned ?? this.pinned);
}
D
cat > lib/features/notes/notes_repository.dart <<'D'
import 'note.dart';
class NotesRepository {
  Future<List<Note>> fetchAll() async => const [];
  Future<void> setPinned(String id, bool pinned) async {}
}
D
cat > lib/features/settings/settings_cubit.dart <<'D'
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object?> get props => [];
}
final class SettingsLoading extends SettingsState { const SettingsLoading(); }
final class SettingsLoaded extends SettingsState {
  const SettingsLoaded({required this.darkMode});
  final bool darkMode;
  @override
  List<Object?> get props => [darkMode];
}
final class SettingsFailure extends SettingsState {
  const SettingsFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsLoading());

  Future<void> load() async {
    emit(const SettingsLoaded(darkMode: false));
  }

  void toggleDarkMode() {
    final s = state;
    if (s is SettingsLoaded) emit(SettingsLoaded(darkMode: !s.darkMode));
  }
}
D
cat > lib/features/settings/settings_page.dart <<'D'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit()..load(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) => switch (state) {
          SettingsLoading() => const Center(child: CircularProgressIndicator()),
          SettingsFailure(:final message) => Center(child: Text(message)),
          SettingsLoaded(:final darkMode) => SwitchListTile(
              value: darkMode,
              onChanged: (_) => context.read<SettingsCubit>().toggleDarkMode(),
              title: const Text('Dark mode'),
            ),
        },
      ),
    );
  }
}
D
