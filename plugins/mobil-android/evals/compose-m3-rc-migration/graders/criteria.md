---
type: llm
---

Grade only the Kotlin code in the answer; it doesn't matter that the agent could not write files.

Facts (Material3 1.5.0 pre-releases, rc01 on 4 Nov 2026): stateless `Slider`/`RangeSlider` overloads (value + onValueChange) are deprecated in favour of state-based ones — `Slider(state = SliderState(value = ..., valueRange = ..., steps = ...))`, `RangeSlider(state = RangeSliderState(startValue = ..., endValue = ..., valueRange = ...))`; `RangeSliderState.activeRangeStart/activeRangeEnd` were renamed `startValue/endValue`. `rememberModalBottomSheetState` / `rememberStandardBottomSheetState` are deprecated in favour of `rememberBottomSheetState`. `TonalToggleButton` was renamed `FilledTonalToggleButton`. The experimental `LocalMotionScheme` was removed — use `MaterialTheme.motionScheme`.

PASS if the updated file:
- replaces `TonalToggleButton` with `FilledTonalToggleButton`;
- replaces `LocalMotionScheme.current` with `MaterialTheme.motionScheme`;
- moves Slider and RangeSlider to `SliderState` / `RangeSliderState` (RangeSlider using `startValue`/`endValue`), reading the values back from the states when applying the filters;
- uses `rememberBottomSheetState` instead of `rememberModalBottomSheetState` (or clearly says the old one is only deprecated, not removed, if it keeps it).

FAIL if it downgrades material3 instead of migrating, or keeps `TonalToggleButton` / `LocalMotionScheme`.
