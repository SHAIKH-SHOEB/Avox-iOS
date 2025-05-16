//
//  NotificationManager.swift
//  Avox
//
//  Created by Nimap on 02/02/24.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // Request Notification Permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notification permission granted")
                UserDefaults.standard.set("granted", forKey: "notification")
                self.scheduleLocalNotification()
            } else {
                print("Notification permission denied")
                UserDefaults.standard.set("denied", forKey: "notification")
            }
        }
    }
    
    func stopNotifications() {
        // Remove Notification Permission
//        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
//            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
//        }
        UserDefaults.standard.set("denied", forKey: "notification")
        // Stop Local Notifications
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }
    
    // MARK: - Local Notifications
    
    // Schedule Local Notification
    //Users/nimap/Library/Developer/CoreSimulator/Devices/CEF26F9C-C4D5-44CF-86B2-935B9B47B1A6/data/Containers/Data/Application
    func scheduleLocalNotification() {
        let message = RandomMessageProvider.getRandomTitleAndBody()
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "Notification"
        content.title = message.title
        content.body = message.body
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    struct RandomMessageProvider {
        private static let titles = [
            "New Wallpapers Available! 🌟",
            "Daily Delight! 🎉",
            "Personalize Your Screen! 🖼️",
            "Exclusive Picks for You! 💎",
            "Fresh Arrivals Alert! 🌈",
            "Explore, Download, Enjoy! 🌠",
            "Surprise Unveiled! 🎁",
            "Popular Picks! 🔥",
            "Your Favorites are Back! 🌟",
            "Stay Inspired Every Day! 🌈"
        ]
        
        private static let bodies = [
            "Explore stunning new wallpapers added just for you!",
            "Your daily dose of inspiration is here! Check out our latest wallpapers.",
            "Transform your device with our diverse collection of wallpapers. Find your perfect match!",
            "Unlock exclusive wallpapers curated just for our awesome users. Discover them now!",
            "Don't miss out! Exciting new wallpapers have just landed. Dive into the beauty!",
            "Endless possibilities await! Explore, download, and enjoy our vast collection of wallpapers.",
            "We've got a surprise for you! Open the app to reveal something special waiting just for you.",
            "Join the trend! Explore the wallpapers everyone is loving right now.",
            "Good news! Your favorite wallpapers are back in stock. Grab them before they're gone!",
            "Let inspiration greet you every day. Explore our diverse collection of uplifting wallpapers."
        ]

        // Function returning a tuple with both title and body
        static func getRandomTitleAndBody() -> (title: String, body: String) {
            let randomTitle = titles.randomElement() ?? "Dear Anonymous"
            let randomBody = bodies.randomElement() ?? "Exploring the Best Zedge Wallpapers With Avox"
            return (title: randomTitle, body: randomBody)
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
}
