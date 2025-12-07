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
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            
            onLocationUpdate?(location)

//            print("Longitude: \(location.longitude), Latitude: \(location.latitude)")
//            latitude = location.latitude
//            longitude = location.longitude
            
        }
    }
    

}
