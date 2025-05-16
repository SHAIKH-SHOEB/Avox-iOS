//
//  AppDelegate.swift
//  Avox
//
//  Created by Nimap on 26/01/24.
//

import UIKit
import CoreData
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.applicationIconBadgeNumber = 0
        Thread.sleep(forTimeInterval: 0)
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func saveNotificationToCoreData(notification: UNNotification) {
        let notificationData = NotificationData(context: DatabaseManager.share.context)
        notificationData.title = notification.request.content.title
        notificationData.body = notification.request.content.body
        notificationData.date = Date()
        DatabaseManager.share.saveContext()
    }
    
    // Handle notification when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle the notification as needed
        print("Received notification while app is in the foreground")
        saveNotificationToCoreData(notification: notification)
        completionHandler([.banner, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Save the notification to Core Data
        saveNotificationToCoreData(notification: response.notification)
        // Handle the tapped notification here
        // Tapped on Notification and open application
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let appDelegate = scene.delegate as? SceneDelegate {
            let vc = NotificationViewController()
            appDelegate.window?.rootViewController?.navigationController?.pushViewController(vc, animated: true)
        }
        completionHandler()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait  // or whichever orientation you want to support
    }
}

