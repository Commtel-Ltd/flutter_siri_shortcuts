import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Callback type for shortcut activation
typedef ShortcutActivationCallback = void Function(String activityType, Map<String, dynamic>? userInfo);

/// Configuration for a Siri shortcut
class FlutterSiriShortcutArgs {
  final String title;
  final String activityType;
  final String suggestedInvocationPhrase;
  final String? persistentIdentifier;
  final List<String>? requiredUserInfoKeys;
  final List<String>? keywords;
  final Map<String, String>? userInfo;
  final bool? isEligibleForSearch;
  final bool? isEligibleForPrediction;
  final bool? needsSave;

  FlutterSiriShortcutArgs({
    required this.title,
    required this.activityType,
    required this.suggestedInvocationPhrase,
    this.persistentIdentifier,
    this.isEligibleForPrediction = true,
    this.isEligibleForSearch = true,
    this.keywords,
    this.needsSave = true,
    this.requiredUserInfoKeys,
    this.userInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'activityType': activityType,
      'suggestedInvocationPhrase': suggestedInvocationPhrase,
      'persistentIdentifier': persistentIdentifier,
      'isEligibleForPrediction': isEligibleForPrediction,
      'isEligibleForSearch': isEligibleForSearch,
      'keywords': keywords,
      'needsSave': needsSave,
      'requiredUserInfoKeys': requiredUserInfoKeys,
      'userInfo': userInfo,
    };
  }
}

/// Platform interface for Siri shortcuts
abstract class FlutterSiriShortcutsPlatform extends PlatformInterface {
  FlutterSiriShortcutsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterSiriShortcutsPlatform _instance = MethodChannelFlutterSiriShortcuts();

  static FlutterSiriShortcutsPlatform get instance => _instance;

  static set instance(FlutterSiriShortcutsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> presentShortcut({FlutterSiriShortcutArgs? options}) async {
    throw UnimplementedError('presentShortcut() has not been implemented.');
  }

  Future<bool?> donateShortcut({FlutterSiriShortcutArgs? options}) async {
    throw UnimplementedError('donateShortcut() has not been implemented.');
  }

  Future<bool?> clearShortcuts() {
    throw UnimplementedError('clearShortcuts() has not been implemented.');
  }
}

/// Method channel implementation of the platform interface
class MethodChannelFlutterSiriShortcuts extends FlutterSiriShortcutsPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_siri_shortcuts');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> presentShortcut({FlutterSiriShortcutArgs? options}) async {
    if (options == null) {
      throw ArgumentError('FlutterSiriShortcutArgs options cannot be null');
    }
    final result = await methodChannel.invokeMethod<bool>('presentShortcut', options.toMap());
    return result;
  }

  @override
  Future<bool?> donateShortcut({FlutterSiriShortcutArgs? options}) async {
    if (options == null) {
      throw ArgumentError('FlutterSiriShortcutArgs options cannot be null');
    }
    final result = await methodChannel.invokeMethod<bool>('donateShortcut', options.toMap());
    return result;
  }

  @override
  Future<bool?> clearShortcuts() async {
    final result = await methodChannel.invokeMethod<bool>('clearShortcuts');
    return result;
  }
}
