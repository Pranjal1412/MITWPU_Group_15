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
