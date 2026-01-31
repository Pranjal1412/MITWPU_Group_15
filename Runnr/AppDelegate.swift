//
//  AppDelegate.swift
//  Runnr
//
//  Created by SDC-USER on 16/10/25.
//

import UIKit
import GoogleMaps
import Supabase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let supabase = SupabaseManager.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyAUgJgB9iqP2RzDO25TliEF_Qn77P1I5QQ")
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

//    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if url.scheme == "DevTeamRunnr" {
//            Task {
//                do {
//                    // 2. Hand the URL to Supabase to extract the session
//                    try await SupabaseManager.shared.client.auth.session(from: url)
//                    print("Successfully parsed session from URL!")
//                } catch {
//                    print("Failed to get session: \(error)")
//                }
//            }
//            return true
//        }
//        
//        return false
//    }

}

