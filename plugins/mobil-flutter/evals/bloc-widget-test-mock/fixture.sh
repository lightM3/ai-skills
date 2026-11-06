#!/usr/bin/env bash
set -e
mkdir -p lib/features/counter test
cat > pubspec.yaml <<'Y'
name: counter_app
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
  bloc_test: ^10.0.0
  mocktail: ^1.0.4
Y
cat > lib/features/counter/counter_cubit.dart <<'D'
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
}
D
cat > lib/features/counter/counter_page.dart <<'D'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_cubit.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => CounterCubit(), child: const CounterView());
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CounterCubit, int>(
        listenWhen: (prev, curr) => curr == 10,
        listener: (context, state) => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('You reached 10!'))),
        builder: (context, count) => Center(child: Text('$count')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CounterCubit>().increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
D
