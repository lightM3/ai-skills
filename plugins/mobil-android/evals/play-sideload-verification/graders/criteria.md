---
type: llm
---

Facts (verified Nov 2026): Android developer verification requires apps installed on certified Android devices to be registered by a verified developer. Enforcement started 30 Sep 2026 in Brazil, Indonesia, Singapore and Thailand; global rollout follows from 2027. Apps distributed only on Google Play are registered automatically; apps also distributed outside Play must be registered: the developer verifies identity (Play Console, which now also registers apps/keys outside Play, or the Android Developer Console for off-Play-only developers) and registers the package name with its signing key (proving ownership with an APK signed by that key). The `direct` APK is signed with a different key than Play App Signing, so that key must be registered too. Unregistered apps can still be installed via ADB or the "advanced flow" with extra safeguards, which is not a realistic path for ordinary users. Limited-distribution accounts (no ID, max 20 devices) are for students/hobbyists.

PASS if the answer:
- explains developer verification / app registration and that it is already enforced in Indonesia since 30 Sep 2026 (and global from 2027);
- says to verify the developer identity and register the package name `id.acme.ride` with the `direct` flavor's own signing key (Play Console, or Android Developer Console);
- mentions that unregistered apps would only install via ADB/advanced flow (not normal installs/updates).

FAIL if it says nothing changes for sideloaded APKs, or only talks about "unknown sources" settings / Play Protect.
