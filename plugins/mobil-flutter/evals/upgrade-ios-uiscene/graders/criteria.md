---
type: llm
---

Facts: with Xcode 27 (iOS 27 SDK) UIKit apps must use the UIScene lifecycle or they fail to launch. Flutter auto-migrates only unmodified AppDelegates. Manual migration: AppDelegate conforms to `FlutterImplicitEngineDelegate`; plugin registration moves to `func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge)` using `GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)`; method channels are created there with `engineBridge.applicationRegistrar.messenger()`; `window?.rootViewController as! FlutterViewController` in didFinishLaunching crashes and must go. Info.plist gets `UIApplicationSceneManifest` with `UISceneDelegateClassName` = `FlutterSceneDelegate`, `UISceneConfigurationName` = `flutter`, `UISceneStoryboardFile` = `Main`, `UIApplicationSupportsMultipleScenes` = false.

PASS if the answer:
- makes AppDelegate conform to FlutterImplicitEngineDelegate and implements didInitializeImplicitFlutterEngine;
- moves GeneratedPluginRegistrant registration there with engineBridge.pluginRegistry;
- creates the battery FlutterMethodChannel there with engineBridge.applicationRegistrar.messenger() and removes the rootViewController cast;
- adds the UIApplicationSceneManifest block with FlutterSceneDelegate to Info.plist.

FAIL if it keeps reading window?.rootViewController in didFinishLaunching, writes a hand-rolled UIWindowSceneDelegate that creates its own FlutterViewController/FlutterEngine instead of using FlutterSceneDelegate, suggests disabling UIScene or staying on an older Xcode as the fix, or invents APIs.
