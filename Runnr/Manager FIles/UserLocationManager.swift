//
//  LocationManager.swift
//  Runnr
//
//  Created by SDC-USER on 21/11/25.
//

import CoreLocation
import GoogleMaps

class UserLocationManager: NSObject, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var onLocationUpdate: ((CLLocation) -> Void)?
//    var activityStarted : Bool = false

    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.activityType = .fitness
        locationManager.distanceFilter = kCLDistanceFilterNone

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = manager.location {

            onLocationUpdate?(location)
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")

        }

    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
        }
        else if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
        else if status == .denied || status == .restricted {
            print("Location Required to use this app")
        }
    }

}
