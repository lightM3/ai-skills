---
type: llm
---

Grade only the diagnosis and code in the answer; it doesn't matter that the agent could not write files.

Facts: for apps targeting Android 17 (API 37), `AppWidgetManager.updateAppWidget` throws `IllegalArgumentException` when the RemoteViews' total bitmap memory exceeds the system cap (before API 37 it only logged a warning). The budget is about `6 * screenWidth * screenHeight` bytes; compute it from `WindowManager.currentWindowMetrics.bounds` (API 30+). Fixes: downsample (`inSampleSize` / decode to the widget slot size), use `Bitmap.Config.RGB_565` for opaque photos, or pass URIs (`setImageViewUri` via a FileProvider/content URI) which don't count against the IPC cap.

PASS if the answer:
- ties the crash to the targetSdk 37 change in 3.8.0 (bitmap memory limit now enforced with an exception for API 37 targets);
- states the budget (≈ 6 × screen width × height bytes, or equivalently 1.5× a full-screen ARGB_8888 bitmap) or computes it from window metrics in code;
- fixes it by downsampling to the slot size (and/or RGB_565) or switching to URI-backed images, keeping all four photos within budget.

FAIL if it blames Coil/Room, only wraps the call in try/catch, or only says "bitmaps are too big" without connecting it to the API 37 change.
