//
//  RunStartedViewController.swift
//  Runnr
//
//  Created by SDC-USER on 14/11/25.
//

import UIKit
import GoogleMaps
import CoreMotion
import AVFoundation

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
    @IBOutlet weak var switchAudioFeedback: UISwitch!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    var audioPlayer: AVAudioPlayer?
    var lastAnnouncedKm = 0
    
    let datasource = DataSource.shared
    let userProfile = DataSource.shared.getUserProfile()
    let userLocation = UserLocationManager()
    let mapManager = MapManager()
    var activityManager: UserActivityManager!
    let healthKitManager = HealthKitManager.shared
//    var bounds = GMSCoordinateBounds()
    
    
    var scrollViewInitialized = false
    var isMapInitialized = false
    var isAudioFeedbackOn = false
    let topGradientView = UIView()
    let bottomGradientView = UIView()
    let leftGradientView = UIView()
    var activityTypeSelected : ActivityType?
    
    var activityStartTime: Date?
    var activityEndTime: Date?
    var timer : Timer?
    var counter = 3
    var quotes: [String] = [String(localized: "You Got This"), String(localized: "Lock in"), String(localized: "Lace Up")]
    var distanceGoalSet : Double?
    var minGoalSet : Int?
    var hourGoalSet : Int?
    
    private var currentActivity: UserActivity?
    var isActivityInserted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingScreenElements()
        settingPauseButtonImg()
        
        userLocation.locationManager.startUpdatingLocation()
        
        
        self.currentActivity = UserActivity()
        self.currentActivity?.userID = self.userProfile.userID
        
        Task {
            self.currentActivity = await insertActivity(self.currentActivity!)
            self.datasource.setCurrentActivityID((self.currentActivity?.activityID!)!)
            self.isActivityInserted = true
        }
        
        activityManager = UserActivityManager(timerLabel: self.labelTimeCounter)
        self.activityStartTime = Date()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        userLocation.onLocationUpdate = { location in
            
            if self.isMapInitialized == false {
                
                let mapView = self.mapManager.initializeMaps(withX: 5, withY: 0,
                                                             withWidth: self.viewActivityTrack.frame.width - 40.0,
                                                             withHeight: self.viewActivityTrack.frame.height - 5,
                                                             location: location.coordinate)
                
                self.mapManager.userLocationMarkerSetting(isEnabled: true)
                mapView.settings.rotateGestures = true
                mapView.settings.zoomGestures = true
                mapView.settings.scrollGestures = true
                self.viewActivityTrack.addSubview(mapView)
                self.settingMapGradients()
                
                self.mapManager.setRouteLineStyle()
                self.userLocation.locationManager.distanceFilter = 6
                self.isMapInitialized = true
                
            }
            
            self.mapManager.path.add(location.coordinate)
            self.mapManager.routeLine.path = self.mapManager.path
            
            self.activityManager.startUpdatingDistance(with: location)
            self.labelDistanceCounter.text = String(format: "%.2f", self.activityManager.totalDistance)
            
            let currentKm = Int(self.activityManager.totalDistance)
            
            if currentKm > self.lastAnnouncedKm {
                self.lastAnnouncedKm = currentKm
                self.announceKilometer(currentKm)
                self.announceAveragePace(self.activityManager.getAveragePace())
            }
            
            self.activityManager.showLivePace(using: location)
            self.labelPaceCounter.text = String(format: "%.2f", self.activityManager.currentPace)
            
            print("Path Count: \(self.mapManager.path.count())")
            
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .spokenAudio,
                options: [.duckOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if self.scrollViewInitialized == false {
            settingHorizontalScroll()
            self.scrollViewInitialized = true
        }
        
    }
    func playAudioFile(named name: String) {
        guard isAudioFeedbackOn else { return }
        
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Missing audio file:", name)
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Audio playback error")
        }
    }
    
    func announceRunStarted() {
        playAudioFile(named: "runStarted")
    }
    func announceAveragePace(_ pace: Double){
        playAudioFile(named: "yourAveragePaceIs")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            guard self.isAudioFeedbackOn else { return }
            
            let utterance = AVSpeechUtterance(string: "\(pace) per kilometer")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.5
            self.speechSynthesizer.speak(utterance)
        }
    }
    func announceKilometer(_ km: Int) {
        playAudioFile(named: "youHaveCompleted")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            guard self.isAudioFeedbackOn else { return }
            
            let utterance = AVSpeechUtterance(string: "\(km) kilometers")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.5
            self.speechSynthesizer.speak(utterance)
        }
    }
    
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        
        if buttonPause.tag == 0 {
            // Pause the run
            playAudioFile(named: "runPaused")
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
            
//            Fit map to route
//            self.convertPathToCoordinates(mapManager.path).forEach { coordinate in
//                bounds = bounds.includingCoordinate(coordinate)
//            }
//            
//            mapManager.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 70))
//            self.mapManager.mapView.isMyLocationEnabled = false
//            
            buttonPause.tag = 1
        }
        
        else if buttonPause.tag == 1 {
            // Resume the run
            playAudioFile(named: "runResumed")
            self.userLocation.locationManager.startUpdatingLocation()
            self.activityManager.startTimer()
            self.activityManager.startStepsTracking()
            self.mapManager.mapView.isMyLocationEnabled = true
            
            UIView.animate(withDuration: 0.5) {
                self.buttonPause.frame.origin.x = (UIScreen.main.bounds.width - self.buttonPause.frame.width)/2.0
                self.buttonPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                self.buttonEndRun.frame.origin.x = (UIScreen.main.bounds.width - self.buttonPause.frame.width)/2.0
            }
            
            // Safe check for last coordinate
            if self.mapManager.path.count() > 0 {
                let lastCoordinate = self.mapManager.path.coordinate(at: self.mapManager.path.count() - 1)
                let cameraView = GMSCameraPosition(latitude: lastCoordinate.latitude, longitude: lastCoordinate.longitude, zoom: 15.0)
                mapManager.mapView.animate(to: cameraView)
            } else {
                print("Warning: No coordinates in path yet.")
            }
            
            buttonPause.tag = 0
        }
        
    }
    
    @IBAction func EndRunButtonPressed(_ sender: UIButton) {
        
        self.userLocation.locationManager.stopUpdatingLocation()
        self.checkIfGoalSetAndCompleted()
        
        if self.isActivityInserted == true {
            let alert = UIAlertController(title: String(localized: "End Run"),
                                          message: String(localized: "Are you sure you want to end this run?"), preferredStyle: .alert)
            let cancel = UIAlertAction(title: String(localized: "Cancel"), style: .cancel, handler: nil)
            alert.addAction(cancel)

            let end = UIAlertAction(title: "End Anyway", style: .destructive) { _ in
    //            The reason why complete thing is in Task is because heart rate and acitivty insertion and image does not happen one after the other the happen simultaneously so to avoid the bug and to avoid navigating to next screen before the data is available everything should be in Task
                Task {
                    self.playAudioFile(named: "runCompleted")
                    self.activityEndTime = Date()

                    self.currentActivity?.activityStartTime = self.activityStartTime!
                    self.currentActivity?.activityEndTime = self.activityEndTime!
                    self.currentActivity?.activityTitle = ""
                    self.currentActivity?.activityRemark = ""
                    self.currentActivity?.isPublic = false
                    self.currentActivity?.activityType = self.activityTypeSelected!
                    self.currentActivity?.distanceCovered = self.activityManager.totalDistance
                    self.currentActivity?.distanceUnit = .kilometers
                    self.currentActivity?.timeTakenSeconds = self.activityManager.getTotalTime()
                    self.currentActivity?.caloriesBurnt = 123
                    self.currentActivity?.stepsTaken = self.activityManager.totalSteps
                    self.currentActivity?.avgHeartRate = nil
                    self.currentActivity?.avgPace = self.activityManager.getAveragePace()
                    self.currentActivity?.paceUnit = .minPerKm
                    self.currentActivity?.mapImageURL = ""
                    self.currentActivity?.basePoints = self.activityManager.basePointsEarned()
                    self.currentActivity?.skillPoints = self.activityManager.skillPointsEarned()
                    
                    
                    // Get Map image URL
//                    if let image = self.captureMapImage(from: self.mapManager.mapView) {
//                        self.currentActivity!.mapImageURL = try await SupabaseManager.shared.createMapImageURL(image, activityID: self.currentActivity.activityID)
//                    }

                    // get Heart rate
                    let avgHR = await self.healthKitManager.fetchAverageHeartRateAsync(from: self.activityStartTime!, to: self.activityEndTime!)
                    self.currentActivity!.avgHeartRate = avgHR
                    
                    let caloriesBurnt = await
                        self.healthKitManager.fetchCaloriesAsync(from: self.activityStartTime!, to: self.activityEndTime!)
                    self.currentActivity!.caloriesBurnt = Int(caloriesBurnt)
                    
                    await self.convertGMSMutablePathAndInsert(self.mapManager.path, activityID: self.currentActivity!.activityID!)
                    
                    DispatchQueue.main.async {
                        let destinationVC = ActivitySaveViewController()
                        destinationVC.activityData = self.currentActivity
                        self.navigationController?.pushViewController(destinationVC, animated: true)
                    }
                }
            }
            
            alert.addAction(end)
            present(alert, animated: true , completion: nil)
        }
        
        else {
            let alert = UIAlertController(
                  title: String(localized: "Ending Run"),
                  message: String(localized: "Finalizing your activity…"),
                  preferredStyle: .alert
              )

              let spinner = UIActivityIndicatorView(style: .medium)
              spinner.translatesAutoresizingMaskIntoConstraints = false
              spinner.startAnimating()

              alert.view.addSubview(spinner)

              NSLayoutConstraint.activate([
                  spinner.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
                  spinner.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20)
              ])

            present(alert, animated: true , completion: nil)

        }
        
    }
    
    @objc func updateTimer() {
        if counter < 0 {
            self.viewCountdown.isHidden = true
            self.scrollView.isScrollEnabled = true
            pageControl.isHidden = false
            
            self.activityManager.startTimer()
            self.activityManager.startStepsTracking()
            self.announceRunStarted()
            
            timer?.invalidate()
            timer = nil
        }
        else if counter == 0 {
            self.labelTimeCountdown.font = UIFont.systemFont(ofSize: 80, weight: .black)
            self.labelTimeCountdown.text = "Go!"
            self.labelQuote.isHidden = true
        }
        else {
            self.labelTimeCountdown.text = "\(Int(self.counter))"
            self.labelQuote.text = quotes[self.counter - 1]
        }
        
        
        counter -= 1
    }
        
    func convertGMSMutablePathAndInsert(_ path: GMSMutablePath, activityID: UUID) async {

        var routeCoordinates: [ActivityRouteCoordinates] = []

        for i in 0..<path.count() {
            let coordinate = path.coordinate(at: i)

            routeCoordinates.append(
                ActivityRouteCoordinates(activityID: activityID, latitude: coordinate.latitude, longitude: coordinate.longitude, sequence: Int(i)))
        }

        await insertActivityRouteCoordinates(routeCoordinates)
    }

    
    func captureMapImage(from mapView: GMSMapView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: mapView.bounds.size)
        
        return renderer.image { _ in
            mapView.drawHierarchy(in: mapView.bounds,afterScreenUpdates: true)
        }
    }
    
    func checkIfGoalSetAndCompleted() {
        if self.distanceGoalSet! > 0.0 {
            let totalTimeSet = hourGoalSet! * 60 + minGoalSet!
            
            if totalTimeSet > 0 {
                let totalTimeElapsed = activityManager.minutes + activityManager.hours * 60 + activityManager.seconds/60
                
                if totalTimeElapsed <= totalTimeSet && activityManager.totalDistance >= distanceGoalSet!{
                    self.playAudioFile(named: "youHaveCompletedTodaysGoal")
                }
                else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        guard self.isAudioFeedbackOn else { return }
                        let utterance = AVSpeechUtterance(string: "You have not met your goal")
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-gb")
                        utterance.rate = 0.5
                        self.speechSynthesizer.speak(utterance)
                    }
                }
            }
            else{
                if activityManager.totalDistance >= distanceGoalSet! {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        guard self.isAudioFeedbackOn else { return }
                        let utterance = AVSpeechUtterance(string: "Distance goal met!")
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-gb")
                        utterance.rate = 0.5
                        self.speechSynthesizer.speak(utterance)
                    }
                    //self.playAudioFile(named: "keepGoing")
                }
                else{
                    let remainingDistance = distanceGoalSet! - activityManager.totalDistance
                    self.playAudioFile(named: "youAreAlmostThere")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        guard self.isAudioFeedbackOn else { return }
                        let utterance = AVSpeechUtterance(string: "\(remainingDistance) left")
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-gb")
                        utterance.rate = 0.5
                        self.speechSynthesizer.speak(utterance)
                    }
                }
            }
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

extension ActivityLiveTrackingViewController {
    func settingScreenElements() {
        navigationItem.hidesBackButton = true
        buttonEndRun.isHidden = true
        
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        pageControl.isHidden = true
        self.switchAudioFeedback.isOn = isAudioFeedbackOn
        
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
        
        buttonPause.imageEdgeInsets = UIEdgeInsets(top: 32, left: 35, bottom: 32, right: 35)
        buttonEndRun.imageEdgeInsets = UIEdgeInsets(top: 38, left: 38, bottom: 38, right: 38)
    }
    
    func settingMapGradients() {
        self.topGradientView.frame.size.height = 200
        self.topGradientView.frame.size.width = self.view.frame.size.width
        self.topGradientView.frame.origin.y = 0
        self.topGradientView.frame.origin.x = 0
        addTopGradient(to: self.topGradientView)
        self.viewActivityTrack.addSubview(self.topGradientView)
        
        self.bottomGradientView.frame.size.height = 10
        self.bottomGradientView.frame.size.width = self.view.frame.size.width
        self.bottomGradientView.frame.origin.y = view.frame.height - 10
        self.bottomGradientView.frame.origin.x = 0
        addBottomGradient(to: self.bottomGradientView)
        self.viewActivityTrack.addSubview(self.bottomGradientView)
        
        self.leftGradientView.frame.size.height = self.view.frame.size.height
        self.leftGradientView.frame.size.width = 100
        self.leftGradientView.frame.origin.y = 0
        self.leftGradientView.frame.origin.x = 0
        addLeadingToTrailingGradient(to: self.leftGradientView)
        self.viewActivityTrack.addSubview(self.leftGradientView)
    }
}
