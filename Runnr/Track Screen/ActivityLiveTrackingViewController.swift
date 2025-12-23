//
//  RunStartedViewController.swift
//  Runnr
//
//  Created by SDC-USER on 14/11/25.
//

import UIKit
import GoogleMaps

class ActivityLiveTrackingViewController: UIViewController {

    @IBOutlet weak var viewAllData: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var viewPace: UIView!
    @IBOutlet weak var viewHeartRate: UIView!
    @IBOutlet weak var viewDistance: UIView!
    @IBOutlet weak var buttonPause: UIButton!
    @IBOutlet weak var buttonEndRun: UIButton!
    @IBOutlet weak var buttonLockScroll: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        view.overrideUserInterfaceStyle = .dark
        
        scrollView.delegate = self
        
        settingScreenElements()
        settingPauseButtonImg()
        buttonEndRun.isHidden = true
        
        userLocation.locationManager.startUpdatingLocation()
        userLocation.activityStarted = true
        
        activityManager = UserActivityManager(timerLabel: self.labelTimeCounter)
        activityManager.activityTimeStamp()
        activityManager.startTimer()
        
        userLocation.onLocationUpdate = { coordinate in
        
            if self.isMapInitialized == false {
                                
                let mapView = self.mapManager.initializeMaps(withX: 20.0, withY: 70.0,
                                                             withWidth: self.view.frame.width - 40.0,
                                                             withHeight: self.view.frame.height - 100.0,
                                                             location: coordinate)
              
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
            
            self.mapManager.path.add(coordinate)
            self.mapManager.routeLine.path = self.mapManager.path
            
            let formatted = String(format: "%.2f", self.userLocation.totalDistance / 1000)
            self.labelDistanceCounter.text = "\(formatted)"
            
            print("Path Count: \(self.mapManager.path.count())")
            
        }
    }
        
    override func viewDidAppear(_ animated: Bool) {
        
        if self.scrollViewInitialized == false {
            settingHorizontalScroll()
            self.scrollViewInitialized = true
        }
        
    }

    func settingScreenElements() {
        viewAllData.layer.cornerRadius = 20
        viewPace.layer.cornerRadius = 20
        viewHeartRate.layer.cornerRadius = 20
        viewTime.layer.cornerRadius = 20
        viewDistance.layer.cornerRadius = 20
        
        buttonPause.layer.cornerRadius = buttonPause.frame.height / 2
        buttonEndRun.layer.cornerRadius = buttonEndRun.frame.height / 2
        buttonLockScroll.layer.cornerRadius = buttonLockScroll.frame.height / 2
        
        buttonEndRun.frame.origin.x = (view.frame.width - buttonPause.frame.width) / 2
        buttonEndRun.frame.origin.y = viewDistance.frame.origin.y + viewDistance.frame.height + 50
        
        buttonPause.frame.origin.x = (view.frame.width - buttonPause.frame.width) / 2
        buttonPause.frame.origin.y = viewDistance.frame.origin.y + viewDistance.frame.height + 50
        
        labelDistance.font = UIFont(name: "SF Pro Medium", size: 18.0)
        labelDistance.text = NSLocalizedString("Distance (Km)", comment: "")
        labelDistance.sizeToFit()
        
        labelTime.font = UIFont(name: "SF Pro Medium", size: 18.0)
        labelTime.text = NSLocalizedString("Time", comment: "")
        labelTime.sizeToFit()
        
        labelPace.font = UIFont(name: "SF Pro Medium", size: 18.0)
        labelPace.text = NSLocalizedString("Pace", comment: "")
        labelPace.sizeToFit()
        
        labelHeartRate.font = UIFont(name: "SF Pro Medium", size: 18.0)
        labelHeartRate.text = NSLocalizedString("Heart Rate", comment: "")
        labelHeartRate.sizeToFit()
        
        labelPaceCounter.font = UIFont(name: "SF Pro Regular", size: 20)
        labelTimeCounter.font = UIFont(name: "SF Pro Regular", size: 55)
        labelDistanceCounter.font = UIFont(name: "SF Pro Regular", size: 128)
        labelHeartRateCounter.font = UIFont(name: "SF Pro Regular", size: 20)
        
    }
    
    func settingPauseButtonImg() {
        buttonPause.contentVerticalAlignment = .fill
        buttonPause.contentHorizontalAlignment = .fill
//        buttonPause.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 50, bottom: 50, trailing: 50)
        buttonPause.imageEdgeInsets = UIEdgeInsets(top: 32, left: 35, bottom: 32, right: 35)
        
        buttonEndRun.contentVerticalAlignment = .fill
        buttonEndRun.contentHorizontalAlignment = .fill
//        buttonEndRun.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 38, leading: 38, bottom: 38, trailing: 38)
        buttonEndRun.imageEdgeInsets = UIEdgeInsets(top: 38, left: 38, bottom: 38, right: 38)
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        
        buttonEndRun.layer.borderWidth = 1.0
        buttonEndRun.layer.borderColor = UIColor.accent.cgColor
        
        if buttonPause.tag == 0 {
            
            self.userLocation.locationManager.stopUpdatingLocation()
            self.activityManager.stopTimer()
            
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
        
        let alert = UIAlertController(title: NSLocalizedString("End Run", comment: ""),
                                      message: NSLocalizedString("Are you sure you want to end this run?", comment: ""), preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let end = UIAlertAction(title: NSLocalizedString("End Anyway", comment: ""), style: .destructive, handler: { _ in
            
            self.userLocation.activityStarted = false
                        
            let destinationVC = ActivitySaveViewController()
            destinationVC.activityRouteCoordinates = self.convertPathToCoordinates(self.mapManager.path) // track coordinates
            destinationVC.activityMapImage = self.captureMapImage(from: self.mapManager.mapView) // map Image
            destinationVC.activityTimeStamp = self.activityManager.timeStamp //date of the activity
            destinationVC.activityTotalDistance = String(format: "%.2f", self.userLocation.totalDistance / 1000)
            destinationVC.activityTotalHours = String(format: "%02d", self.activityManager.hours)
            destinationVC.activityTotalMins = String(format: "%02d", self.activityManager.minutes)
            destinationVC.activityTotalSec = String(format: "%02d", self.activityManager.seconds)
            
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
