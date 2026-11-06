---
type: llm
---

PASS if the provider is declared with NotifierProvider.family (optionally .autoDispose) and the notifier class extends Notifier<int>, receives the product id through its constructor (e.g. a final field set by the constructor), and its build() method takes no parameters and returns 0. decrement() must not go below 0.

FAIL if build() takes the id as a parameter, the class extends FamilyNotifier, or StateNotifier/StateProvider is used.
