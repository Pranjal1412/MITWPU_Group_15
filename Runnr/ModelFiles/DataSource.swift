import UIKit
        
class DataSource {
    
    private var user : UserProfile = UserProfile(userName: "Ava Brooks", emailID: "avabrook@gmail.com", profileImage: UIImage(named: "user3")!, gender: "Female")
    private var myActivities: [UserActivity] = []
    private var friendActivities: [UserActivity] = []
    
    static let shared = DataSource()
    
    private init() {
        loadSampleData()
    }
    
    func loadSampleData() {
        let friendsSampleData : [UserActivity]  = [
            UserActivity(
                id: UUID(),
                userName: "Thomas Crook",
                activityStartTime: Date(),
                activityEndTime: Date(),
                runTitle: "Morning Run!",
                activityType: "Run",
                distanceValue: 7.2,
                distanceUnit: "Km",
                paceValue: 7.75,
                paceGraphData: [],
                paceUnit: "/Km",
                stepsValue: 9340,
                caloriesValue: 420,
                timeHour: 1,
                timeMin: 34,
                timeSec: 47,
                basePoints: 120,
                skillPoints: 35,
                mapImage: UIImage(named: "mapSample")!,
                activityPhotos: [
                    UIImage(named: "run1")!,
                    UIImage(named: "run2")!,
                    UIImage(named: "mapSample")!],
                note: "First run in a while, tough but refreshing. Excited to rebuild step-by-step.",
                isPublic: true,
                routeCoordinates: []
            ),

            UserActivity(
                id: UUID(),
                userName: "Jane Doe",
                activityStartTime: Date(),
                activityEndTime: Date(),
                runTitle: "Steady Run",
                activityType: "Run",
                distanceValue: 8.8,
                distanceUnit: "Km",
                paceValue: 6.66,
                paceGraphData: [],
                paceUnit: "/Km",
                stepsValue: 10850,
                caloriesValue: 510,
                timeHour: 0,
                timeMin: 52,
                timeSec: 13,
                basePoints: 150,
                skillPoints: 50,
                mapImage: UIImage(named: "mapSample")!,
                activityPhotos: [
                    UIImage(named: "run1")!,
                    UIImage(named: "run2")!,
                    UIImage(named: "mapSample")!
                ],
                note: "Tough start, but refreshing to get moving again. Working on consistency.",
                isPublic: true,
                routeCoordinates: []
            )
        ]

        self.friendActivities = friendsSampleData
    }
    
    func getUserID() -> UUID {
        return user.userID
    }
    
    func getFriendsActivityData() -> [UserActivity] {
        return friendActivities
    }
    func getMyActivityData() -> [UserActivity] {
        return myActivities
    }
    
    func addMyActivity(_ activity: UserActivity) {
        myActivities.append(activity)
    }
    
    func deleteMyActivity(atIndex index: Int) {
        if !myActivities.isEmpty {
            myActivities.remove(at: index)
        }
    }
    
    func updateTotalRunnrPoints(with points: Int) {
        user.totalRunnrPoints += points
    }
    
    func getTotalRunnrPoints() -> Int {
        return user.totalRunnrPoints
    }
    
    func getTotalActivities() -> Int {
        return myActivities.count
    }
    
    func updateTotalDistance(with distance: Double) {
        user.totalDistance += distance
    }
    
    func getTotalKms() -> Double {
        return user.totalDistance
    }
    
    func shareActivity(atIndex index: Int, presentingViewController: UIViewController) {
        let shareMessage = "Check out my run on Runnr!"
        let itemsToShare: [Any] = [shareMessage]
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        presentingViewController.present(activityVC, animated: true)
    }
}

