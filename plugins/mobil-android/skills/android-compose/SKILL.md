---
name: android-compose
description: Upgrading Jetpack Compose (the Compose BOM, compose-ui/foundation, material3) to a newer or the latest release, fixing compile errors or deprecations after a Compose bump, or asking which Compose/Material3 version is current or what changed in Compose 1.11–1.13 / Material3 1.4–1.5 (FlexBox, Grid, onFirstVisible, TextObfuscationMode, meshGradient, Slider/BottomSheet state APIs). Holds the current version numbers and their build requirements. Not for writing ordinary Compose screens with stable APIs.
---

# Jetpack Compose upgrades

Current versions are newer than the model's training data. **Use these, not remembered ones**
(verified 2026-11-07 on developer.android.com/jetpack/androidx/releases/compose and the BOM mapping
page; re-check after 2027-01-31 — a new BOM ships roughly monthly):

| | Stable | Next |
|---|---|---|
| Compose BOM | **2026.09.00** | — |
| ui / foundation / runtime / animation | **1.12.1** (1.12.0: 12 Aug 2026) | 1.13.0-rc01 |
| material3 | **1.4.0** (Sep 2025) | 1.5.0-rc01 (4 Nov 2026) |
| compose.compiler (old artifact) | unused — Kotlin 2.x uses the `org.jetbrains.kotlin.plugin.compose` Gradle plugin | |

## Build requirements

- **Compose 1.12 (BOM 2026.09.00) compiles against API 37 and needs AGP ≥ 9.2.0.**
  So upgrading the BOM means `compileSdk = 37` (targetSdk may stay) and AGP ≥ 9.2 (latest stable 9.5.0 with
  Gradle 9.6.0 — see the android-agp skill if present).
- 1.13 pre-releases: compileSdk 37.1 and Kotlin 2.2 — not needed for 1.12.
- Use the BOM, not per-artifact versions: `platform("androidx.compose:compose-bom:2026.09.00")`
  or catalog `composeBom = "2026.09.00"`.

## Breaking changes & deprecations to fix when upgrading

### Foundation 1.11 (22 Apr 2026)
- **`Modifier.onFirstVisible()` deprecated** (it can fire again each time the item re-enters the viewport).
  Replace with `Modifier.onVisibilityChanged { visible -> ... }` and track "already logged" yourself
  (e.g. `var logged by rememberSaveable { mutableStateOf(false) }`, or dedupe by id in the ViewModel /
  analytics layer — preferable inside lazy lists, where item state is disposed when scrolled away).
- Trackpad `PointerEventType.Pan`/`Scale` split into `PanStart/PanMove/PanEnd`, `ScaleStart/ScaleChange/ScaleEnd`.
- New: **FlexBox** (`FlexBox`, `FlexBoxConfig`, `Modifier.flex`) — superset of Row/Column/FlowRow with grow/shrink;
  items that can't shrink overflow (use `Modifier.clipToBounds()`). **Grid** (non-lazy 2D, `Modifier.gridItem()`,
  `GridTrackSize.Fixed/Percentage/Flex/MinMax`) is `@ExperimentalGridApi`. `Modifier.scrollIndicator`,
  `Modifier.visible`, experimental Style API.

### UI / Foundation 1.12 (12 Aug 2026)
- **`TextObfuscationMode.Default` renamed to `TextObfuscationMode.System`**; `BasicSecureTextField` defaults to
  `System` (the platform's default behavior — exact semantics not verified here; Android 17 itself hides password
  characters typed on physical keyboards).
  `RevealLastTyped` now always reveals the last typed character.
- `Modifier.meshGradient` removed → `Modifier.paint(MeshGradientPainter(...))`.
- Style API helpers in `StyleScope` became extension functions → `import androidx.compose.foundation.styles.*`.
- `getSpanStyles` / `getParagraphStyles` take a `TextRange`.
- Removed feature flags: `isNonSuspendingPointerInputInCombinedClickableEnabled` and other
  `ComposeFoundationFlags` fix flags from 1.11 — delete references.
- Interaction sounds (click/navigation) are on by default; opt a subtree out with
  `SoundEffectOnInteraction(enabled = false) { ... }`.
- New: Grid named areas, more `KeyboardType`s (date, time, datetime, signed decimal), downloadable variable
  Google Fonts, wide-color-gamut colors preserved on API 29+, `credentialRequest` semantics for Credential Manager
  autofill (API 34+), `onRootWithViewInteraction` for Espresso interop in tests.

### Material3 1.4.0 (stable) — relevant if coming from 1.3
- No longer depends on `material-icons-core` → add it explicitly if you use `Icons.*`
  (`material-icons-extended` is no longer updated; Google recommends Material Symbols vector drawables).
- `TabRow`/`ScrollableTabRow` deprecated → `PrimaryTabRow`/`SecondaryTabRow` (and scrollable variants).
- `NavigationBarItem`/`NavigationRailItem` selected label color changed to `secondary`.
- New: `SecureTextField`, `OutlinedSecureTextField`, `TimePickerDialog`, new `SearchBar` +
  `ExpandedFullScreenSearchBar`/`ExpandedDockedSearchBar` + `SearchBarState`, `Text(autoSize = ...)`.

### Material3 1.5.0 — **release candidate, not in a stable BOM yet**
Only apply if the user opts into 1.5.0-rc01. Source-breaking changes:
`Slider`/`RangeSlider` stateless overloads deprecated → `Slider(state = SliderState(...))`, `onValueChange` now
required; `RangeSliderState.activeRangeStart/End` → `startValue/endValue`;
`rememberModalBottomSheetState`/`rememberStandardBottomSheetState` → `rememberBottomSheetState`;
`ExposedDropdownMenu` is an extension on `ExposedDropdownMenuBoxScope` (new import);
`SplitButtonLayout` → `SplitButton`; `TonalToggleButton` → `FilledTonalToggleButton`;
`LocalMotionScheme` removed → `MaterialTheme.motionScheme`; non-expressive list items deprecated;
Secure text fields default to `TextObfuscationMode.System`. Many Expressive APIs (SplitButton, ButtonGroup,
FloatingToolbar, flexible top app bars, slot SearchBar) lose `@ExperimentalMaterial3ExpressiveApi`.

## Workflow

1. Read the catalog/build files: current BOM, AGP, compileSdk, Kotlin compose plugin.
2. Bump the BOM; raise compileSdk/AGP if the target BOM needs it (table above).
3. Grep the code for every API in the lists above and fix each hit; show changed files.
4. Say which items are not verified (anything not listed here) instead of guessing.
