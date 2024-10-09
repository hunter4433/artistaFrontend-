import UIKit
//import Firebase
import Flutter
//import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//    GMSServices.provideAPIKey("AIzaSyChvogVcovcqFYy-t365hv-SLzUtqHGp1I")
//    FirebaseApp.configure()
    
    // Register for remote notifications
    application.registerForRemoteNotifications()
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Keep this method if you need to handle remote notification registration
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//    Messaging.messaging().apnsToken = deviceToken
  }
}
