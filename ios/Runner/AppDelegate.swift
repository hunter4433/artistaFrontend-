import UIKit
import Firebase
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Provide your Google Maps API key
        GMSServices.provideAPIKey("AIzaSyChvogVcovcqFYy-t365hv-SLzUtqHGp1I")

        // Configure Firebase
        FirebaseApp.configure()

        // Register for remote notifications
        application.registerForRemoteNotifications()

        // Ensure the Flutter plugins are registered
        GeneratedPluginRegistrant.register(with: self)

        // Return the super implementation
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Handle successful registration for remote notifications
    override func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // Set the device token for Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken
    }

    // Handle errors when registration for remote notifications fails
    override func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register for remote notifications: \(error)")
    }

    // Handle incoming notifications (optional)
    override func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // Handle the notification data
        print("Received notification: \(userInfo)")

        // Call the completion handler with appropriate result
        completionHandler(.newData)
    }
}
