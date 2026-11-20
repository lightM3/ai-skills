# Benchmarks

## mobil-android vs Google's official Android skills

`build-android-h2h.sh` puts our `mobil-android` skills and Google's official skills
([android/skills](https://github.com/android/skills), Apache-2.0, pinned commit `c729425`, 2026-11-15)
on **identical tasks**: the eval cases where both sides target the same job.

| Case | Official skills loaded |
|---|---|
| `agp-upgrade-latest`, `agp-newdsl-classcast`, `agp-9x-optimization-dsl` | `agp-9-upgrade`, `r8-analyzer` |
| `sdk37-widget-bitmaps` | `glance-appwidget-updates-and-memory` |

Left out on purpose: `play-policy-audit` — the official `play-policy-insights` is a script-driven
scanner (Python + Play Store scraping), which this sandbox can't run, so the comparison would be unfair.

### Edit mode

Some official skills expect the agent to act (write files, look up versions online). So the benchmark
uses an "edit mode" variant of each case (`to_edit_mode.py`): every arm may Read/Glob/Grep/Write and
WebFetch/WebSearch, must make the change in the project, and must finish by pasting the final contents
of the files it changed. The original graders score that final message, unchanged.

Sandbox limits that apply to **every** arm: no shell, `Edit` is denied by the eval runner's don't-ask
mode (agents use `Write`), and outbound web requests were refused by the network proxy.

### Run

```bash
bench/build-android-h2h.sh
T="--allow-tools Write WebFetch WebSearch --scaffold --runs 2 --trust-plugin --no-publish"
(cd bench/out/h2h-ours && claude plugin eval . $T)                       # ours + no-skill arms
(cd bench/out/h2h-official && claude plugin eval . $T --ablation none)   # official arm
# add --model haiku for the Haiku numbers
```

Results are in the top-level README.
