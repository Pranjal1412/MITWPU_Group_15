//
//  LocalActivityStorage.swift
//  Runnr
//
//  Created by Mrunal Aralkar on 17/03/26.
//

import Foundation

struct LocalActivity: Codable {
    var activity: UserActivity
//    var coordinates: [ActivityRouteCoordinates]
    var paceData: [ActivityPaceGraphData]
}

class LocalActivityStorage {

    static let shared = LocalActivityStorage()
    private let key = "ONGOING_ACTIVITY"

    private init() {}

    // saving the data
    func save(_ data: LocalActivity) {
        do {
            // converting the data that is of type LocalActivity to JSON Data
            let encoded = try JSONEncoder().encode(data)

            // saving the json data in user defaults
            UserDefaults.standard.set(encoded, forKey: key)
            print("Local activity SAVED")
        } catch {
            print("Save failed:", error)
        }
    }

    func load() -> LocalActivity? {

        // key is used to find the data saved in userdefaults, fetching the json data in the variable data
        guard let data = UserDefaults.standard.data(forKey: key) else {
            print("No saved activity found")
            return nil
        }

        do {
            // converting the json data to LocalActivity
            let decoded = try JSONDecoder().decode(LocalActivity.self, from: data)
            print("Local activity LOADED")
            return decoded
        } catch {
            print("Load failed:", error)
            return nil
        }
    }

    // deletes the saved data
    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
        print("Local activity CLEARED")
    }
}
