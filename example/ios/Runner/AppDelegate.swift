import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
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
}
