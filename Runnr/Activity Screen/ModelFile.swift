import UIKit
import GoogleMaps

struct MyRunActivity {
    let name: String
    let date: String
    let runTitle: String
    let distanceValue: Double
    let distanceUnit: String
    let paceValue: String      
    let paceUnit: String
    let timeValue: String
    let timeUnit: String
    let image: UIImage?
    let note: String
    var routeCoordinates: [CLLocationCoordinate2D]
}

struct FriendsRunActivity {
    let name: String
    let date: String
    let runTitle: String
    let distanceValue: Double
    let distanceUnit: String
    let paceValue: String      
    let paceUnit: String
    let timeValue: String
    let timeUnit: String
    let image: UIImage?
    let note: String
}


var activities: [MyRunActivity] = []

let activitiesFriends: [FriendsRunActivity] = [
    FriendsRunActivity(
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
    )
]



