/// Flutter Siri Shortcuts Plugin
/// 
/// A comprehensive Flutter plugin for iOS Siri Shortcuts integration.
/// 
/// This library provides:
/// - [FlutterSiriShortcuts] - Main plugin class for managing shortcuts
/// - [AddToSiriButton] - Native iOS "Add to Siri" button widget
/// - [FlutterSiriShortcutArgs] - Configuration class for shortcuts
/// - [ShortcutActivationCallback] - Callback type for shortcut activations
/// 
/// Example usage:
/// ```dart
/// import 'package:flutter_siri_shortcuts/flutter_siri_shortcuts.dart';
/// 
/// // Initialize and use the plugin
/// final shortcuts = FlutterSiriShortcuts();
/// await shortcuts.initialize();
/// shortcuts.setShortcutActivationCallback((activityType, userInfo) {
///   print('Shortcut activated: $activityType');
/// });
/// 
/// // Add a button to your UI
/// AddToSiriButton(
///   title: 'My Action',
///   id: 'my_action',
/// )
/// ```
library flutter_siri_shortcuts;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'flutter_siri_shortcuts_platform_interface.dart';

export 'flutter_siri_shortcuts_platform_interface.dart' show FlutterSiriShortcutArgs, ShortcutActivationCallback;
export 'flutter_add_to_siri_button.dart' show AddToSiriButton;

/// Main plugin class for Siri shortcuts
class FlutterSiriShortcuts {
  FlutterSiriShortcuts({this.initOptions});

  final FlutterSiriShortcutArgs? initOptions;
  ShortcutActivationCallback? _onShortcutActivated;

  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_siri_shortcuts');

  /// Initialize the plugin and set up shortcut activation listener
  Future<void> initialize() async {
    methodChannel.setMethodCallHandler(_handleMethodCall);
  }

  /// Set callback for when shortcuts are activated
  void setShortcutActivationCallback(ShortcutActivationCallback callback) {
    _onShortcutActivated = callback;
  }

  /// Handle method calls from the native side
  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onShortcutActivated') {
      final Map<String, dynamic> arguments = Map<String, dynamic>.from(call.arguments);
      final String activityType = arguments['activityType'];
      final Map<String, dynamic>? userInfo = arguments['userInfo'] != null
          ? Map<String, dynamic>.from(arguments['userInfo'])
          : null;

      _onShortcutActivated?.call(activityType, userInfo);
    }
  }

  /// Get the platform version
  Future<String?> getPlatformVersion() async {
    return FlutterSiriShortcutsPlatform.instance.getPlatformVersion();
  }

  /// Present shortcut addition UI
  Future<bool?> presentShortcut({FlutterSiriShortcutArgs? options}) async {
    return FlutterSiriShortcutsPlatform.instance
        .presentShortcut(options: options ?? initOptions);
  }

  /// Donate shortcut to Siri
  Future<bool?> donateShortcut({FlutterSiriShortcutArgs? options}) async {
    return FlutterSiriShortcutsPlatform.instance
        .donateShortcut(options: options ?? initOptions);
  }

  /// Clear all shortcuts
  Future<bool?> clearShortcuts() {
    return FlutterSiriShortcutsPlatform.instance.clearShortcuts();
  }
}
