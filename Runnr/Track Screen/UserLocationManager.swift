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
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        locationManager.distanceFilter = kCLDistanceFilterNone
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
        if let location = manager.location?.coordinate {
            
            onLocationUpdate?(location)
            print("Latitude: \(location.latitude), Longitude: \(location.longitude)")
            print("Array Size: \(activities.count)")
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

// MARK: - to be deleted after confirmation

//    func requestOneTimeLocation() {
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
//    }
    
//    func requestLocation() {
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
//    }
    
//    func alwaysAuthorization() {
//        locationManager.requestWhenInUseAuthorization()
//    }
    
//    func stopLocation() {
//        locationManager.stopUpdatingLocation()
//    }

//          this function is also called when maps are initialized at that time no location should be added to the activity
//          as the activity is not started yet, isEmpty is checked to avoid accessing index, when there is no data in the array
//          is started is used to to ensure that when there is activity already present in the array to avoid adding location into
//          the routeCoordinates
            
//            if activity.isEmpty == false {
//                let index = activity.count - 1
//                if activity[index].activityStarted == true {
//
//                    if activity[index].routeCoordinates.count() == 0 {
//
//                    }
//                    activity[index].routeCoordinates.add(location)
//                }
//            }
