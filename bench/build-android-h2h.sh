#!/usr/bin/env bash
# Head-to-head benchmark: mobil-android skills vs Google's official Android skills
# (github.com/android/skills, Apache-2.0) on identical tasks.
#
# The plugin's own evals are read-only (the agent answers with code). Some official
# skills expect the agent to act (edit files, look up versions on the web), so this
# script turns the overlapping cases into an "edit mode" variant for a fair fight:
#   - every arm may Read/Glob/Grep/Edit/Write/WebFetch/WebSearch;
#   - code checks grade the final project files (target: files);
#   - diagnosis checks (where a case has one) grade the final message.
#
# It builds two throwaway plugins with the same cases:
#   bench/out/h2h-ours/      mobil-android skills
#   bench/out/h2h-official/  official skills (pinned commit)
#
# Run (see bench/README.md):
#   T="--allow-tools Edit Write WebFetch WebSearch --scaffold --runs 2 --trust-plugin --no-publish"
#   (cd bench/out/h2h-ours && claude plugin eval . $T)                      # ours vs no skill
#   (cd bench/out/h2h-official && claude plugin eval . $T --ablation none)  # official
set -euo pipefail

UPSTREAM_REPO="https://github.com/android/skills"
UPSTREAM_COMMIT="c72942584fff970dac86ced78b367fce0c441e52"   # 2026-11-15

OFFICIAL_SKILLS=(
  build-system/agp/agp-9-upgrade             # vs android-agp
  performance/r8-analyzer                    # vs android-agp (optimization / keep rules)
  system/glance-appwidget-updates-and-memory # vs android-target-sdk (API 37 widget bitmap cap)
)
OFFICIAL_NAMES="agp-9-upgrade|r8-analyzer|glance-appwidget-updates-and-memory"
CASES=(agp-upgrade-latest agp-newdsl-classcast agp-9x-optimization-dsl sdk37-widget-bitmaps)

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUTDIR="$ROOT/bench/out"
SRC="$OUTDIR/android-skills-src"
mkdir -p "$OUTDIR"

if [ ! -d "$SRC/.git" ]; then git clone -q --filter=blob:none "$UPSTREAM_REPO" "$SRC"; fi
git -C "$SRC" fetch -q --depth 1 origin "$UPSTREAM_COMMIT" || true
git -C "$SRC" checkout -q "$UPSTREAM_COMMIT"

build() { # $1 = plugin dir name, $2 = skill-fired regex
  local out="$OUTDIR/$1"
  rm -rf "$out"; mkdir -p "$out/.claude-plugin" "$out/skills" "$out/evals"
  for c in "${CASES[@]}"; do
    cp -R "$ROOT/plugins/mobil-android/evals/$c" "$out/evals/$c"
    python3 -I "$ROOT/bench/to_edit_mode.py" "$out/evals/$c" "$2"
  done
}

build h2h-ours "android-agp|android-target-sdk"
cp -R "$ROOT/plugins/mobil-android/skills/." "$OUTDIR/h2h-ours/skills/"
cat > "$OUTDIR/h2h-ours/.claude-plugin/plugin.json" <<JSON
{ "name": "h2h-ours", "version": "0.0.0", "description": "Benchmark-only: mobil-android skills, edit-mode cases." }
JSON

build h2h-official "$OFFICIAL_NAMES"
for s in "${OFFICIAL_SKILLS[@]}"; do cp -R "$SRC/$s" "$OUTDIR/h2h-official/skills/"; done
cp "$SRC/LICENSE.txt" "$OUTDIR/h2h-official/LICENSE-android-skills.txt"
cat > "$OUTDIR/h2h-official/.claude-plugin/plugin.json" <<JSON
{ "name": "h2h-official", "version": "0.0.0", "description": "Benchmark-only: android/skills @ ${UPSTREAM_COMMIT:0:7}, edit-mode cases." }
JSON

echo "Built $OUTDIR/h2h-ours and $OUTDIR/h2h-official (${#CASES[@]} cases each)."
