//
//  TrackScreenViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 26/10/25.
//

import UIKit
import GoogleMaps


class ActivityStartViewController: UIViewController {
    
    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var labelTotalPoints: UILabel!
    
    let userLocation = UserLocationManager()
    var isMapInitialized = false
    let topGradientView = UIView()
    let bottomGradientView = UIView()
    
    var totalPoints: Int {
        DataSource.shared.getTotalRunnrPoints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.overrideUserInterfaceStyle = .dark
        
        userLocation.locationManager.requestWhenInUseAuthorization()
        userLocation.locationManager.startUpdatingLocation()
        
        
        labelScreenTitle.text = NSLocalizedString("Runnr.", comment: "")
        labelScreenTitle.textColor = .accent
        labelScreenTitle.sizeToFit()
    }

    override func viewWillAppear(_ animated: Bool) {
        labelTotalPoints.text = "\(totalPoints)"
    }
    
    override func viewDidLayoutSubviews() {
        userLocation.onLocationUpdate = { location in
            
            if self.isMapInitialized == false {
                
                let mapManager = MapManager()
                let topOffset = self.labelScreenTitle.frame.height + self.labelScreenTitle.frame.origin.y + 20.0
                var mapView = GMSMapView()
                
                if #available(iOS 26.0, *) {
                    mapView = mapManager.initializeMaps(withX: 0.0, withY: topOffset,
                                                       withWidth: self.view.frame.width,
                                                       withHeight: self.view.frame.height  - topOffset,
                                                        location: location.coordinate)
                }
                else {
                    let bottomInset = self.view.safeAreaInsets.bottom
                    mapView = mapManager.initializeMaps(withX: 0.0, withY: topOffset,
                                                       withWidth: self.view.frame.width,
                                                       withHeight: self.view.frame.height - topOffset - bottomInset,
                                                       location: location.coordinate)
                }
                
                mapView.settings.scrollGestures = false
                mapView.settings.zoomGestures = false
                mapView.settings.rotateGestures = false
//                mapManger.mapBehavior(isEnabled: false)
                self.topGradientView.frame = mapView.bounds
                self.topGradientView.frame.origin.y = mapView.frame.origin.y - 5
                self.topGradientView.frame.origin.x = mapView.frame.origin.x
                addTopGradient(to: self.topGradientView)
                
                self.view.addSubview(mapView)
                self.view.addSubview(self.topGradientView)
                
                self.createStartButton()
                self.userLocation.locationManager.stopUpdatingLocation()
                self.isMapInitialized = true
            }
            
        }
    }
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        
        let destinationVC = UserProfileViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true, completion: nil)
        
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
        
        let destinationVC = ActivitySetGoalViewController()
        
        if #available(iOS 26.0, *) {
            destinationVC.modalPresentationStyle = .overFullScreen
        }
        
        self.present(destinationVC, animated: true, completion: nil)
                
    }
}
