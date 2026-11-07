#!/usr/bin/env bash
set -e
J=app/src/main/java/com/acme/pay
mkdir -p $J app/src/main/res/xml
cat > settings.gradle.kts <<'G'
plugins { id("com.android.application") version "9.5.0" apply false }
rootProject.name = "AcmePay"
include(":app")
G
cat > app/build.gradle.kts <<'G'
plugins { id("com.android.application") }
android {
    namespace = "com.acme.pay"
    compileSdk = 36
    defaultConfig {
        applicationId = "com.acme.pay"
        minSdk = 28
        targetSdk = 36
        versionCode = 88
        versionName = "5.2.0"
    }
}
G
cat > app/src/main/AndroidManifest.xml <<'X'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.RECEIVE_SMS" />
    <uses-permission android:name="android.permission.READ_SMS" />
    <application android:label="AcmePay" android:networkSecurityConfig="@xml/network_security_config">
        <property
            android:name="android.window.PROPERTY_COMPAT_ALLOW_RESTRICTED_RESIZABILITY"
            android:value="true" />
        <activity android:name=".MainActivity" android:exported="true"
            android:screenOrientation="portrait">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        <activity android:name=".PinActivity" />
        <receiver android:name=".OtpSmsReceiver" android:exported="true"
            android:permission="android.permission.BROADCAST_SMS">
            <intent-filter>
                <action android:name="android.provider.Telephony.SMS_RECEIVED" />
            </intent-filter>
        </receiver>
    </application>
</manifest>
X
cat > app/src/main/res/xml/network_security_config.xml <<'X'
<network-security-config>
    <base-config cleartextTrafficPermitted="false" />
</network-security-config>
X
cat > $J/OtpSmsReceiver.kt <<'K'
package com.acme.pay

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony

/** Reads the 6-digit login code from incoming SMS ("Your AcmePay code is 123456"). */
class OtpSmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        val body = messages.joinToString("") { it.messageBody }
        Regex("""\b(\d{6})\b""").find(body)?.let { OtpBus.post(it.value) }
    }
}

object OtpBus { fun post(code: String) { /* delivers to the login screen */ } }
K
cat > $J/ReceiptPrinter.kt <<'K'
package com.acme.pay

import android.content.Context
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import java.net.Socket

/** Finds the shop's receipt printer on the Wi-Fi network and prints over raw TCP 9100. */
class ReceiptPrinter(private val context: Context) {
    private val nsd = context.getSystemService(NsdManager::class.java)

    fun discover(onFound: (NsdServiceInfo) -> Unit) {
        nsd.discoverServices("_pdl-datastream._tcp", NsdManager.PROTOCOL_DNS_SD,
            object : NsdManager.DiscoveryListener {
                override fun onServiceFound(info: NsdServiceInfo) = onFound(info)
                override fun onDiscoveryStarted(t: String) {}
                override fun onDiscoveryStopped(t: String) {}
                override fun onServiceLost(info: NsdServiceInfo) {}
                override fun onStartDiscoveryFailed(t: String, e: Int) {}
                override fun onStopDiscoveryFailed(t: String, e: Int) {}
            })
    }

    fun print(host: String, data: ByteArray) {
        Socket(host, 9100).use { it.getOutputStream().write(data) }
    }
}
K
cat > $J/PinActivity.kt <<'K'
package com.acme.pay

import android.app.Activity
import android.os.Bundle
import android.view.contentcapture.ContentCaptureManager

/** PIN entry. Must not be captured by system intelligence features. */
class PinActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        getSystemService(ContentCaptureManager::class.java)?.setContentCaptureEnabled(false)
    }
}
K
cat > $J/PaymentReturn.kt <<'K'
package com.acme.pay

import android.app.ActivityOptions
import android.app.PendingIntent
import android.content.Context

/** Bank app redirect: when the bank confirms, bring our app back to the front. */
object PaymentReturn {
    fun resume(context: Context, pending: PendingIntent) {
        val options = ActivityOptions.makeBasic().setPendingIntentBackgroundActivityStartMode(
            ActivityOptions.MODE_BACKGROUND_ACTIVITY_START_ALLOWED
        )
        context.startIntentSender(pending.intentSender, null, 0, 0, 0, options.toBundle())
    }
}
K
