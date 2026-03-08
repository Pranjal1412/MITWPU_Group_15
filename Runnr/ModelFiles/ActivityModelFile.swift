import UIKit
import GoogleMaps

struct UserActivity: Codable {
    var userID: UUID?
    var activityID: UUID?
    
    var activityStartTime: Date?
    var activityEndTime: Date?
    
    var activityTitle: String?
    var activityType: ActivityType?
    var activityRemark: String?
    var isPublic: Bool?
    
    var distanceCovered: Double?
    var distanceUnit: DistanceUnit?
    
    var timeTakenSeconds: Int?
    var caloriesBurnt: Int?
    var stepsTaken: Int?
    
    var avgHeartRate: Double?
    var avgPace: Double?
    var paceUnit: PaceUnit?
    
    var mapImageURL: String?
    var basePoints: Int?
    var skillPoints: Int?
}

struct ActivityPaceGraphData : Codable {
    var activityID: UUID?
    let distanceValue: Double
    let paceValue: Double
}

struct ActivityPhotos {
    let activityID: UUID
    let photoID = UUID()
    let photoURL: String
}

struct ActivityRouteCoordinates : Codable {
    let activityID: UUID
    let latitude: Double
    let longitude: Double
    let sequence: Int
}

struct ActivityHRGraphData {
    let activityID : UUID
    let timeStamp : Date
    let heartRate : Double
}

struct FormatTime{
    let hour: Int
    let minute: Int
    let second: Int
}
