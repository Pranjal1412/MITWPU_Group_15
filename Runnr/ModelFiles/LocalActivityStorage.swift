//
//  LocalActivityStorage.swift
//  Runnr
//
//  Created by Mrunal Aralkar on 17/03/26.
//

import Foundation

// MARK: - Wrapper Model
struct LocalActivity: Codable {
    var activity: UserActivity
    var coordinates: [ActivityRouteCoordinates]
    var paceData: [ActivityPaceGraphData]
}

// MARK: - Storage Manager
class LocalActivityStorage {
    
    static let shared = LocalActivityStorage()
    private let key = "ONGOING_ACTIVITY"
    
    private init() {}
    
    // MARK: - SAVE
    func save(_ data: LocalActivity) {
        do {
            let encoded = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encoded, forKey: key)
            print("✅ Local activity SAVED")
        } catch {
            print("❌ Save failed:", error)
        }
    }
    
    // MARK: - LOAD
    func load() -> LocalActivity? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            print("⚠️ No saved activity found")
            return nil
        }
        
        do {
            let decoded = try JSONDecoder().decode(LocalActivity.self, from: data)
            print("✅ Local activity LOADED")
            return decoded
        } catch {
            print("❌ Load failed:", error)
            return nil
        }
    }
    
    // MARK: - CLEAR
    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
        print("🗑 Local activity CLEARED")
    }
}
