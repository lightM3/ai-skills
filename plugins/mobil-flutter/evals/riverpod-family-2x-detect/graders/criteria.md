---
type: llm
---

The project uses flutter_riverpod 2.x with hand-written (non-codegen) providers.

PASS if the answer declares the provider with NotifierProvider.family (optionally .autoDispose), the notifier extends FamilyNotifier<int, String> (or AutoDisposeFamilyNotifier<int, String>), build takes the product id as its parameter (build(String productId) or similar) and returns 0, and decrement() never goes below 0.

FAIL if the notifier takes the id through its constructor with a parameterless build() (that is the Riverpod 3.x form and does not compile on 2.x), if it uses StateNotifier/StateProvider, or if it introduces code generation (@riverpod).
