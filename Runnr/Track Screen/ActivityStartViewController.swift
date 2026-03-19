//
//  TrackScreenViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 26/10/25.
//

import UIKit
import GoogleMaps
import Kingfisher

class ActivityStartViewController: UIViewController {
    
    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var labelTotalPoints: UILabel!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var buttonUserProfile: UIButton!
    
    let userLocation = UserLocationManager()
    var isMapInitialized = false
    let topGradientView = UIView()
    let bottomGradientView = UIView()
    var newUserAlert : Bool?
    
    var dataSource = DataSource.shared
    var hasShownRecoveryAlert = false
    var totalPoints: Int {
        dataSource.getTotalRunnrPoints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.userLocation.locationManager.requestWhenInUseAuthorization()
        self.userLocation.locationManager.startUpdatingLocation()
        
        self.setStartButton()
        self.labelScreenTitle.text = NSLocalizedString("Runnr.", comment: "")
        self.labelScreenTitle.textColor = .accent
        self.labelScreenTitle.sizeToFit()
        self.buttonUserProfile.layer.cornerRadius = self.buttonUserProfile.frame.height / 2
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
        self.profileImage.clipsToBounds = true
        self.buttonUserProfile.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        let profileImageURL = DataSource.shared.getUserProfile().userProfileImageURL

        if let url = URL(string: profileImageURL!) {
            self.profileImage.kf.setImage(with: url)
        }

        self.labelTotalPoints.text = "\(totalPoints)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.newUserAlert == true {
            let destinationVC = IntroductionViewController()
            destinationVC.modalPresentationStyle = .overCurrentContext
            destinationVC.modalTransitionStyle = .crossDissolve
            self.present(destinationVC, animated: true, completion: nil)
            self.newUserAlert = false
        }
        
        if let recovered = LocalActivityStorage.shared.load(), !hasShownRecoveryAlert {
            hasShownRecoveryAlert = true
            handleRecoveredActivity(recovered)
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
                                                       withHeight: self.view.frame.height - topOffset,
                                                       location: location.coordinate)
                } else {
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
    
    func handleRecoveredActivity(_ local: LocalActivity) {
        let alert = UIAlertController(
            title: "Resume Run?",
            message: "You have an unfinished run. What would you like to do?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Resume", style: .default, handler: { _ in
            self.resumeActivity(local)
        }))
        
        alert.addAction(UIAlertAction(title: "End & Save", style: .default, handler: { _ in
            self.saveRecoveredActivity(local)
        }))
        
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { _ in
            LocalActivityStorage.shared.clear()
        }))
        
        present(alert, animated: true)
    }
    
    func resumeActivity(_ local: LocalActivity) {
        LocalActivityStorage.shared.clear()
        
        let vc = ActivityLiveTrackingViewController(
            nibName: "ActivityLiveTrackingViewController",
            bundle: nil
        )
        vc.recoveredActivity = local
        
        // ✅ Wrap in nav controller so navigationController is not nil inside ActivityLiveTrackingViewController
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        navController.setNavigationBarHidden(true, animated: false)
        self.present(navController, animated: true)
    }
    
    func saveRecoveredActivity(_ local: LocalActivity) {
        LocalActivityStorage.shared.clear()
        print("Recovered activity finalized")
    }
    
    @IBAction func startButtonPressed() {
        let destinationVC = ActivitySetGoalViewController()
        
        if #available(iOS 26.0, *) {
            destinationVC.modalPresentationStyle = .overFullScreen
        }
        
        self.present(destinationVC, animated: true, completion: nil)
    }
}

//
//  TrackScreenViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 26/10/25.
//

//import UIKit
//import GoogleMaps
//import Kingfisher
//
//class ActivityStartViewController: UIViewController {
//    
//    @IBOutlet weak var labelScreenTitle: UILabel!
//    @IBOutlet weak var labelTotalPoints: UILabel!
//    @IBOutlet weak var buttonStart: UIButton!
//    @IBOutlet weak var profileImage: UIImageView!
//    @IBOutlet weak var buttonUserProfile: UIButton!
//    
//    let userLocation = UserLocationManager()
//    var isMapInitialized = false
//    let topGradientView = UIView()
//    let bottomGradientView = UIView()
//    var newUserAlert : Bool?
//    
//    var dataSource = DataSource.shared
//    var hasShownRecoveryAlert = false
//    var totalPoints: Int {
//        dataSource.getTotalRunnrPoints()
//    }
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//                
//        self.userLocation.locationManager.requestWhenInUseAuthorization()
//        self.userLocation.locationManager.startUpdatingLocation()
//        
//        self.setStartButton()
//        self.labelScreenTitle.text = NSLocalizedString("Runnr.", comment: "")
//        self.labelScreenTitle.textColor = .accent
//        self.labelScreenTitle.sizeToFit()
//        self.buttonUserProfile.layer.cornerRadius = self.buttonUserProfile.frame.height / 2
//        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
//        self.profileImage.clipsToBounds = true
//        self.buttonUserProfile.clipsToBounds = true
//                        
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        let profileImageURL = DataSource.shared.getUserProfile().userProfileImageURL
//
//        if let url = URL(string: profileImageURL!) {
//            self.profileImage.kf.setImage(with: url)
//        }
//
//        self.labelTotalPoints.text = "\(totalPoints)"
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//       if self.newUserAlert == true {
//            
//            let destinationVC = IntroductionViewController()
//            destinationVC.modalPresentationStyle = .overCurrentContext
//            destinationVC.modalTransitionStyle = .crossDissolve
//            self.present(destinationVC, animated: true , completion: nil)
//            
//            self.newUserAlert = false
//       }
//        
//        if let recovered = LocalActivityStorage.shared.load(), !hasShownRecoveryAlert {
//            hasShownRecoveryAlert = true
//            handleRecoveredActivity(recovered)
//        }
//
//    }
//    
//    override func viewDidLayoutSubviews() {
//        self.userLocation.onLocationUpdate = { location in
//            
//            if self.isMapInitialized == false {
//                
//                let mapManager = MapManager()
//                let topOffset = self.labelScreenTitle.frame.height + self.labelScreenTitle.frame.origin.y + 20.0
//                var mapView = GMSMapView()
//                
//                if #available(iOS 26.0, *) {
//                    mapView = mapManager.initializeMaps(withX: 0.0, withY: topOffset,
//                                                       withWidth: self.view.frame.width,
//                                                       withHeight: self.view.frame.height  - topOffset,
//                                                        location: location.coordinate)
//                }
//                else {
//                    let bottomInset = self.view.safeAreaInsets.bottom
//                    mapView = mapManager.initializeMaps(withX: 0.0, withY: topOffset,
//                                                       withWidth: self.view.frame.width,
//                                                       withHeight: self.view.frame.height - topOffset - bottomInset,
//                                                       location: location.coordinate)
//                }
//                
//                mapView.settings.scrollGestures = false
//                mapView.settings.zoomGestures = false
//                mapView.settings.rotateGestures = false
//                
//                self.topGradientView.frame.size.height = 100
//                self.topGradientView.frame.size.width = mapView.frame.width
//                self.topGradientView.frame.origin.y = mapView.frame.origin.y - 5
//                self.topGradientView.frame.origin.x = mapView.frame.origin.x
//                addTopGradient(to: self.topGradientView)
//                
//                self.view.addSubview(mapView)
//                self.view.addSubview(self.topGradientView)
//                
//                self.view.bringSubviewToFront(self.buttonStart)
//                self.userLocation.locationManager.stopUpdatingLocation()
//                self.isMapInitialized = true
//                
//            }
//            
//        }
//    }
//    
//    @IBAction func profileButtonPressed(_ sender: UIButton) {
//        
//        let destinationVC = UserProfileViewController()
//        destinationVC.modalPresentationStyle = .fullScreen
//        self.present(destinationVC, animated: true, completion: nil)
//        
//    }
//    
//    
//    func setStartButton() {
//        buttonStart.frame = CGRect(x: (UIScreen.main.bounds.width - 150)/2.0,
//                                   y: (UIScreen.main.bounds.height - 150)/2.0,
//                                   width: 150, height: 150)
//        buttonStart.backgroundColor = .accent
//        
//        buttonStart.setTitle(NSLocalizedString("START", comment: ""), for: .normal)
//        buttonStart.setTitleColor(.black, for: .normal)
//        buttonStart.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
//        buttonStart.layer.cornerRadius = buttonStart.bounds.height / 2.0
//        buttonStart.layer.shadowColor = UIColor.accent.withAlphaComponent(0.5).cgColor
//        buttonStart.layer.shadowOpacity = 0.5
//        buttonStart.layer.shadowRadius = self.buttonUserProfile.frame.height / 2
//                    
//    }
//    
//    func handleRecoveredActivity(_ local: LocalActivity) {
//        
//        let alert = UIAlertController(
//            title: "Resume Run?",
//            message: "You have an unfinished run. What would you like to do?",
//            preferredStyle: .alert
//        )
//        
//        // 🔥 RESUME (this is what you're missing)
//        alert.addAction(UIAlertAction(title: "Resume", style: .default, handler: { _ in
//            self.resumeActivity(local)
//        }))
//        
//        // Save & End
//        alert.addAction(UIAlertAction(title: "End & Save", style: .default, handler: { _ in
//            self.saveRecoveredActivity(local)
//        }))
//        
//        // Discard
//        alert.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { _ in
//            LocalActivityStorage.shared.clear()
//        }))
//        
//        present(alert, animated: true)
//    }
//    func resumeActivity(_ local: LocalActivity) {
//        
//        // Prevent loop
//        LocalActivityStorage.shared.clear()
//        
//        let vc = ActivityLiveTrackingViewController(
//            nibName: "ActivityLiveTrackingViewController",
//            bundle: nil
//        )
//        
//        vc.recoveredActivity = local
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
//    }
//    
//    func saveRecoveredActivity(_ local: LocalActivity) {
//        
//        // You already HAVE the activity → nothing extra to save
//        
//        // Just clear temp storage
//        LocalActivityStorage.shared.clear()
//        
//        print("Recovered activity finalized")
//    }
//    
//    @IBAction func startButtonPressed() {
//        
//        let destinationVC = ActivitySetGoalViewController()
//        
//        if #available(iOS 26.0, *) {
//            destinationVC.modalPresentationStyle = .overFullScreen
//        }
//        
//        self.present(destinationVC, animated: true, completion: nil)
//                
//    }
//}
