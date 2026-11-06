#!/usr/bin/env bash
set -e
mkdir -p ios/Runner lib .github/workflows
cat > pubspec.yaml <<'Y'
name: habit_app
publish_to: none
version: 1.4.0+22
environment:
  sdk: ">=3.12.0 <4.0.0"
  flutter: ">=3.47.0"
dependencies:
  flutter:
    sdk: flutter
Y
cat > .github/workflows/ios.yml <<'W'
name: ios-release
on: { push: { tags: ['v*'] } }
jobs:
  build:
    runs-on: macos-14
    steps:
      - uses: actions/checkout@v4
      - uses: maxim-lobanov/setup-xcode@v1
        with: { xcode-version: '16.4' }
      - uses: subosito/flutter-action@v2
        with: { channel: stable }
      - run: flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
      - run: xcrun altool --upload-app -f build/ios/ipa/*.ipa -t ios --apiKey $KEY --apiIssuer $ISSUER
W
cat > ios/Runner/NativeStore.swift <<'S'
import Foundation

/// Small native helper used from a method channel.
enum NativeStore {
  static func lastSync() -> Date? {
    UserDefaults.standard.object(forKey: "last_sync") as? Date
  }
  static func save(date: Date) {
    UserDefaults.standard.set(date, forKey: "last_sync")
  }
}
S
echo 'void main() {}' > lib/main.dart
