import UIKit
        
class DataSource {
    
    private var userProfile = UserProfile()
    private var currentActivityID: UUID?
    private var user = UserStats(userID: UUID(), totalPointsEarned: 0, totalDistanceCovered: 0, totalActivities: 0, longestStreak: 0)
    private var myActivities: [UserActivity] = []
    private var friendActivities: [UserActivity] = []
    
    static let shared = DataSource()
    
    private init() {
        loadSampleData()
    }
    
    func loadSampleData() {
        let friendsSampleData : [UserActivity]  = [
            UserActivity(                
                activityStartTime: Date(timeIntervalSinceNow: -3600), // 1 hour ago
                activityEndTime: Date(),
                
                activityTitle: "Morning Run",
                activityType: .running,
                activityRemark: "Felt great, cool weather",
                isPublic: true,
                
                distanceCovered: 5.2,
                distanceUnit: .kilometers,
                
                timeTakenSeconds: 1800, // 30 mins
                caloriesBurnt: 420,
                stepsTaken: 6500,
                
                avgHeartRate: 148.5,
                avgPace: 5.45,
                paceUnit: .minPerKm,
                
                mapImageURL: "https://example.com/maps/run1.png",
                basePoints: 50,
                skillPoints: 20
            ),
            UserActivity(
                activityStartTime: Date(timeIntervalSinceNow: -5400), // 1.5 hours ago
                activityEndTime: Date(timeIntervalSinceNow: -3600),
                
                activityTitle: "Evening Walk",
                activityType: .walking,
                activityRemark: "Relaxing walk after dinner",
                isPublic: false,
                
                distanceCovered: 2.8,
                distanceUnit: .kilometers,
                
                timeTakenSeconds: 2400, // 40 mins
                caloriesBurnt: 180,
                stepsTaken: 4200,
                
                avgHeartRate: 102.3,
                avgPace: 8.55,
                paceUnit: .minPerKm,
                
                mapImageURL: nil,
                basePoints: 25,
                skillPoints: 10
            )
        ]
        self.friendActivities = friendsSampleData
    }
    
    func getUserProfile() -> UserProfile {
        return userProfile
    }
    
    func setUserProfile(_ userProfile: UserProfile) {
        self.userProfile = userProfile
    }
    
    func setCurrentActivityID(_ id: UUID) {
        self.currentActivityID = id
    }
    
    func getCurrentActivityID() -> UUID? {
        return currentActivityID
    }
    
    func getFriendsActivityData() -> [UserActivity] {
        return friendActivities
    }
    
    func fetchMyActivities() async {
        guard let userID = userProfile.userID else { return }
        if let activities = await fetchAllActivity(userID: userID) {
            self.myActivities = activities
        }
    }
    
    func getMyActivityData() -> [UserActivity] {
        return myActivities
    }
    
    func updateTotalRunnrPoints(with points: Int) {
        user.totalPointsEarned += points
    }
    
    func getTotalRunnrPoints() -> Int {
        return user.totalPointsEarned
    }
    
    func getTotalActivities() -> Int {
        return myActivities.count
    }
    
    func updateTotalDistance(with distance: Double) {
        user.totalDistanceCovered += distance
    }
    
    func getTotalKms() -> Double {
        return user.totalDistanceCovered
    }
    
    func shareActivity(atIndex index: Int, presentingViewController: UIViewController) {
        let shareMessage = "Check out my run on Runnr!"
        let itemsToShare: [Any] = [shareMessage]
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        presentingViewController.present(activityVC, animated: true)
    }
}

