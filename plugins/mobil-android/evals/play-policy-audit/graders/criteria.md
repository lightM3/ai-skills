---
type: llm
---

Facts (Google Play policy announcement of 29 Oct 2026, Play quality requirements, verified Nov 2026):
1. Location: request the minimum scope; for API 37+ use the Android location button for one-time/infrequent needs; apps using `ACCESS_FINE_LOCATION` must complete a Play Console declaration explaining why coarse location or the location button isn't enough — mandatory from **27 Jan 2027**. A ~5 km store list fits coarse location.
2. `READ_CALL_LOG` for phone-call (missed-call) account verification is no longer allowed; it must switch to another method (e.g. SMS User Consent / SMS Retriever) by **27 Jan 2027**.
3. Local Network Permission: only for core functionality when device pickers aren't enough; apps targeting API 37+ must submit a Play Console declaration (≥ 30 days from 29 Oct 2026). An optional TV-cast feature is a candidate for a system device picker or removal.
4. From **Feb 2027**, Play quality thresholds: apps with more than 10 MB of DEX must reach ≥ 25% each of optimization, shrinking and obfuscation (R8) — R8 is off here with ~38 MB DEX; plus 90th-percentile memory (anon RSS + swap) and bitmap memory thresholds. Missing them can reduce visibility and publishing capabilities.
5. From **Apr 2027**, apps with sign-in must restore the user's sign-in on a new device without taps (Restore Credentials API).
6. Every developer account must declare trader status (EEA/UK) by **1 Feb 2027**, or updates can be blocked; from 1 Mar 2027 Play becomes the marketplace model in the EEA/UK.

PASS if the answer correctly covers at least 4 of the 6 items with the right action and date.

FAIL if it invents different deadlines for these items or misses most of them.
