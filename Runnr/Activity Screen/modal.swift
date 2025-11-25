//
//  modal.swift
//  Runnr
//
//  Created by Archit Kankaria on 25/11/25.
//
import UIKit
struct RunActivity {
    let name: String
    let date: String
    let runTitle: String
    let distance: String
    let pace: String
    let time: String
    let image: UIImage?
    let note: String
}

    var activities: [RunActivity] = [
        RunActivity(
            name: "Ava Brooks",
            date: "September 7, 6:15 am",
            runTitle: "Morning Run!",
            distance: "7.2 km",
            pace: "7:45/km",
            time: "01 hr 34 min 50 sec",
            image: UIImage(named: "run_map_example"), // Update image name as needed
            note: "First run in a while, tough, but refreshing excited to rebuild step-by-step."
        ),RunActivity(
            name: "Ava Brooks",
            date: "September 7, 6:15 am",
            runTitle: "Morning Run!",
            distance: "7.2 km",
            pace: "7:45/km",
            time: "01 hr 34 min 50 sec",
            image: UIImage(named: "run_map_example"), // Update image name as needed
            note: "First run in a while, tough, but refreshing excited to rebuild step-by-step."
        ),RunActivity(
            name: "Ava Brooks",
            date: "September 7, 6:15 am",
            runTitle: "Morning Run!",
            distance: "7.2 km",
            pace: "7:45/km",
            time: "01 hr 34 min 50 sec",
            image: UIImage(named: "run_map_example"), // Update image name as needed
            note: "First run in a while, tough, but refreshing excited to rebuild step-by-step."
        )

]
