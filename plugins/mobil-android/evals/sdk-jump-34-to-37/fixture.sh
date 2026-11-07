#!/usr/bin/env bash
set -e
J=app/src/main/java/com/acme/fit
mkdir -p $J app/src/main/res/values
cat > settings.gradle.kts <<'G'
plugins { id("com.android.application") version "9.5.0" apply false }
rootProject.name = "Fit"
include(":app")
G
cat > app/build.gradle.kts <<'G'
plugins { id("com.android.application") }
android {
    namespace = "com.acme.fit"
    compileSdk = 34
    defaultConfig { applicationId = "com.acme.fit"; minSdk = 26; targetSdk = 34 }
}
G
cat > app/src/main/res/values/themes.xml <<'X'
<resources>
    <style name="Theme.Fit" parent="Theme.Material3.DayNight.NoActionBar">
        <item name="android:windowOptOutEdgeToEdgeEnforcement">true</item>
        <item name="android:statusBarColor">@color/brand</item>
    </style>
</resources>
X
cat > app/src/main/AndroidManifest.xml <<'X'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC" />
    <application android:theme="@style/Theme.Fit">
        <activity android:name=".WorkoutActivity" android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        <service android:name=".SyncService" android:foregroundServiceType="dataSync" />
        <receiver android:name=".BootReceiver" android:exported="true">
            <intent-filter><action android:name="android.intent.action.BOOT_COMPLETED" /></intent-filter>
        </receiver>
    </application>
</manifest>
X
cat > $J/WorkoutActivity.kt <<'K'
package com.acme.fit

import android.app.AlertDialog
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity

class WorkoutActivity : AppCompatActivity() {
    private val history = mutableListOf<String>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_workout)
    }

    // Ask before leaving a workout in progress.
    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        AlertDialog.Builder(this).setMessage("Stop workout?")
            .setPositiveButton("Stop") { _, _ -> super.onBackPressed() }
            .setNegativeButton("Continue", null).show()
    }

    fun undoLastSet() { if (history.isNotEmpty()) history.removeFirst() }

    fun shareSummary(uri: Uri) {
        startActivity(Intent(Intent.ACTION_SEND).setType("image/png").putExtra(Intent.EXTRA_STREAM, uri))
    }
}
K
cat > $J/SyncService.kt <<'K'
package com.acme.fit

import android.app.Service
import android.content.Intent
import android.os.IBinder

/** Uploads all workouts to the server. Can take hours on slow connections. */
class SyncService : Service() {
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startForeground(1, Notifications.sync(this))
        Uploader.uploadEverything { stopSelf() }
        return START_STICKY
    }
    override fun onBind(intent: Intent?): IBinder? = null
}
K
cat > $J/BootReceiver.kt <<'K'
package com.acme.fit

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        context.startForegroundService(Intent(context, SyncService::class.java))
    }
}
K
cat > $J/BuildFlags.kt <<'K'
package com.acme.fit

/** Test hook: flips a static final debug flag via reflection in QA builds. */
object BuildFlags {
    fun enableVerboseLogging() {
        val f = Class.forName("com.acme.fit.Config").getDeclaredField("VERBOSE")
        f.isAccessible = true
        f.setBoolean(null, true)
    }
}
K
