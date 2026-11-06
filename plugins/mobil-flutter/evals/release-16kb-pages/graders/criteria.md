---
type: llm
---

Facts: Google Play requires apps targeting Android 15+ to support 16 KB memory page sizes on 64-bit devices; starting **February 1, 2027** app updates that don't support it can't be released. Pure Dart/Kotlin/Java code is fine; native `.so` libraries must be 16 KB aligned. AGP 8.5.1+ (uncompressed shared libs, zipaligned) and NDK r28+ (16 KB aligned by default) fix the project's own builds; prebuilt `.so` files from dependencies must be rebuilt by their authors. Verify with `zipalign -c -P 16 -v 4 app.apk`, Android Studio's APK Analyzer (Alignment column), `check_elf_alignment.sh`, or `llvm-objdump -p lib.so | grep LOAD` (expect `align 2**14`). The Flutter engine itself supports 16 KB on recent versions.

PASS if the answer:
- states the deadline for updates as February 1, 2027 (and that it applies because the app targets Android 15+);
- points to the prebuilt native libraries from legacy_barcode_scanner as the likely cause and says to upgrade, ask the author, or replace that plugin;
- upgrades AGP from 8.3.2 to at least 8.5.1 and the NDK (26.x) to r28 or newer;
- gives at least one concrete verification method (zipalign -P 16, APK Analyzer alignment, check_elf_alignment.sh, or llvm-objdump).

FAIL if it gives a different/invented deadline, says Flutter apps are unaffected without checking native libs, suggests lowering targetSdk below 35 to avoid it, or only suggests the linker flags without addressing the third-party prebuilt libraries.
