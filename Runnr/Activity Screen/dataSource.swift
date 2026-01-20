import UIKit
        
class DataSource {
    private var activities: [MyRunActivity] = []
    private var activitiesFriends: [FriendsRunActivity] = []
    
    private var totalRunnrPoints: Int = 100
    private var totalDistance: Double = 0
    
    static let shared = DataSource()
    
    private init() {
        loadSampleData()
    }
    
    func loadSampleData() {
        let friendsSampleData : [FriendsRunActivity] = [ FriendsRunActivity(
            userName: "Ava Brooks",
            timeStamp: "September 7, 6:15 am",
            runTitle: "Morning Run!",
            distanceValue: 7.2,
            distanceUnit: "km",
            paceValue: "7:45",
            paceUnit: "/km",
            timeHour: 1,
            timeMin: 34,
            timeSec: 47,
            activityPhotos: ["run1", "run2", "mapSample"],
            note: "First run in a while, tough, but refreshing excited to rebuild step-by-step."
        ),
        FriendsRunActivity(
            userName: "Ava Brooks",
            timeStamp: "September 8, 6:20 am",
            runTitle: "Steady Run",
            distanceValue: 8.8,
            distanceUnit: "km",
            paceValue: "6:40",
            paceUnit: "/km",
            timeHour: 0,
            timeMin: 52,
            timeSec: 13,
            activityPhotos: ["run1", "run2", "mapSample"],
            note: "Tough start, but refreshing to get moving again. Excited to rebuild consistency, step by step."
        )]
        
        self.activitiesFriends = friendsSampleData
//        self.totalRunnrPoints = 100
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
    
    func deleteMyActivity(atIndex index: Int) {
        if !activities.isEmpty {
            activities.remove(at: index)
        }
    }
    
    func updateTotalRunnrPoints(with points: Int) {
        totalRunnrPoints += points
    }
    
    func getTotalRunnrPoints() -> Int {
        return totalRunnrPoints
    }
    
    func getTotalActivities() -> Int {
        return activities.count
    }
    
    func updateTotalDistance(with distance: Double) {
        totalDistance += distance
    }
    
    func getTotalKms() -> Double {
        return totalDistance
    }
    
    func shareActivity(atIndex index: Int, presentingViewController: UIViewController) {
        let shareMessage = "Check out my run on Runnr!"
        let itemsToShare: [Any] = [shareMessage]
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        presentingViewController.present(activityVC, animated: true)
    }
}

