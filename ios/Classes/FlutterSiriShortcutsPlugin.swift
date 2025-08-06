import Flutter
import UIKit

public class FlutterSiriShortcutsPlugin: NSObject, FlutterPlugin {
  private static var channel: FlutterMethodChannel?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    if #available(iOS 15.0, *) {
      let factory = AddToSiriButtonFactory(messenger: registrar.messenger())
      registrar.register(factory, withId: "AddToSiriButton")
    } else {
      print("iOS: Siri shortcuts are not supported")
    }
    
    let channel = FlutterMethodChannel(name: "flutter_siri_shortcuts", binaryMessenger: registrar.messenger())
    self.channel = channel
    let instance = FlutterSiriShortcutsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    // Register for shortcut activation handling
    registrar.addApplicationDelegate(instance)
  }
  
  // Handle shortcut activation from Siri
  public static func handleShortcutActivation(activityType: String, userInfo: [AnyHashable: Any]?) {
    guard let channel = self.channel else { return }
    
    var data: [String: Any] = ["activityType": activityType]
    if let userInfo = userInfo {
      data["userInfo"] = userInfo
    }
    
    channel.invokeMethod("onShortcutActivated", arguments: data)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "presentShortcut":
      if #available(iOS 12.0, *) {
        let args  =  call.arguments as! Dictionary<String, Any>
        ShortcutsHandler().presentShortcut(args)
        result(true)
      } else {
        result(FlutterMethodNotImplemented)
      }
    case "donateShortcut":
      if #available(iOS 12.0, *) {
        let args = call.arguments as! Dictionary<String, Any>
        ShortcutsHandler().donateShortcut(args)
        result(true)
      } else {
        result(FlutterMethodNotImplemented)
      }
    case "clearShortcuts":
      if #available(iOS 12.0, *) {
        result(ShortcutsHandler().clearShortcuts())
      } else {
        result(FlutterMethodNotImplemented)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  // Handle shortcut activation from Siri
  public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    
    // Check if this is a Siri shortcut activation
    if userActivity.activityType != NSUserActivityTypeBrowsingWeb {
      FlutterSiriShortcutsPlugin.handleShortcutActivation(
        activityType: userActivity.activityType,
        userInfo: userActivity.userInfo
      )
      return true
    }
    
    return false
  }
}
