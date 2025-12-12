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


    }
        
        
}
    

