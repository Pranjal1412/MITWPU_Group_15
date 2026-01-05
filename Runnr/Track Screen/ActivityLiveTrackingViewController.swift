//
//  RunStartedViewController.swift
//  Runnr
//
//  Created by SDC-USER on 14/11/25.
//

import UIKit
import GoogleMaps
import CoreMotion

class ActivityLiveTrackingViewController: UIViewController {

    @IBOutlet weak var viewCountdown: UIView!
    @IBOutlet weak var viewAllData: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var viewPace: UIView!
    @IBOutlet weak var viewHeartRate: UIView!
    @IBOutlet weak var viewDistance: UIView!
    @IBOutlet weak var buttonPause: UIButton!
    @IBOutlet weak var buttonEndRun: UIButton!
    @IBOutlet weak var buttonLockScroll: UIButton!
    @IBOutlet weak var labelTimeCountdown: UILabel!
    @IBOutlet weak var labelQuote: UILabel!
    
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelPace: UILabel!
    @IBOutlet weak var labelHeartRate: UILabel!
    
    @IBOutlet weak var labelTimeCounter: UILabel!
    @IBOutlet weak var labelPaceCounter: UILabel!
    @IBOutlet weak var labelHeartRateCounter: UILabel!
    @IBOutlet weak var labelDistanceCounter: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var viewActivityProgress: UIView!
    @IBOutlet var viewActivitySettings: UIView!
    @IBOutlet var viewActivityTrack: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    let userLocation = UserLocationManager()
    let mapManager = MapManager()
    var bounds = GMSCoordinateBounds()
    var activityManager: UserActivityManager!
    
    var scrollViewInitialized = false
    var isMapInitialized = false
    let topGradientView = UIView()
    
    var timer : Timer?
    var counter = 3
    var quotes: [String] = ["Starting Your Tracker...", "You Got This", "Lock in", "Lace Up"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        view.overrideUserInterfaceStyle = .dark
        
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        pageControl.isHidden = true
        
        settingScreenElements()
        settingPauseButtonImg()
        buttonEndRun.isHidden = true
        
        userLocation.locationManager.startUpdatingLocation()
        userLocation.activityStarted = true
        
        activityManager = UserActivityManager(timerLabel: self.labelTimeCounter)
        activityManager.activityTimeStamp()
        activityManager.startTimer()
        activityManager.startStepsTracking()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        userLocation.onLocationUpdate = { location in
        
            if self.isMapInitialized == false {
                                
                let mapView = self.mapManager.initializeMaps(withX: 20.0, withY: 70.0,
                                                             withWidth: self.view.frame.width - 40.0,
                                                             withHeight: self.view.frame.height - 100.0,
                                                             location: location.coordinate)
              
                self.mapManager.userLocationMarkerSetting(isEnabled: true)
                mapView.settings.rotateGestures = true
                mapView.settings.zoomGestures = true
                mapView.settings.scrollGestures = true
                self.viewActivityTrack.addSubview(mapView)
                
                self.mapManager.setRouteLineStyle()
                
                self.isMapInitialized = true
                
            }
            
//            let index = activities.count - 1
//            if activity[index].routeCoordinates.count() == 0 {
//                self.mapManager.addStartMarker(at: coordinate)
//            }
            
            if self.addCoordinateIfValid(location) {
                self.mapManager.path.add(location.coordinate)
                self.mapManager.routeLine.path = self.mapManager.path
                
                self.activityManager.startUpdatingDistance(with: location)
                self.labelDistanceCounter.text = String(format: "%.2f", self.activityManager.totalDistance)
            }
            
            self.activityManager.showLivePace(using: location)
            self.labelPaceCounter.text = String(format: "%.2f", self.activityManager.livePace)
            
            print("Path Count: \(self.mapManager.path.count())")
            
        }
        
        self.topGradientView.frame.size.width = self.view.bounds.width
        self.topGradientView.frame.size.height = 100.0
        self.topGradientView.frame.origin.y = 0.0
        self.topGradientView.frame.origin.x = 0.0
        addTopGradient(to: self.topGradientView)
        viewActivityTrack.addSubview(self.topGradientView)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.applyGradient(to: mapManager.mapView)
    }
        
    override func viewDidAppear(_ animated: Bool) {
        
        if self.scrollViewInitialized == false {
            settingHorizontalScroll()
            self.scrollViewInitialized = true
        }
        
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        
//        buttonEndRun.layer.borderWidth = 1.0
//        buttonEndRun.layer.borderColor = UIColor.accent.cgColor
        
        if buttonPause.tag == 0 {
            
            self.userLocation.locationManager.stopUpdatingLocation()
            self.activityManager.stopTimer()
            self.activityManager.stopStepsTracking()
            self.activityManager.stopUpdatingDistance()
            
            UIView.animate(withDuration: 0.5) {
                self.buttonPause.frame.origin.x = (UIScreen.main.bounds.width - (self.buttonPause.frame.width * 2) - 70.0)/2.0
                self.buttonPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
                self.buttonEndRun.isHidden = false
                self.buttonEndRun.frame.origin.x = (self.buttonPause.frame.origin.x + self.buttonPause.frame.width + 70.0)
            }
            
            self.convertPathToCoordinates(mapManager.path).forEach { coordinate in
                bounds = bounds.includingCoordinate(coordinate)
            }
            
            mapManager.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 70))
            self.mapManager.mapView.isMyLocationEnabled = false
            
            buttonPause.tag = 1
        }
        
        else if buttonPause.tag == 1 {
            
            self.userLocation.locationManager.startUpdatingLocation()
            self.activityManager.startTimer()
            self.activityManager.startStepsTracking()
            
            self.mapManager.mapView.isMyLocationEnabled = true
            
            UIView.animate(withDuration: 0.5) {
                self.buttonPause.frame.origin.x = (UIScreen.main.bounds.width - self.buttonPause.frame.width)/2.0
                self.buttonPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                
                self.buttonEndRun.frame.origin.x = (UIScreen.main.bounds.width - self.buttonPause.frame.width)/2.0
                
            }

            let lastCoordinate = self.mapManager.path.coordinate(at: self.mapManager.path.count() - 1)
            
            let cameraView = GMSCameraPosition(latitude: lastCoordinate.latitude, longitude: lastCoordinate.longitude, zoom: 15.0)
            
            mapManager.mapView.animate(to: cameraView)
            
            buttonPause.tag = 0

        }
        
    }
    
    @IBAction func EndRunButtonPressed(_ sender: UIButton) {
        
        self.userLocation.locationManager.stopUpdatingLocation()
        
        let alert = UIAlertController(title: String(localized: "End Run"),
                                      message: String(localized: "Are you sure you want to end this run?"), preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: String(localized: "Cancel"), style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let end = UIAlertAction(title: String(localized: "End Anyway"), style: .destructive, handler: { _ in
            
            self.userLocation.activityStarted = false
                        
            let newActivity = MyRunActivity(
                userName: "Ava Brooks",
                timeStamp: self.activityManager.timeStamp!,
                runTitle: "",
                distanceValue: self.activityManager.totalDistance,
                distanceUnit: "km",
                paceValue: self.activityManager.getAveragePace(),
                paceUnit: "/km",
                stepsValue: self.activityManager.totalSteps,
                caloriesValue: 123,
                timeHour: self.activityManager.hours,
                timeMin: self.activityManager.minutes,
                timeSec: self.activityManager.seconds,
                basePoints: self.activityManager.basePointsEarned(),
                skillPoints: self.activityManager.skillPointsEarned(),
                mapImage: self.captureMapImage(from: self.mapManager.mapView)!,
                note: "",
                isPublic: false,
                routeCoordinates: self.convertPathToCoordinates(self.mapManager.path))

            let destinationVC = ActivitySaveViewController()
            destinationVC.activityData = newActivity
            
            destinationVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
//            activities[activity.count - 1].activityStarted = false
            
//          here self.navigationController?.present(destinationVC, animated: true) doesn't add the screen inside the nav stack
//          it just presents above the navcontroller, and beacuse of which
//          self.navigationController?.dismiss(animated: true, completion: nil) was not working in SaveActivityViewController
            
        })
        
        alert.overrideUserInterfaceStyle = .dark
        alert.addAction(end)
        
        present(alert, animated: true , completion: nil)
        
    }
    
    @objc func updateTimer() {
        if counter < -1 {
            self.viewCountdown.isHidden = true
            self.scrollView.isScrollEnabled = true
            pageControl.isHidden = false
            timer?.invalidate()
            timer = nil
        }
        else if counter == -1 {
            self.labelTimeCountdown.text = "Go!"
            self.labelQuote.isHidden = true
        }
        else if counter == 0 {
            self.labelTimeCountdown.font = UIFont.systemFont(ofSize: 80, weight: .black)
            self.labelTimeCountdown.text = "Ready!"
            self.labelQuote.text = quotes[self.counter]
        }
        else {
            self.labelTimeCountdown.text = "\(Int(self.counter))"
            self.labelQuote.text = quotes[self.counter]
        }
        
        
        counter -= 1
    }
    
    func applyGradient(to view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds

        gradientLayer.colors = [
            UIColor.red.cgColor,
            UIColor.white.cgColor
        ]

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addCoordinateIfValid(_ newLocation: CLLocation) -> Bool {
        if mapManager.path.count() == 0 {
               return true
        }

        let lastCoordinate = mapManager.path.coordinate(at: mapManager.path.count() - 1)
        let lastLocation = CLLocation(latitude: lastCoordinate.latitude,
                                     longitude: lastCoordinate.longitude)

        let distance = newLocation.distance(from: lastLocation)  // distance here is in meters
        if distance > 4 {
            return true
        }
        
        return false
    }
    
    func settingScreenElements() {
        viewAllData.layer.cornerRadius = 20
        viewPace.layer.cornerRadius = 20
        viewHeartRate.layer.cornerRadius = 20
        viewTime.layer.cornerRadius = 20
        viewDistance.layer.cornerRadius = 20

        buttonLockScroll.layer.cornerRadius = buttonLockScroll.frame.height / 2
        
        buttonEndRun.frame.origin.x = (view.frame.width - buttonPause.frame.width) / 2
        buttonEndRun.frame.origin.y = viewDistance.frame.origin.y + viewDistance.frame.height + 50
        
        buttonPause.frame.origin.x = (view.frame.width - buttonPause.frame.width) / 2
        buttonPause.frame.origin.y = viewDistance.frame.origin.y + viewDistance.frame.height + 50
        
        labelDistance.font = UIFont(name: "SF Pro Medium", size: 18.0)
        labelDistance.text = String(localized: "Distance (Km)")
        labelDistance.sizeToFit()
        
        labelTime.font = UIFont(name: "SF Pro Medium", size: 18.0)
        labelTime.text = String(localized: "Time")
        labelTime.sizeToFit()
        
        labelPace.font = UIFont(name: "SF Pro Medium", size: 18.0)
        labelPace.text = String(localized: "Pace")
        labelPace.sizeToFit()
        
        labelHeartRate.font = UIFont(name: "SF Pro Medium", size: 18.0)
        labelHeartRate.text = String(localized: "Heart Rate")
        labelHeartRate.sizeToFit()
        
        labelPaceCounter.font = UIFont(name: "SF Pro Regular", size: 20)
        labelTimeCounter.font = UIFont(name: "SF Pro Regular", size: 55)
        labelDistanceCounter.font = UIFont(name: "SF Pro Regular", size: 128)
        labelHeartRateCounter.font = UIFont(name: "SF Pro Regular", size: 20)
        
    }
    
    func settingPauseButtonImg() {
        buttonPause.contentVerticalAlignment = .fill
        buttonPause.contentHorizontalAlignment = .fill
        buttonPause.layer.cornerRadius = buttonPause.frame.height / 2
        
        buttonEndRun.contentVerticalAlignment = .fill
        buttonEndRun.contentHorizontalAlignment = .fill
        buttonEndRun.layer.borderWidth = 1
        buttonEndRun.layer.borderColor = UIColor.accent.cgColor
        buttonEndRun.layer.cornerRadius = buttonEndRun.frame.height / 2
        
//        var pauseButtonConfig = UIButton.Configuration.plain()
//
//        pauseButtonConfig.image = UIImage(systemName: "pause.fill")
//        pauseButtonConfig.baseForegroundColor = .black
//
//        pauseButtonConfig.background.backgroundColor = .accent
//        pauseButtonConfig.background.cornerRadius = 20
//
//        pauseButtonConfig.contentInsets = NSDirectionalEdgeInsets(
//            top: 0,
//            leading: 0,
//            bottom: 0,
//            trailing: 0
//        )
//
//        buttonPause.configuration = pauseButtonConfig
//    
//        var endButtonConfig = UIButton.Configuration.plain()
//
//        endButtonConfig.image = UIImage(systemName: "square.fill")
//        endButtonConfig.baseForegroundColor = .accent
//
//        endButtonConfig.background.strokeColor = .accent
//        endButtonConfig.background.strokeWidth = 1
//        endButtonConfig.background.backgroundColor = .black
//        endButtonConfig.background.cornerRadius = buttonEndRun.frame.height / 2
//
//        endButtonConfig.contentInsets = NSDirectionalEdgeInsets(
//            top: 0,
//            leading: 0,
//            bottom: 0,
//            trailing: 0
//        )
//
//        buttonEndRun.configuration = endButtonConfig
        
        buttonPause.imageEdgeInsets = UIEdgeInsets(top: 32, left: 35, bottom: 32, right: 35)
        buttonEndRun.imageEdgeInsets = UIEdgeInsets(top: 38, left: 38, bottom: 38, right: 38)
    }
    
    func convertPathToCoordinates(_ path: GMSMutablePath) -> [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        
        for i in 0..<path.count() {
            coordinates.append(path.coordinate(at: i))
        }
        
        return coordinates
    }
    
    func captureMapImage(from mapView: GMSMapView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: mapView.bounds.size)

        return renderer.image { _ in
            mapView.drawHierarchy(in: mapView.bounds,afterScreenUpdates: true)
        }
    }

    
}

// MARK: - Page Control Code & Scroll View Setting

extension ActivityLiveTrackingViewController : UIScrollViewDelegate {
    
    func settingHorizontalScroll() {
        scrollView.alwaysBounceVertical = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.contentSize.width = view.frame.width * 3
        scrollView.contentSize.height = scrollView.frame.height
        
            for i in 0..<3 {
                let page = UIView(frame: CGRect(x: CGFloat(i) * view.frame.width, y: 0,
                                                width: scrollView.frame.width, height: scrollView.frame.height))
                page.backgroundColor = .yellow
                
                switch i {
                case 0:
                    self.viewActivityTrack.frame = CGRect(x: 0, y: 0, width: page.frame.width, height: page.frame.height)
                    page.addSubview(viewActivityTrack)
                    
                case 1:
                    self.viewActivityProgress.frame = CGRect(x: 0, y: 0, width: page.frame.width, height: page.frame.height)
                    
                    page.addSubview(self.viewActivityProgress)
                                                            
                case 2: 
                    self.viewActivitySettings.frame = CGRect(x: 0, y: 0, width: page.frame.width, height: page.frame.height)
                    page.addSubview(self.viewActivitySettings)
                    
                default: break
                }

                scrollView.addSubview(page)
            }
        scrollView.contentOffset = CGPoint(x: view.frame.width, y: 0)
    }
    
    @IBAction func toggleScrollingTapped(_ sender: UIButton) {
        scrollView.isScrollEnabled.toggle()
        
        let isUnlocked = scrollView.isScrollEnabled
        pageControl.isUserInteractionEnabled = isUnlocked
        
        if scrollView.isScrollEnabled {
            sender.setImage(UIImage(systemName: "lock.open.fill"), for: .normal)
        }
        else {
            sender.setImage(UIImage(systemName: "lock.fill"), for: .normal)
        }
    }
    
    @IBAction func pageValueChanged(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(currentPage) * view.frame.width, y: 0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / view.frame.width)
    }
    
    
}
