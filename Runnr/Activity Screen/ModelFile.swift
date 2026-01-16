import UIKit
import GoogleMaps

struct MyRunActivity {
    let userName: String
    let timeStamp: Date
    var runTitle: String
    let activityType: String
    let distanceValue: Double
    let distanceUnit: String
    let paceValue: Double
    let paceGraphData: [LivePaceGraphData]
    let paceUnit: String
    let stepsValue: Int
    let caloriesValue: Int
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

struct FriendsRunActivity {
    let userName: String
    let timeStamp: String
    let runTitle: String
    let distanceValue: Double
    let distanceUnit: String
    let paceValue: String      
    let paceUnit: String
    let timeHour: Int
    let timeMin: Int
    let timeSec: Int
    let activityPhotos: [String]
    let note: String
}

struct LivePaceGraphData: Identifiable {
    let id: UUID = UUID()
    let paceValue: Double
    let distance: Double
    let symbol: Bool
}



