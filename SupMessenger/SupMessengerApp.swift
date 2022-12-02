//
//  SupMessengerApp.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 30.05.2022.
//

import SwiftUI
import Firebase
import FirebaseMessaging

@main
struct SupMessengerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
        }
    }
}

class AppDelegate: NSObject,UIApplicationDelegate{
    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        
        UNUserNotificationCenter.current().delegate = self
        // 2
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        // 3
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("token registered")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("token failed")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Method 1")
          // Print message ID.
          if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
          }
        print(userInfo)
        completionHandler(.newData)
    }
}

extension AppDelegate: MessagingDelegate{
    //Token receive
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("token: ", fcmToken ?? "")
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        if(UserDefaults.standard.bool(forKey: "isReg")){
            NotificationService.shared.setFcmToken(token: fcmToken!){response, error in
                print("token updated")
            }
        }
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
      ) {
          let userInfo = notification.request.content.userInfo
          print("Method 2")
          print(userInfo)
          
          completionHandler([[.banner, .sound]])
      }

      func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
      ) {
          let userInfo = response.notification.request.content.userInfo
          print("Method 3")
          print(userInfo)
          completionHandler()
      }
    
}
