import UIKit
        
class DataSource {
    
    private var userProfile = UserProfile()
    private var userProfileImage : UIImage?
    private var userStats : UserStats?
    
    private var currentActivity: ActivityDetails?
    private var currentActivityCoordinates: [ActivityRouteCoordinates] = []
    private var currentActivityPaceData: [ActivityPaceGraphData] = []
    private var currentActivityHeartRateData: [ActivityHRGraphData] = []
    private var currentActivityImages: [ActivityPhotos] = []
    
    private var myActivities: [ActivityDetails] = []
    private var friendActivities: [ActivityDetails] = []
    private var clubsArray : [Club] = []
    private var myClubsArray : [ClubRoleAndData] = []
    private var clubEvents: [ClubEvents] = []
    
    private var gameID: UUID?
    private var gameDetails: TerritoryGame?
    private var gameTile: [TerritoryHexTile] = []
    private var soloChallenges: [AssignedChallengesProgress] = []
    
    private var unfollowedUser: [UserProfile] = []
    private var followingUser: [UserProfile] = []
    private var followedUser: [UserProfile] = []
    private var battleInviteNotifications: [BattleInviteNotification] = []
    
    static let shared = DataSource()
        
    func getGameDetails() -> TerritoryGame? {
        return gameDetails
    }
    
    func setGameDetails(_ gameDetails: TerritoryGame) {
        self.gameDetails = gameDetails
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
    
    func setAllActivities(_ activities: [ActivityDetails]) {
        self.myActivities = activities
    }
    
    func getAllActivities() -> [ActivityDetails] {
        return self.myActivities
    }
    
    func setCurrentActivity(_ activity: ActivityDetails) {
        self.currentActivity = activity
    }
    
    func getCurrentActivity() -> ActivityDetails? {
        return currentActivity
    }
    
    func setCurrentActivityImages(_ activityImages: [ActivityPhotos]) {
        self.currentActivityImages = activityImages
    }
    
    func getCurrentActivityImages() -> [ActivityPhotos]? {
        return self.currentActivityImages
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
    
    func setFollowingUser(_ list: [UserProfile]) {
        self.followingUser = list
    }
    
    func getFollowingUser() -> [UserProfile] {
        return self.followingUser
    }
    
    func setBattleInviteNotifications(_ list: [BattleInviteNotification]) {
        self.battleInviteNotifications = list
    }
    
    func getBattleInviteNotifications() -> [BattleInviteNotification] {
        return self.battleInviteNotifications
    }
    
    func getFriendsActivityData() -> [ActivityDetails] {
        return friendActivities
    }

    func setFriendsActivityData(_ data: [ActivityDetails]) {
        self.friendActivities = data
    }
    
    func setClubEvents(_ events: [ClubEvents]) {
        self.clubEvents = events
    }
    
    func getClubEvents() -> [ClubEvents] {
        return self.clubEvents
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
    
//        func getWeeklyTotal(graphStore: GraphManager) -> TotalValue {
//
//            let calendar = Calendar.current
//            let endDate = graphStore.referenceDate
//            
//            guard let startDate = calendar.date(byAdding: .day, value: -6, to: endDate) else {
//                return TotalValue(totalDistance: 0, totalCalories: 0, totalPace: 0, totalSteps: 0)
//            }
//
//            let filteredActivities = myActivities.filter { item in
//                guard let date = item.activity?.activityStartTime else { return false }
//                return date >= startDate && date <= endDate
//            }
//
//            let totalCalories = filteredActivities.reduce(0.0) {
//                $0 + Double($1.activity?.caloriesBurnt ?? 0)
//            }
//
//            let totalDistance = filteredActivities.reduce(0.0) {
//                $0 + ($1.activity?.distanceCovered ?? 0.0)
//            }
//
//            let totalSteps = filteredActivities.reduce(0.0) {
//                $0 + Double($1.activity?.stepsTaken ?? 0)
//            }
//
//            let totalPace = filteredActivities.reduce(0.0) {
//                $0 + ($1.activity?.avgPace ?? 0.0)
//            }
//
//            return TotalValue(
//                totalDistance: totalDistance,
//                totalCalories: totalCalories,
//                totalPace: totalPace,
//                totalSteps: totalSteps
//            )
//        }
//
//        return TotalValue(
//            totalDistance: totalDistance,
//            totalCalories: totalCalories,
//            totalPace: totalPace,
//            totalSteps: totalSteps
//        )
//    }
    
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
        myActivities.removeAll { $0.activity?.activityID == activityID }
    }

}
