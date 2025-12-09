//
//  LocationManager.swift
//  Runnr
//
//  Created by SDC-USER on 21/11/25.
//

import CoreLocation

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
    
//    func requestOneTimeLocation() {
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
//    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func alwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func stopLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
        if let location = manager.location?.coordinate {
            
            onLocationUpdate?(location)
            print(location.latitude, location.longitude)
            
            if activity.isEmpty == false {
                let index = activity.count - 1
                activity[index].routeCoordinates.append(location)
                print("Coordinate COunt: \(activity[index].routeCoordinates.count)")
            }
            
            print("Array Size: \(activity.count)")
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            print("Location Access Granted")
        }
        else if status == .notDetermined {
//            locationManager.requestAlwaysAuthorization()
        }
        else if status == .denied || status == .restricted {
            print("Location Required to use this app")
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to get location:", error.localizedDescription)
//    }

}
