#!/usr/bin/env bash
set -e
mkdir -p lib/features/chat lib/features/auth
cat > pubspec.yaml <<'Y'
name: chat_app
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
cat > lib/features/chat/message.dart <<'D'
class Message {
  const Message({required this.id, required this.text, required this.sentAt});
  final String id;
  final String text;
  final DateTime sentAt;
}
D
cat > lib/features/chat/chat_repository.dart <<'D'
import 'message.dart';

class ChatRepository {
  /// Emits the full message list every time it changes.
  Stream<List<Message>> watchMessages(String roomId) => const Stream.empty();
  Future<void> send(String roomId, String text) async {}
}
D
cat > lib/features/auth/auth_bloc.dart <<'D'
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class AuthEvent {}
final class AuthLoginRequested extends AuthEvent {}
final class AuthLogoutRequested extends AuthEvent {}

final class AuthState extends Equatable {
  const AuthState({this.loggedIn = false});
  final bool loggedIn;
  @override
  List<Object?> get props => [loggedIn];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<AuthLoginRequested>((event, emit) => emit(const AuthState(loggedIn: true)));
    on<AuthLogoutRequested>((event, emit) => emit(const AuthState()));
  }
}
D
