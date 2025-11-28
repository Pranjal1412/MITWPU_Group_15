//
//  modelFriends.swift
//  Runnr
//
//  Created by Archit Kankaria on 27/11/25.
//
import UIKit

struct RunActivityFriends {
    let name: String
    let date: String
    let runTitle: String
    let distanceValue: Double
    let distanceUnit: String
    let paceValue: String      // Example: "7:45"
    let paceUnit: String       // Example: "/km"
    let timeValue: String      // Example: "01 hr 34 min"
    let timeUnit: String       // Example: "50 sec"
    let image: UIImage?
    let note: String
}

let activitiesFriends: [RunActivityFriends] = [
    RunActivityFriends(
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
    RunActivityFriends(
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
    )
]


