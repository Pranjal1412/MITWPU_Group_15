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

        // Initialize Watch Connectivity
        _ = WatchConnectivityManager.shared

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        UNUserNotificationCenter.current().delegate = self


        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Get the token for the device + app
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("Device token: \(token)")
        
        #if DEBUG
        let env = "sandbox"
        
        #else
        let env = "production"
        #endif

        Task {
            do {
                let supabase = SupabaseManager.shared.client
                let session = try await supabase.auth.session
                let row = DeviceToken(user_id: session.user.id, token: token, environment: env)
                try await supabase
                    .from("device_tokens")
                    .upsert(row, onConflict: "user_id,token")
                    .execute()
            } catch {
                print("Failed to save token: \(error)")
            }
        }
        
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed: \(error)")
    }
    
    // Notification arrives while the app is OPEN
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }

}
