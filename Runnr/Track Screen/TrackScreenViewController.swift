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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.overrideUserInterfaceStyle = .dark
        
        userLocation.requestLocation()
        
        labelScreenTitle.sizeToFit()
        labelScreenTitle.text = NSLocalizedString("Runnr.", comment: "")
        labelScreenTitle.textColor = .accent
        
    }

    override func viewDidLayoutSubviews() {
        userLocation.onLocationUpdate = { coordinate in
            
            if self.isMapInitialized == false {
                
                let mapManger = MapManager()
                let systemOS = UIDevice.current.systemVersion
                let topOffset = self.labelScreenTitle.frame.height + self.labelScreenTitle.frame.origin.y + 20.0
                var mapView = GMSMapView()
                
                if systemOS < "26" {
                    let bottomInset = self.view.safeAreaInsets.bottom
                    mapView = mapManger.initializeMaps(withBottomInset : bottomInset, withTopOffset: topOffset, location : coordinate)
                }
                else {
                    mapView = mapManger.initializeMaps(withTopOffset: topOffset, location : coordinate)
                }
                
                mapView.settings.scrollGestures = false
                mapView.settings.zoomGestures = false
                mapView.settings.rotateGestures = false
//                mapManger.mapBehavior(isEnabled: false)
                self.view.addSubview(mapView)
                
                self.createStartButton()
                self.userLocation.stopLocation()
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
        
//        if let sheet = destinationVC.sheetPresentationController {
//            let customDetent = UISheetPresentationController.Detent.custom { context in
//                return 661
//                }
//                
//                sheet.detents = [customDetent]
//                sheet.prefersGrabberVisible = true  // optional: adds drag handle
//                sheet.preferredCornerRadius = 20
//        }
        
        
        self.present(destinationVC, animated: true, completion: nil)
        
        userLocation.alwaysAuthorization()
        
    }
}
