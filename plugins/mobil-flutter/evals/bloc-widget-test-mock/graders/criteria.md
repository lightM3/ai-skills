---
type: llm
---

PASS if all of the following hold:
- Uses a mock cubit declared as `class MockCounterCubit extends MockCubit<int> implements CounterCubit {}` (from bloc_test), not the real CounterCubit.
- Injects it with `BlocProvider<CounterCubit>.value(value: mock, child: CounterView())` inside a MaterialApp.
- Stubs the displayed count with `when(() => cubit.state).thenReturn(...)`.
- Drives the snackbar test with `whenListen(cubit, Stream.fromIterable([...]), initialState: ...)` and pumps before asserting the SnackBar text.
- Verifies the tap with `verify(() => cubit.increment()).called(1)` rather than expecting the text to change.

FAIL if it uses the real CounterCubit for the view tests, uses BlocProvider(create:) with the mock, expects the count text to change after tapping a mock, or triggers the snackbar by tapping ten times.
