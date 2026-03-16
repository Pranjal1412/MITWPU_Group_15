import UIKit
        
class DataSource {
    
    private var userProfile = UserProfile()
    private var userProfileImage : UIImage?
    private var userStats : UserStats?
    
    private var currentActivity: UserActivity?
    private var currentActivityCoordinates: [ActivityRouteCoordinates] = []
    private var currentActivityPaceData: [ActivityPaceGraphData] = []
    
    private var myActivities: [UserActivity] = []
    private var friendActivities: [FriendsActivity] = []
    private var clubsArray : [Club] = []
    private var myClubsArray : [ClubRoleAndData] = []
    
    private var gameID: UUID?
    private var gameTile: [TerritoryHexTile] = []
    private var soloChallenges: [AssignedChallengesProgress] = []
    
    private var unfollowedUser: [UserProfile] = []
    private var followedUser: [UserProfile] = []
    
    static let shared = DataSource()
    
    private init() {}
    
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
    
    func setUnFollowedUser(_ list: [UserProfile]) {
        self.unfollowedUser = list
    }
    
    func getUnFollowedUser() -> [UserProfile] {
        return self.unfollowedUser
    }
    
    func setFollowedUser(_ list: [UserProfile]) {
        self.followedUser = list
    }
    
    func getFollowedUser() -> [UserProfile] {
        return self.followedUser
    }
    
    func getFriendsActivityData() -> [FriendsActivity] {
        return friendActivities
    }

    func setFriendsActivityData(_ data: [FriendsActivity]) {
        self.friendActivities = data
    }
    
    func setGameID(_ gameID: UUID) {
        self.gameID = gameID
        UserDefaults.standard.set(gameID.uuidString, forKey: "activeGameID")
    }
    
    func getGameID() -> UUID? {
        if let gameID = self.gameID {
            return gameID
        }
        if let savedString = UserDefaults.standard.string(forKey: "activeGameID"),
           let savedID = UUID(uuidString: savedString) {
            self.gameID = savedID
            return savedID
        }
        return nil
    }
    
    func clearGameID() {
        self.gameID = nil
        UserDefaults.standard.removeObject(forKey: "activeGameID")
    }
    
    func setSoloChallenges(_ soloChallenges: [AssignedChallengesProgress]) {
        self.soloChallenges = soloChallenges
    }
    
    func getSoloChallenges() -> [AssignedChallengesProgress] {
        return self.soloChallenges
    }
    
    func getWeeklyTotal(graphStore: GraphManager) -> TotalValue {

        var totalDistance: Double = 0.0
        var totalCalories: Double = 0.0
        var totalPace: Double = 0.0
        var totalSteps: Double = 0.0

        for item in graphStore.weeklyData {
            totalDistance += item.distance
            totalPace += item.pace
            totalCalories += Double(item.calories)
            totalSteps += Double(item.steps)
        }

        return TotalValue(
            totalDistance: totalDistance,
            totalCalories: totalCalories,
            totalPace: totalPace,
            totalSteps: totalSteps
        )
    }

    func getMonthlyTotal(graphStore: GraphManager) -> TotalValue {

        var totalDistance: Double = 0.0
        var totalCalories: Double = 0.0
        var totalPace: Double = 0.0
        var totalSteps: Double = 0.0

        for item in graphStore.monthlyData {
            totalDistance += item.distance
            totalPace += item.pace
            totalCalories += Double(item.calories)
            totalSteps += Double(item.steps)
        }

        return TotalValue(
            totalDistance: totalDistance,
            totalCalories: totalCalories,
            totalPace: totalPace,
            totalSteps: totalSteps
        )
    }
    
    func getYearlyTotal(graphStore: GraphManager) -> TotalValue {

        var totalDistance: Double = 0.0
        var totalCalories: Double = 0.0
        var totalPace: Double = 0.0
        var totalSteps: Double = 0.0

        for item in graphStore.yearlyData {
            totalDistance += item.distance
            totalPace += item.pace
            totalCalories += Double(item.calories)
            totalSteps += Double(item.steps)
        }

        return TotalValue(totalDistance: totalDistance,totalCalories: totalCalories,totalPace: totalPace,totalSteps: totalSteps)
    }
    
//    MARK: - Below functions are yet to check and corrected
        
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
