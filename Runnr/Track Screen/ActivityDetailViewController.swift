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
    @IBOutlet weak var buttonShowAnalysis: UIButton!
    
    var isMapInitialized: Bool = false
    let userLocation = UserLocationManager()
    var activityData : GMSMutablePath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 26.0, *) {
            buttonBack.configuration = .glass()
            buttonBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            buttonBack.tintColor = .white
        } else {
            buttonBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            buttonBack.frame.origin.x = 100.0
            buttonBack.tintColor = .white
        }
        
        buttonShowAnalysis.layer.cornerRadius = buttonShowAnalysis.frame.height / 2.0
        
        userLocation.locationManager.startUpdatingLocation()
        userLocation.onLocationUpdate = { coordinate in
            
            if self.isMapInitialized == false {
                
                let mapManager = MapManager()
                let topOffset = 140.0
                let mapView = mapManager.initializeMaps(withX: 0.0, withY: topOffset,
                                                       withWidth: self.view.frame.width,
                                                       withHeight: self.view.frame.height - topOffset,
                                                       location: coordinate)
                
                mapView.settings.scrollGestures = true
                mapView.settings.zoomGestures = true
                mapView.settings.rotateGestures = true
                
                mapManager.routeLine = GMSPolyline(path: self.activityData)
                mapManager.setRouteLineStyle()
                
                self.view.addSubview(mapView)
                self.view.bringSubviewToFront(self.buttonShowAnalysis)
                self.userLocation.locationManager.stopUpdatingLocation()
                self.isMapInitialized = true
            }
            
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        if let presenter = self.presentingViewController {
            self.dismiss(animated: true) {
                presenter.dismiss(animated: true, completion: nil)
            }

        }
                
    }
}
