//
//  LiveTrackingViewController.swift
//  Runnr
//
//  Created by SDC-USER on 09/12/25.
//

import UIKit
import GoogleMaps

class LiveTrackingViewController: UIViewController {

    var isMapInitialized = false
    let userLocation = UserLocationManager()
    let mapManager = MapManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.overrideUserInterfaceStyle = .dark

        userLocation.requestLocation()
                
        userLocation.onLocationUpdate = { coordinate in
            
            self.mapManager.routeLine.path = activity[activity.count-1].routeCoordinates
            
            print("Path Count: \(activity[activity.count-1].routeCoordinates.count())")
            
            if self.isMapInitialized == false {
                
                let mapView = self.mapManager.initializeMaps(withBottomInset: 70.0, withLeadingInset: 10.0, withTrailingInset: 10.0, location: coordinate)
              
                self.mapManager.userLocationMarkerSetting(isEnabled: true)
                mapView.settings.rotateGestures = false
                mapView.settings.zoomGestures = true
                mapView.settings.scrollGestures = true
                self.view.addSubview(mapView)
                
                self.mapManager.setRouteLineStyle()
                
                self.isMapInitialized = true
                
            }
            
        }
    }
    
}
