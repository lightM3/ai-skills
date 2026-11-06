#!/usr/bin/env bash
set -e
mkdir -p ios/Runner lib
cat > pubspec.yaml <<'Y'
name: battery_app
publish_to: none
environment:
  sdk: ">=3.12.0 <4.0.0"
  flutter: ">=3.47.0"
dependencies:
  flutter:
    sdk: flutter
Y
cat > ios/Runner/AppDelegate.swift <<'S'
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(
      name: "samples.flutter.dev/battery",
      binaryMessenger: controller.binaryMessenger)
    batteryChannel.setMethodCallHandler { call, result in
      guard call.method == "getBatteryLevel" else {
        result(FlutterMethodNotImplemented)
        return
      }
      let device = UIDevice.current
      device.isBatteryMonitoringEnabled = true
      result(Int(device.batteryLevel * 100))
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
S
cat > ios/Runner/Info.plist <<'P'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleName</key>
	<string>battery_app</string>
	<key>UILaunchStoryboardName</key>
	<string>LaunchScreen</string>
	<key>UIMainStoryboardFile</key>
	<string>Main</string>
</dict>
</plist>
P
echo 'void main() {}' > lib/main.dart
