//
//  AppDelegate.swift
//  Runnr
//
//  Created by SDC-USER on 16/10/25.
//

//
//  AppDelegate.swift
//  Runnr
//
//  Created by SDC-USER on 16/10/25.
//

import UIKit
import GoogleMaps
import Supabase
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let supabase = SupabaseManager.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyAUgJgB9iqP2RzDO25TliEF_Qn77P1I5QQ")
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permission granted: \(granted)")
        }
        
        Task {
            if let session = SupabaseManager.shared.client.auth.currentSession {
                await NotificationManager.shared.start(userId: session.user.id)
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Task {
            if let session = SupabaseManager.shared.client.auth.currentSession {
                await NotificationManager.shared.fetchLatest(userId: session.user.id)
            }
        }
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}
