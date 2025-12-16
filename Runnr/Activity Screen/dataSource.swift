//
//  dataSource.swift
//  Runnr
//
//  Created by Archit Kankaria on 16/12/25.
//
import UIKit
    
class DataSource{
    private var activities: [MyRunActivity] = []
    private var activitiesFriends: [FriendsRunActivity] = []
    static let shared = DataSource()
    
    private init() {
        loadSampleData()
    }
    
    func loadSampleData() {
        let friendsSampleData : [FriendsRunActivity] = [ FriendsRunActivity(
            name: "Ava Brooks",
            date: "September 7, 6:15 am",
            runTitle: "Morning Run!",
            distanceValue: 7.2,
            distanceUnit: "km",
            paceValue: "7:45",
            paceUnit: "/km",
            timeValue: "01 hr 34 min",
            timeUnit: "50 sec",
            image: UIImage(named: "run_map_example"), // Update image name as needed
            note: "First run in a while, tough, but refreshing excited to rebuild step-by-step."
        ),
        FriendsRunActivity(
            name: "Ava Brooks",
            date: "September 8, 6:20 am",
            runTitle: "Steady Run",
            distanceValue: 8.8,
            distanceUnit: "km",
            paceValue: "6:40",
            paceUnit: "/km",
            timeValue: "01 hr 18 min",
            timeUnit: "14 sec",
            image: UIImage(named: "run_map_example_2"), // Dummy name for example
            note: "Tough start, but refreshing to get moving again. Excited to rebuild consistency, step by step."
        )]
        
        self.activitiesFriends = friendsSampleData
    }
    
    func getFriendsActivityData() -> [FriendsRunActivity] {
        return activitiesFriends
    }
    func getMyActivityData() -> [MyRunActivity] {
        return activities
    }
    
    func addMyActivity(_ activity: MyRunActivity) {
        activities.append(activity)
    }
    
    func deleteMyActivity() {
        if !activities.isEmpty {
            activities.removeLast()
        }
    }
}


