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
    let image: UIImage
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
    //let image:  String
    let photos: [String]
    let note: String
}



