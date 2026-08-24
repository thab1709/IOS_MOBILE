import UIKit
import Flutter
import FirebaseMessaging
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var ssoUrl: String? = nil
    
    var loginSSOChannel: FlutterMethodChannel!
    var loginWebSSOChannel: FlutterMethodChannel!
    var deepLinkChannel: FlutterMethodChannel!

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyDJeWO9rLp5iX3RXurl8EwDb-fiR32TnWo")
      GeneratedPluginRegistrant.register(with: self)
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
    application.registerForRemoteNotifications()
    
    let controller = window.rootViewController as! FlutterViewController
    let flavorchanner = FlutterMethodChannel(
        name: "map_direction",
        binaryMessenger: controller.binaryMessenger)
      
      loginSSOChannel = FlutterMethodChannel(
        name: "com.evn.pmis/sso",
        binaryMessenger: controller.binaryMessenger)
      loginSSOChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
              self.loginSSOChannel.invokeMethod("ssoResultFirst", arguments: self.ssoUrl)
          }
      })

      loginWebSSOChannel = FlutterMethodChannel(
        name: "com.evn.pmis/ssoWeb",
        binaryMessenger: controller.binaryMessenger)

      deepLinkChannel = FlutterMethodChannel(
        name: "com.evn.pmis/deepLink",
        binaryMessenger: controller.binaryMessenger)
      deepLinkChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          if call.method == "getInitialLink" {
              result(self.ssoUrl)
          } else {
              result(FlutterMethodNotImplemented)
          }
      })

    flavorchanner.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        let locations = (call.arguments as! String).split(separator: ",")
        let latStart : String = String(locations[0])
        let longStart : String = String(locations[1])
        let latEnd : String = String(locations[2])
        let longEnd : String = String(locations[3])
        let subUrl : String = "\(latStart),\(longStart)&daddr=\(latEnd),\(longEnd)"
        let urlStr : String = "http://maps.google.com/maps?saddr=\(subUrl)"
       
           if let url = URL(string: "\(urlStr)"), !url.absoluteString.isEmpty {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }

           // or outside scope use this
           guard let url = URL(string: "\(urlStr)"), !url.absoluteString.isEmpty else {
              return
           }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
    

    })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        self.ssoUrl = url.absoluteString
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.loginSSOChannel.invokeMethod("ssoResult", arguments: self.ssoUrl)
            self.loginWebSSOChannel.invokeMethod("ssoResult", arguments: self.ssoUrl)
            self.deepLinkChannel.invokeMethod("deepLink", arguments: self.ssoUrl)
                }
            return true
        }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

       Messaging.messaging().apnsToken = deviceToken
       super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
     }
}
