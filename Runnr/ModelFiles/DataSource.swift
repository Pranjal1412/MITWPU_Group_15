import UIKit
        
class DataSource {
    
    private var userProfile = UserProfile()
    private var userProfileImage : UIImage?
    private var userStats : UserStats?
    
    private var currentActivity: UserActivity?
    private var currentActivityCoordinates: [ActivityRouteCoordinates] = []
    private var currentActivityPaceData: [ActivityPaceGraphData] = []
    
    private var myActivities: [UserActivity] = []
    private var friendActivities: [UserActivity] = []
    private var clubsArray : [Club] = []
    private var myClubsArray : [ClubRoleAndData] = []
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
    
    func setProfileImage(_ image: UIImage) {
        self.userProfileImage = image
    }
    
    func getProfileImage() -> UIImage? {
        return userProfileImage
    }
    
    func getUserStats() -> UserStats? {
        return userStats
    }
    
    func setUserStats(_ userStats: UserStats) {
        self.userStats = userStats
    }
    
    func setAllActivities(_ activities: [UserActivity]) {
        self.myActivities = activities
    }
    
    func getAllActivities() -> [UserActivity] {
        return self.myActivities
    }
    
    func setCurrentActivity(_ activity: UserActivity) {
        self.currentActivity = activity
    }
    
    func getCurrentActivity() -> UserActivity? {
        return currentActivity
    }
    
    func setCurrentActivityCoordinates(_ coordinates: [ActivityRouteCoordinates]) {
        self.currentActivityCoordinates = coordinates
    }
    
    func getCurrentActivityCoordinates() -> [ActivityRouteCoordinates] {
        return self.currentActivityCoordinates
    }
    
    func setCurrentActivityPaceData(_ paceData: [ActivityPaceGraphData]) {
        self.currentActivityPaceData = paceData
    }
    
    func getCurrentActivityPaceData() -> [ActivityPaceGraphData] {
        return self.currentActivityPaceData
    }
    
    func resetMyActivities() {
        self.myActivities.removeAll()
    }
    
    func setclubsArray(_ clubData: [Club]) {
        self.clubsArray = clubData
    }
    
    func getclubsArray() -> [Club] {
        return self.clubsArray
    }
    
    func setMyClubs(_ myClub: [ClubRoleAndData]) {
        return self.myClubsArray = myClub
    }
    
    func getMyClubs() -> [ClubRoleAndData] {
        return self.myClubsArray
    }
    
    
//    MARK: - Below functions are yet to check and corrected
    func getFriendsActivityData() -> [UserActivity] {
        return friendActivities
    }
        
    func getTotalActivities() -> Int {
        return myActivities.count
    }
    
    func getTotalRunnrPoints() -> Int {
        if userStats != nil {
          return userStats!.totalPointsEarned
        }
        return 0
    }
    
    func shareActivity(atIndex index: Int, presentingViewController: UIViewController) {
        let shareMessage = "Check out my run on Runnr!"
        let itemsToShare: [Any] = [shareMessage]
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        presentingViewController.present(activityVC, animated: true)
    }
    func deleteActivityFromLocalArray(activityID: UUID) {
        myActivities.removeAll { $0.activityID == activityID }
    }

}

//    func getMyActivityData() -> [UserActivity] {
//        return myActivities
//    }
    
//    func updateTotalRunnrPoints(with points: Int) {
//        if userStats != nil {
//            userStats!.totalPointsEarned += points
//        }
//    }
//
//    func updateTotalDistance(with distance: Double) {
//        if userStats != nil {
//            userStats!.totalDistanceCovered += distance
//        }
//    }

//    func fetchAllMyActivities() async {
//        guard let userID = userProfile.userID else { return }
//        if let activities = await fetchAllActivities(userID: userID) {
//            self.myActivities = activities
//        }
//    }
