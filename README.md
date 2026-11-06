# ai-skills

Focused, eval-tested skills for Claude, organized as a plugin marketplace:
**domain → platform/technology plugin → one skill per library or tool.**

Every skill ships with an eval suite that runs the same tasks **with and without** the skill,
so each one has a measured effect (Δ) instead of a claimed one.

## Plugins

| Plugin | Skills | Status |
|---|---|---|
| `mobil-flutter` | `flutter-riverpod`, `flutter-bloc`, `flutter-material-ui`, `flutter-upgrade` | ✅ evaluated |
| | `go_router` | evals only — no skill needed (see below) |
| `mobil-android` | — | planned |
| `mobil-ios` | — | planned |
| `backend-go` | — | planned |

## Results

`flutter-riverpod`, 3 runs per arm, Claude Code default model (2026-11-05):

| Case | With skill | Without | Δ |
|---|---|---|---|
| `riverpod-optimistic-mounted` — `ref.mounted` after `await` in 3.x | 1.00 | 0.33 | **+0.67** |
| `riverpod-tests-3x` — `ProviderContainer.test`, repo overrides | 1.00 | 0.33 | **+0.67** |
| `riverpod-codegen-silent` — discover codegen, build_runner step | 1.00 | 0.80 | **+0.20** |
| `riverpod-family-2x-detect` — 2.x family, no 3.x APIs | 1.00 | 0.83 | **+0.17** |
| `ignores-bloc-project` — must not fire in a Bloc app | 1.00 | 1.00 | 0.00 ✓ |

The skill fired in 12/12 Riverpod runs and 0/3 Bloc runs.

`flutter-bloc` (2026-11-06). Bloc's API has been stable since 8.0, so the strongest model
already gets most of it right; the skill matters most for smaller models.

| Case | Default model Δ | Haiku: with / without | Haiku Δ |
|---|---|---|---|
| `bloc-stream-subscription` — `emit.forEach` + `restartable()`, no `.listen` + `emit` | +0.13 | 0.93 / 0.53 | **+0.40** |
| `bloc-cubit-convention` — follow Cubit + sealed states, immutable list updates | +0.17 | 1.00 / 0.89 | +0.11 |
| `bloc-search-debounce` — debounce + restartable transformer, no `Timer` | 0.00 | 0.93 / 0.80 | +0.13 |
| `bloc-widget-test-mock` — `MockCubit`, `BlocProvider.value`, `whenListen`, `verify` | 0.00 | 0.78 / 0.67 | +0.11 |
| `ignores-riverpod-project` — must not fire in a Riverpod app | 0.00 ✓ | — | — |

Default model: 2 runs per arm (3 for the stream case); Haiku: 3 runs per arm. The skill fired in
8/8 default-model Bloc runs, 11/12 Haiku Bloc runs, and 0/2 Riverpod runs.

`flutter-material-ui` (2026-11-06). Flutter 3.47 (Aug 2026) moved Material and Cupertino out of
the SDK into the `material_ui` / `cupertino_ui` packages — after the models' training data.
Without the skill, the default model correctly refuses to guess package names, so it can't help;
Haiku guesses wrong.

| Case | Default: with / without | Δ | Haiku: with / without | Δ |
|---|---|---|---|---|
| `mui-migrate-app` — `dart fix --code=migrate_design_widgets`, delegates, compatibility bridge | 1.00 / 0.00 | **+1.00** | 0.93 / 0.00 | **+0.93** |
| `mui-type-mismatch` — diagnose `ThemeData` from two libraries | 1.00 / 0.17 | **+0.83** | 1.00 / 0.00 | **+1.00** |
| `mui-cupertino-screen` — `package:cupertino_ui` + direct dependency | 1.00 / 0.00 | **+1.00** | 1.00 / 0.00 | **+1.00** |
| `mui-new-screen` — new screen uses `package:material_ui` | 1.00 / 0.00 | **+1.00** | 1.00 / 1.00 | 0.00 |
| `mui-ignores-legacy-project` — no migration in a Flutter 3.24 app | 1.00 / 1.00 | 0.00 ✓ | — | — |

3 runs per arm. One default-model baseline run of `mui-type-mismatch` hit a usage limit and scored 0.
In `mui-new-screen`, Haiku copies the import from the existing files, while the default model writes
`package:flutter/material.dart` without the skill. The skill's trigger is weakest on this case
(fired 1/3 default, 0/3 Haiku), yet every with-skill run passed.
Earlier runs of the last three cases were discarded: their "must not contain" regexes also matched
the model's explanations, not just its imports. They now match `import` lines only.

`flutter-upgrade` (2026-11-06). One skill for every Flutter upgrade: `SKILL.md` holds the
workflow (find from/to versions, read each release note in between, `dart fix`, platform files,
analyze), and `references/<version>.md` holds one file per release (3.38, 3.44, 3.47 so far).
Each new Flutter release adds a file instead of a new skill.

| Case | Default: with / without | Δ | Haiku: with / without | Δ |
|---|---|---|---|---|
| `upgrade-dart-apis` — `describeEnum`, final `IconData`, `onReorderItem` (drop `newIndex -= 1`), `ScrollCacheExtent` | 1.00 / 1.00 | 0.00 | 1.00 / 0.40 | **+0.60** |
| `upgrade-android-kotlin` — AGP 9 built-in Kotlin, `compilerOptions`, gradle.properties flags, plugin check | 0.83 / 0.67 | +0.17 | 1.00 / 0.67 | **+0.33** |
| `upgrade-ios-uiscene` — Xcode 27 + custom AppDelegate → `didInitializeImplicitFlutterEngine` | 1.00 / 1.00 | 0.00 | 1.00 / 0.88 | +0.12 |
| `upgrade-ignores-feature-work` — must not fire on ordinary work | 1.00 / 1.00 | 0.00 ✓ | — | — |

2 runs per arm. 3.38 (UIScene) and 3.44 (May 2026) mostly fall inside the default model's
training data, so its gains are small; the 3.47 notes and smaller models benefit most. The skill
fired in every upgrade run and in none of the feature-work runs.

Note on baselines: `--ablation none` is **not** a clean no-skill baseline — the plugin's other
skills are still listed, and their descriptions leak facts (the model learned `material_ui` exists
from a skill description). Use the default with/without ablation for Δ.

### go_router: no skill needed

Four hard cases (typed routes with the go_router_builder 4 mixin, auth redirect with `state.uri`,
`StatefulShellRoute.indexedStack`, the 16.3 `onEnter` + `Block.then` API) — the default model
passed all of them **without** a skill (2/2 runs each). Haiku only missed `onEnter`. The cases stay
in `evals/router-*` as a baseline to re-run when go_router changes.

**Lessons:**
- Skills pay off most for changes **after the model's training data** (Flutter 3.47's
  `material_ui`), for version splits (Riverpod 2.x → 3.x), and for smaller models on stable
  libraries (Bloc).
- A fast-moving API is not enough on its own: go_router changed 8 major versions in two years,
  but all before the cutoff, so the model already knows it. Measure before writing the skill.

## Install

In Claude Code:

```bash
claude plugin marketplace add lightM3/ai-skills
claude plugin install mobil-flutter@lightm3-skills
```

Only want one skill? Every skill folder is self-contained — copy
`plugins/<plugin>/skills/<skill>/` into your project's `.claude/skills/`,
or zip it and upload it as a skill on claude.ai.

## Layout

```
ai-skills/
├── .claude-plugin/marketplace.json      # lists every plugin
└── plugins/
    └── mobil-flutter/                   # <domain>-<platform>
        ├── .claude-plugin/plugin.json
        ├── skills/
        │   ├── flutter-riverpod/        # <platform>-<library>
        │   │   └── SKILL.md
        │   ├── flutter-bloc/
        │   ├── flutter-material-ui/
        │   └── flutter-upgrade/
        │       ├── SKILL.md             # upgrade workflow
        │       └── references/3.47.md   # one file per Flutter release
        └── evals/                       # one folder per test case
            ├── riverpod-*/  bloc-*/       # positive cases
            ├── ignores-bloc-project/    # negative: Riverpod skill must NOT fire
            └── ignores-riverpod-project/# negative: Bloc skill must NOT fire
```

### Conventions

- **Plugin name:** `<domain>-<platform>` — `mobil-flutter`, `backend-go`.
- **Skill name:** `<platform>-<library>` — `flutter-riverpod`, `flutter-bloc`.
  The prefix keeps names unambiguous when a skill is copied out on its own.
- **One skill = one library.** Mutually exclusive tools (Riverpod vs Bloc) are separate skills,
  and each skill's `description` says when *not* to use it.
- **Every skill needs evals:** at least two positive cases and one negative case.
- A skill only earns its place if it beats the no-skill baseline. Δ ≈ 0 means Claude already
  does this well — cut or rethink the skill.

## Running evals

Requires Claude Code v2.1.269+. From a plugin folder:

```bash
cd plugins/mobil-flutter
claude plugin eval . --scaffold                        # all cases, with vs. without plugin
claude plugin eval . --scaffold --tag hard --runs 1    # quick check of the hard cases
claude plugin eval . --scaffold --tag hard --model haiku   # does the skill help a smaller model?
claude plugin eval . --scaffold --tag bloc-hard --model haiku
```

- `--scaffold` is needed for cases with a `case.yaml` + `fixture.sh`: the script builds a small
  fake project (pubspec, lib/) so Claude has to *discover* the Riverpod version and style.
  On Windows it runs through Git Bash.
- Cases tagged `hard` (Riverpod) and `bloc-hard` give no version or library hints in the prompt; the older `smoke` cases do, and
  serve as regression checks (Claude already passes them without the skill).
- The summary shows `WITH`, `W/OUT` and `Δ` per case; results go to `evals/results/` (git-ignored).

## Adding a new plugin

1. `mkdir -p plugins/<domain>-<platform>/{.claude-plugin,skills,evals}`
2. Add `plugin.json` (its `name` must equal the marketplace entry name).
3. Add the entry to `.claude-plugin/marketplace.json`.
4. `claude plugin validate .` from the repo root.

## License

MIT
