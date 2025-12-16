//
//  ActivityDetailViewController.swift
//  Runnr
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit
import GoogleMaps

class ActivityDetailViewController: UIViewController {

    @IBOutlet weak var buttonBack: UIButton!
    
    var isMapInitialized: Bool = false
    let userLocation = UserLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 26.0, *) {
            buttonBack.configuration = .glass()
            buttonBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            buttonBack.tintColor = .white
        } else {
            buttonBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            buttonBack.tintColor = .white
        }
    }

    override func viewDidLayoutSubviews() {
        userLocation.onLocationUpdate = { coordinate in
            
            if self.isMapInitialized == false {
                
                let mapManager = MapManager()
                let topOffset = 140.0
                let mapView = mapManager.initializeMaps(withX: 0.0, withY: topOffset,
                                                       withWidth: self.view.frame.width,
                                                       withHeight: self.view.frame.height - topOffset,
                                                       location: coordinate)
                
                mapView.settings.scrollGestures = false
                mapView.settings.zoomGestures = false
                mapView.settings.rotateGestures = false
//                mapManger.mapBehavior(isEnabled: false)
                self.view.addSubview(mapView)
                
                self.userLocation.locationManager.stopUpdatingLocation()
                self.isMapInitialized = true
            }
            
        }
    }
    
}
