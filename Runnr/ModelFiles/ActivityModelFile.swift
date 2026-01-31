import UIKit
import GoogleMaps

//struct UserProfile {
//    let userID = UUID()
//    var userName: String
//    var emailID: String
//    var profileImage: UIImage
//    var gender: String
//    var totalFollwers: Int = 0
//    var totalFollowing: Int = 0
//    var totalRunnrPoints: Int = 100
//    var totalDistance: Double = 0
//}

struct UserActivity {
    let id: UUID
    let userName: String // needs to removed from this struct
    let activityStartTime: Date
    let activityEndTime: Date
    var runTitle: String
    let activityType: String
    let distanceValue: Double
    let distanceUnit: String
    let paceValue: Double
    let paceGraphData: [LivePaceGraphData]
    let paceUnit: String
    let stepsValue: Int
    let caloriesValue: Int
    var avgHR: Double?
    let timeHour: Int
    let timeMin: Int
    let timeSec: Int
    let basePoints: Int
    let skillPoints: Int
    let mapImage: UIImage
    var activityPhotos: [UIImage]
    var note: String
    var isPublic: Bool
    var routeCoordinates: [CLLocationCoordinate2D]
}

struct LivePaceGraphData: Identifiable {
    let id: UUID = UUID()
    let paceValue: Double
    let distance: Double
    let symbol: Bool
}

//struct UserCategory {
//    let name : String
//    let goal : Int
//    let badge : String
//}

