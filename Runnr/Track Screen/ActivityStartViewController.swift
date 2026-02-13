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
    @IBOutlet weak var buttonUserProfile: UIButton!
    @IBOutlet weak var buttonStart: UIButton!
    
    let userLocation = UserLocationManager()
    var isMapInitialized = false
    let topGradientView = UIView()
    let bottomGradientView = UIView()
    var newUserAlert : Bool?
    
    var dataSource = DataSource.shared
    var totalPoints: Int {
        dataSource.getTotalRunnrPoints()
    }
    
    private var profileImageURL = DataSource.shared.getUserProfile().userProfileImageURL 
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.userLocation.locationManager.requestWhenInUseAuthorization()
        self.userLocation.locationManager.startUpdatingLocation()
        
        self.setStartButton()
        self.labelScreenTitle.text = NSLocalizedString("Runnr.", comment: "")
        self.labelScreenTitle.textColor = .accent
        self.labelScreenTitle.sizeToFit()
        self.buttonUserProfile.layer.cornerRadius = self.buttonUserProfile.frame.height / 2
        self.buttonUserProfile.clipsToBounds = true
        
        Task {
                if let image = await convertURLToImage(urlString: self.profileImageURL!) {
                    print("Image downloaded")
                    dataSource.setProfileImage(image)
                    self.buttonUserProfile.setImage(image, for: .normal)
                } else {
                    print("Image conversion failed")
                }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.labelTotalPoints.text = "\(totalPoints)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.newUserAlert! {
            
            let destinationVC = IntroductionViewController()
            destinationVC.modalPresentationStyle = .overCurrentContext
            destinationVC.modalTransitionStyle = .crossDissolve
            self.present(destinationVC, animated: true , completion: nil)
            
            self.newUserAlert = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.userLocation.onLocationUpdate = { location in
            
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
                
                self.topGradientView.frame.size.height = 100
                self.topGradientView.frame.size.width = mapView.frame.width
                self.topGradientView.frame.origin.y = mapView.frame.origin.y - 5
                self.topGradientView.frame.origin.x = mapView.frame.origin.x
                addTopGradient(to: self.topGradientView)
                
                self.view.addSubview(mapView)
                self.view.addSubview(self.topGradientView)
                
                self.view.bringSubviewToFront(self.buttonStart)
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
    
    
    func setStartButton() {
        buttonStart.frame = CGRect(x: (UIScreen.main.bounds.width - 150)/2.0,
                                   y: (UIScreen.main.bounds.height - 150)/2.0,
                                   width: 150, height: 150)
        buttonStart.backgroundColor = .accent
        
        buttonStart.setTitle(NSLocalizedString("START", comment: ""), for: .normal)
        buttonStart.setTitleColor(.black, for: .normal)
        buttonStart.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        buttonStart.layer.cornerRadius = buttonStart.bounds.height / 2.0
        buttonStart.layer.shadowColor = UIColor.accent.withAlphaComponent(0.5).cgColor
        buttonStart.layer.shadowOpacity = 0.5
        buttonStart.layer.shadowRadius = self.buttonUserProfile.frame.height / 2
                    
    }
    
    @IBAction func startButtonPressed() {
        
        let destinationVC = ActivitySetGoalViewController()
        
        if #available(iOS 26.0, *) {
            destinationVC.modalPresentationStyle = .overFullScreen
        }
        
        self.present(destinationVC, animated: true, completion: nil)
                
    }
}
