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
    var activityStarted : Bool = false
    var totalDistance : CGFloat = 0.0
    var lastLocation : CLLocation?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        locationManager.distanceFilter = kCLDistanceFilterNone
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
        if let location = manager.location {
            
            onLocationUpdate?(location.coordinate)
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            
            if activityStarted == true {
                if let last = lastLocation {
                    totalDistance += location.distance(from: last)
                }
                
                lastLocation = location
            }
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
