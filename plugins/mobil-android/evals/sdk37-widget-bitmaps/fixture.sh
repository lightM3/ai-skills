#!/usr/bin/env bash
set -e
J=app/src/main/java/com/acme/frames
mkdir -p $J
cat > CHANGELOG.md <<'M'
## 3.8.0
- Raised compileSdk and targetSdk to 37
- Updated Coil and Room
## 3.7.2
- Fixed album sort order
M
cat > app/build.gradle.kts <<'G'
plugins { id("com.android.application") }
android {
    namespace = "com.acme.frames"
    compileSdk = 37
    defaultConfig { applicationId = "com.acme.frames"; minSdk = 26; targetSdk = 37 }
}
G
cat > $J/PhotoWidgetProvider.kt <<'K'
package com.acme.frames

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.BitmapFactory
import android.widget.RemoteViews

class PhotoWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        val photos = PhotoRepository(context).latest(count = 4) // file paths of camera photos
        for (id in ids) {
            val views = RemoteViews(context.packageName, R.layout.widget_photos)
            photos.forEachIndexed { i, path ->
                val bitmap = BitmapFactory.decodeFile(path) // full-size, e.g. 4000x3000 ARGB_8888
                views.setImageViewBitmap(SLOT_IDS[i], bitmap)
            }
            manager.updateAppWidget(id, views)
        }
    }

    companion object {
        val SLOT_IDS = intArrayOf(R.id.slot0, R.id.slot1, R.id.slot2, R.id.slot3)
    }
}
K
