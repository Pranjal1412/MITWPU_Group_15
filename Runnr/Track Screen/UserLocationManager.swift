//
//  LocationManager.swift
//  Runnr
//
//  Created by SDC-USER on 21/11/25.
//

import CoreLocation
import UIKit

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
    
    func requestLocation() {
        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            
            onLocationUpdate?(location)
            print("Longitude: \(location.longitude), Latitude: \(location.latitude)")
            
        
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            print("Location Access Granted")
        }
        else if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        else if status == .denied || status == .restricted {
            
            let alert = UIAlertController(title: NSLocalizedString("Permission Denied", comment: ""),
                                          message: NSLocalizedString("Location access is required for the app to function properly. Please enable it in your settings.", comment: ""),
                                          preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            
            let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default, handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(settingsURL) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                }
            })
            
            alert.addAction(cancelAction)
            alert.addAction(settingsAction)
            
//            self.present(alert, animated: true, completion: nil)
        
            print("Location Required to use this app")
        }
    }

}
