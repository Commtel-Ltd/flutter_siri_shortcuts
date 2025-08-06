# Siri Shortcuts - Simple Usage Guide

A clean, minimal implementation for creating Siri shortcuts and detecting when they're activated.

## Quick Start

### 1. Initialize and Listen for Shortcuts

```dart
class _MyAppState extends State<MyApp> {
  late FlutterSiriShortcuts _shortcuts;
  String _status = 'No shortcut activated yet';

  @override
  void initState() {
    super.initState();
    _initializeShortcuts();
  }

  Future<void> _initializeShortcuts() async {
    _shortcuts = FlutterSiriShortcuts();
    await _shortcuts.initialize();

    // Listen for activations
    _shortcuts.setShortcutActivationCallback(_onShortcutActivated);
  }

  void _onShortcutActivated(String activityType, Map<String, dynamic>? userInfo) {
    setState(() {
      _status = 'Activated: $activityType';
    });
    
    // Your task execution logic here
    print('Executing: $activityType with data: $userInfo');
  }
}
```

### 2. Add Shortcut to Siri

```dart
// Show "Add to Siri" button
AddToSiriButton(
  title: 'My Action',
  id: 'my_action',
  url: 'https://example.com',
)

// Or donate shortcut programmatically
await _shortcuts.donateShortcut();
```

### 3. iOS Setup

Add this to your `ios/Runner/AppDelegate.swift`:

```swift
override func application(
  _ application: UIApplication,
  continue userActivity: NSUserActivity,
  restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
) -> Bool {
  
  if userActivity.activityType != NSUserActivityTypeBrowsingWeb {
    if let flutterEngine = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "flutter_siri_shortcuts",
        binaryMessenger: flutterEngine.binaryMessenger
      )
      
      var data: [String: Any] = ["activityType": userActivity.activityType]
      if let userInfo = userActivity.userInfo {
        data["userInfo"] = userInfo
      }
      
      channel.invokeMethod("onShortcutActivated", arguments: data)
    }
    return true
  }
  
  return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
}
```

## Core Features

- **Create shortcuts**: Configure shortcut details and user data
- **Detect activation**: Get notified when Siri triggers your shortcut
- **Execute tasks**: Run your app logic when shortcuts are activated
- **Show status**: Display if shortcuts are already added to Siri
- **Clean up**: Clear shortcuts when needed

## That's it!

This minimal setup gives you everything you need:
1. Create shortcuts with custom data
2. Detect when they're triggered by Siri
3. Execute your app logic in response
4. Clean, readable code with no bloat
