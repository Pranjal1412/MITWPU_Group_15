//
//  LiveTrackingViewController.swift
//  Runnr
//
//  Created by SDC-USER on 09/12/25.
//

import UIKit

class LiveTrackingViewController: UIViewController {

    var isMapInitialized = false
    let userLocation = UserLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.overrideUserInterfaceStyle = .dark

    }

    override func viewDidLayoutSubviews() {
        
        userLocation.onLocationUpdate = { coordinate in
            
            let mapManager = MapManager()
            
            if self.isMapInitialized == false {
                let mapView = mapManager.initializeMaps(location : coordinate)
                mapManager.userLocationMarkerSetting(isEnabled: true)
                self.view.addSubview(mapView)
                self.isMapInitialized = true
            }
            
        }
        
    }
}
