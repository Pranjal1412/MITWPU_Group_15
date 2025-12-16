//
//  TrackScreenViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 26/10/25.
//

import UIKit
import GoogleMaps


class TrackScreenViewController: UIViewController {
    
    @IBOutlet weak var labelScreenTitle: UILabel!
    
    let userLocation = UserLocationManager()
    var isMapInitialized = false
    let systemOS = UIDevice.current.systemVersion
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.overrideUserInterfaceStyle = .dark
        
        userLocation.locationManager.requestWhenInUseAuthorization()
        userLocation.locationManager.startUpdatingLocation()
        
        labelScreenTitle.sizeToFit()
        labelScreenTitle.text = NSLocalizedString("Runnr.", comment: "")
        labelScreenTitle.textColor = .accent
        
    }

    override func viewDidLayoutSubviews() {
        userLocation.onLocationUpdate = { coordinate in
            
            if self.isMapInitialized == false {
                
                let mapManager = MapManager()
                let topOffset = self.labelScreenTitle.frame.height + self.labelScreenTitle.frame.origin.y + 20.0
                var mapView = GMSMapView()
                
                if self.systemOS < "26" {
                    let bottomInset = self.view.safeAreaInsets.bottom
                    mapView = mapManager.initializeMaps(withX: 0.0, withY: topOffset,
                                                       withWidth: self.view.frame.width,
                                                       withHeight: self.view.frame.height - bottomInset - topOffset,
                                                       location: coordinate)
                }
                else {
                    mapView = mapManager.initializeMaps(withX: 0.0, withY: topOffset,
                                                       withWidth: self.view.frame.width,
                                                       withHeight: self.view.frame.height - topOffset,
                                                       location: coordinate)
                }
                
                mapView.settings.scrollGestures = false
                mapView.settings.zoomGestures = false
                mapView.settings.rotateGestures = false
//                mapManger.mapBehavior(isEnabled: false)
                self.view.addSubview(mapView)
                
                self.createStartButton()
                self.userLocation.locationManager.stopUpdatingLocation()
                self.isMapInitialized = true
            }
            
        }
    }
    
    func createStartButton() {
        let startButton = UIButton()
        
        startButton.frame = CGRect(x: (UIScreen.main.bounds.width - 150)/2.0,
                                   y: (UIScreen.main.bounds.height - 150)/2.0,
                                   width: 150, height: 150)
        startButton.backgroundColor = .accent
        
        startButton.setTitle(NSLocalizedString("START", comment: ""), for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        startButton.layer.cornerRadius = startButton.bounds.height / 2.0
        
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        view.addSubview(startButton)
        
    }
    
    @objc func startButtonPressed() {
        
        let destinationVC = SetGoalViewController()
        
        if self.systemOS >= "26.0" {
            destinationVC.modalPresentationStyle = .overFullScreen
        }
        
        self.present(destinationVC, animated: true, completion: nil)
                
    }
}
