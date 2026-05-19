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
import Lottie
import Polyline
import Combine

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

    var lastAnnouncedKm = 0
    var audioPlayer: AVAudioPlayer?
    let speechSynthesizer = AVSpeechSynthesizer()

    let mapManager = MapManager()
    let userLocation = UserLocationManager()
    let userProfile = DataSource.shared.getUserProfile()

    let datasource = DataSource.shared
    var activityManager: UserActivityManager!
    let healthKitManager = HealthKitManager.shared
//    var bounds = GMSCoordinateBounds()

    var scrollViewInitialized = false
    var isMapInitialized = false
    var isAudioFeedbackOn = false
    let topGradientView = UIView()
    let bottomGradientView = UIView()
    let leftGradientView = UIView()
    let rightGradientView = UIView()
    var activityTypeSelected: ActivityType?

    var counter = 3
    var activityEndTime: Date?
    var activityStartTime: Date?
    var timer: Timer?
    var minGoalSet: Int?
    var hourGoalSet: Int?
    var distanceGoalSet: Double?
    var lastSavedTime: Date?

    var quotes: [String] = [String(localized: "You Got This"), String(localized: "Lock in"), String(localized: "Lace Up")]

    var recoveredActivity: LocalActivity?
    var hasRestoredActivity = false
    var isRunActive = false

    let loaderView = UIView()
    var lottieView: LottieAnimationView!
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupLoader()
        settingScreenElements()
        settingPauseButtonImg()

        userLocation.locationManager.startUpdatingLocation()

        // called every time app goes to background or when comes back from background
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)

        // called every time app is terminated
        NotificationCenter.default.addObserver(self, selector: #selector(appWillTerminate), name: UIApplication.willTerminateNotification, object: nil)

        activityManager = UserActivityManager(timerLabel: self.labelTimeCounter)

        if recoveredActivity == nil {
            self.activityStartTime = Date()
        }
        if recoveredActivity != nil {
            self.counter = -1
            self.isRunActive = true
        }

        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)

        WatchConnectivityManager.shared.$recentMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                if let heartRate = message["heartRate"] as? Double {
                    self?.labelHeartRateCounter.text = String(format: "%.0f", heartRate)
                }
            }
            .store(in: &cancellables)

        userLocation.onLocationUpdate = { location in

            if self.isMapInitialized == false {

                let mapView = self.mapManager.initializeMaps(withX: 0, withY: 0, withWidth: self.viewActivityTrack.frame.width,
                                                             withHeight: self.viewActivityTrack.frame.height, location: location.coordinate)

                self.mapManager.userLocationMarkerSetting(isEnabled: true)
                mapView.settings.rotateGestures = true
                mapView.settings.zoomGestures = true
                mapView.settings.scrollGestures = true
                self.viewActivityTrack.addSubview(mapView)
                self.settingMapGradients()

                self.mapManager.setRouteLineStyle()
                self.userLocation.locationManager.distanceFilter = 6
                self.isMapInitialized = true

                // restoring the complete activity here, the flag is used to ensure only once the below code is executed
                if let recovered = self.recoveredActivity, !self.hasRestoredActivity {
                    self.restoreActivity(recovered)
                    self.hasRestoredActivity = true

                    if self.mapManager.path.count() > 0 {
//                      Fetches the most recent GPS point
                        let last = self.mapManager.path.coordinate(at: self.mapManager.path.count() - 1)
                        let camera = GMSCameraPosition(latitude: last.latitude, longitude: last.longitude, zoom: 15)
                        self.mapManager.mapView.animate(to: camera)
                    }

                    return
                }
            }

            self.mapManager.path.add(location.coordinate)
            self.mapManager.routeLine.path = self.mapManager.path

            // periodic save at an interval of 10s
            let now = Date()
            if let last = self.lastSavedTime, now.timeIntervalSince(last) > 10 {
                self.lastSavedTime = now

                Task {
                    print("Inside save")
                    await self.saveActivityLocally()
                }
            }

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

            self.activityManager.startUpdatingElevation(with: location)
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

    @IBAction func pauseButtonPressed(_ sender: UIButton) {

        if buttonPause.tag == 0 {
            // Pause the run
            playAudioFile(named: "runPaused")
            self.userLocation.locationManager.stopUpdatingLocation()
            self.activityManager.stopTimer()
            self.activityManager.stopStepsTracking()
            self.activityManager.stopUpdatingDistance()
            self.activityManager.stopUpdatingElevation()

            self.mapManager.mapView.isMyLocationEnabled = false

            UIView.animate(withDuration: 0.5) {
                self.buttonPause.frame.origin.x = (UIScreen.main.bounds.width - (self.buttonPause.frame.width * 2) - 70.0)/2.0
                self.buttonPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
                self.buttonEndRun.isHidden = false
                self.buttonEndRun.frame.origin.x = (self.buttonPause.frame.origin.x + self.buttonPause.frame.width + 70.0)
            }

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

    // MARK: - Recovery
    func restoreActivity(_ local: LocalActivity) {

        self.activityTypeSelected = local.activity.activityType
        self.activityStartTime = local.activity.activityStartTime

        self.activityManager.totalDistance = local.activity.distanceCovered ?? 0
        self.activityManager.totalSteps = local.activity.stepsTaken ?? 0
        self.activityManager.paceGraphData = local.paceData

//        for coord in local.coordinates {
//            let coordinate = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
//            self.mapManager.path.add(coordinate)
//        }
        if let decodedPath = GMSPath(fromEncodedPath: local.activity.mapCoordinatesPolyline!),
           let mutablePath = decodedPath.mutableCopy() as? GMSMutablePath {
            mapManager.path = mutablePath
            mapManager.routeLine.path = mutablePath
            mapManager.setRouteLineStyle()
        }

//        self.mapManager.routeLine.path = self.mapManager.path

        let elapsed = local.activity.timeTakenSeconds ?? 0
        self.activityManager.restoreTime(seconds: elapsed)

        self.labelDistanceCounter.text = String(format: "%.2f", self.activityManager.totalDistance)
    }

    @IBAction func endRunButtonPressed(_ sender: UIButton) {

        self.activityEndTime = Date()
        guard let nav = self.navigationController else {
            print("No navigation controller on button press")
            return
        }

        let alert = UIAlertController(
            title: String(localized: "End Run"),
            message: String(localized: "Are you sure you want to end this run?"),
            preferredStyle: .alert
        )

        let cancel = UIAlertAction(title: String(localized: "Cancel"), style: .cancel, handler: nil)
        alert.addAction(cancel)

        let end = UIAlertAction(title: "End", style: .destructive) { _ in

            self.loaderView.isHidden = false
            self.lottieView.play()

            self.userLocation.locationManager.stopUpdatingLocation()
            self.activityManager.stopUpdatingElevation()
            self.activityManager.stopTimer()
            self.checkIfGoalSetAndCompleted()

// MARK: - check this audio file
            self.playAudioFile(named: "runCompleted")

            let mapSnapshot = self.captureMapImage(from: self.mapManager.mapView)

            let paceGraphData = self.activityManager.paceGraphData
            let path = self.mapManager.path
            let healthKit = self.healthKitManager
            let estimatedCalories = self.activityManager.estimatedCalories(activityType: self.activityTypeSelected ?? .running)

            var activityDetails = UserActivity(
                userID: self.userProfile.userID,
                activityStartTime: self.activityStartTime ?? Date(),
                activityEndTime: self.activityEndTime ?? Date(),
                activityTitle: "",
                activityType: self.activityTypeSelected ?? .running,
                activityRemark: "",
                isPublic: false,
                distanceCovered: self.activityManager.totalDistance,
                distanceUnit: .kilometers,
                timeTakenSeconds: self.activityManager.getTotalTime(),
                caloriesBurnt: estimatedCalories,
                stepsTaken: self.activityManager.totalSteps,
                avgHeartRate: nil,
                avgPace: self.activityManager.getAveragePace(),
                paceUnit: .minPerKm,
                mapImageURL: "",
                basePoints: self.activityManager.basePointsEarned(),
                skillPoints: self.activityManager.skillPointsEarned(),
                elevation: self.activityManager.getTotalElevation(),
                mapCoordinatesPolyline: self.convertToPolylineString(path: path)
            )

            // Use the pre-captured nav reference — no longer depends on self.navigationController
            Task {
                guard let userID = self.userProfile.userID else {
                    print("Missing userID — cannot save activity")
                    return
                }

                print("Background save started")

                let avgHR = await healthKit.fetchAverageHeartRateAsync(from: activityDetails.activityStartTime!, to: activityDetails.activityEndTime!)
                let calories = await healthKit.fetchCaloriesAsync(from: activityDetails.activityStartTime!, to: activityDetails.activityEndTime!)

                activityDetails.avgHeartRate = avgHR
                activityDetails.caloriesBurnt = calories > 0 ? Int(calories) : estimatedCalories

                activityDetails = await insertActivity(activityDetails) ?? activityDetails

                // Only save to DB if insert succeeded and we have an activityID
                if let activityID = activityDetails.activityID {

                    if let image = mapSnapshot {
                        let mapImageURL = await saveMapImage(activityID: activityID, with: image)
                        activityDetails.mapImageURL = mapImageURL
                        await updateUserActivity(newActivity: activityDetails)
                    }

                    var updatedPaceData = paceGraphData
                    for index in 0..<updatedPaceData.count {
                        updatedPaceData[index].activityID = activityID
                    }

                    await insertActivityPaceGraphData(updatedPaceData)
                }

                await MainActor.run {
                    self.lottieView.stop()
                    self.loaderView.isHidden = true
                }

                self.isRunActive = false
                LocalActivityStorage.shared.clear()
                let destinationVC = ActivitySaveViewController(nibName: "ActivitySaveViewController", bundle: nil)
                destinationVC.activityData = activityDetails

                await MainActor.run {
                    nav.pushViewController(destinationVC, animated: true)
                }

                print("Background save completed")
            }
        }

        alert.addAction(end)
        self.present(alert, animated: true, completion: nil)
    }

    @objc func updateTimer() {
        if counter < 0 {
            self.isRunActive = true
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

    @objc func appWillTerminate() {
        guard isRunActive else { return }
        Task { await self.saveActivityLocally() }
    }

    func saveActivityLocally() async {

        guard let startTime = self.activityStartTime else {
            print("No start time, not saving")
            return
        }

        let activity = UserActivity(
            userID: self.userProfile.userID,
            activityID: nil,

            activityStartTime: startTime,
            activityEndTime: Date(),

            activityTitle: self.datasource.getCurrentActivity()?.activity?.activityTitle ?? "",
            activityType: self.activityTypeSelected ?? .running,
            activityRemark: self.datasource.getCurrentActivity()?.activity?.activityRemark ?? "",
            isPublic: self.datasource.getCurrentActivity()?.activity?.isPublic ?? false,

            distanceCovered: self.activityManager.totalDistance,
            distanceUnit: .kilometers,

            timeTakenSeconds: self.activityManager.getTotalTime(),
            caloriesBurnt: 0,
            stepsTaken: self.activityManager.totalSteps,

            avgHeartRate: nil,
            avgPace: self.activityManager.getAveragePace(),
            paceUnit: .minPerKm,

            mapImageURL: "",
            basePoints: self.activityManager.basePointsEarned(),
            skillPoints: self.activityManager.skillPointsEarned(),

            elevation: self.activityManager.getTotalElevation(),
            mapCoordinatesPolyline: self.convertToPolylineString(path: self.mapManager.path)
        )

        let local = LocalActivity(activity: activity, paceData: self.activityManager.paceGraphData)

        do {
            LocalActivityStorage.shared.save(local)
            print("Activity saved locally")
        } catch {
            print("FAILED TO ENCODE LOCAL ACTIVITY:", error)
        }
    }

    @objc func appMovedToBackground() {
        guard isRunActive else { return }
        Task {
            await self.saveActivityLocally()
        }
    }

    func captureMapImage(from mapView: GMSMapView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: mapView.bounds.size)

        return renderer.image { _ in
            mapView.drawHierarchy(in: mapView.bounds, afterScreenUpdates: true)
        }
    }

    func assignActivityIDToPaceData() {

        guard let activityID = datasource.getCurrentActivity()?.activity?.activityID else { return }

        for loop in 0 ..< activityManager.paceGraphData.count {
            activityManager.paceGraphData[loop].activityID = activityID
        }
    }

    func setupLoader() {
        loaderView.frame = view.bounds
        loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        lottieView = LottieAnimationView(name: "Run_Forrest_Run")
        lottieView.loopMode = .loop
        lottieView.contentMode = .scaleAspectFit
        lottieView.translatesAutoresizingMaskIntoConstraints = false

        loaderView.addSubview(lottieView)
        view.addSubview(loaderView)

        NSLayoutConstraint.activate([
            lottieView.centerXAnchor.constraint(equalTo: loaderView.centerXAnchor),
            lottieView.centerYAnchor.constraint(equalTo: loaderView.centerYAnchor),
            lottieView.widthAnchor.constraint(equalToConstant: 150),
            lottieView.heightAnchor.constraint(equalToConstant: 150)
        ])

        loaderView.isHidden = true
    }
}
// MARK: - Page Control Code & Scroll View Setting

extension ActivityLiveTrackingViewController: UIScrollViewDelegate {

    func settingHorizontalScroll() {
        scrollView.alwaysBounceVertical = false
        scrollView.showsVerticalScrollIndicator = false

        scrollView.contentSize.width = view.frame.width * 2
        scrollView.contentSize.height = scrollView.frame.height

            for index in 0..<2 {
                let page = UIView(frame: CGRect(x: CGFloat(index) * view.frame.width, y: 0,
                                                width: scrollView.frame.width, height: scrollView.frame.height))
                page.backgroundColor = .yellow

                switch index {
                case 0:
                    self.viewActivityTrack.frame = CGRect(x: 0, y: 0, width: page.frame.width, height: page.frame.height)
                    page.addSubview(viewActivityTrack)

                case 1:
                    self.viewActivityProgress.frame = CGRect(x: 0, y: 0, width: page.frame.width, height: page.frame.height)
                    page.addSubview(self.viewActivityProgress)

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

// MARK: - UI Elements Setting Functions
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

        self.bottomGradientView.frame.size.height = 30
        self.bottomGradientView.frame.size.width = self.view.frame.size.width
        self.bottomGradientView.frame.origin.y = view.frame.height - 10
        self.bottomGradientView.frame.origin.x = 0
        addBottomGradient(to: self.bottomGradientView)
        self.viewActivityTrack.addSubview(self.bottomGradientView)

        self.leftGradientView.frame.size.height = self.view.frame.size.height
        self.leftGradientView.frame.size.width = 45
        self.leftGradientView.frame.origin.y = 0
        self.leftGradientView.frame.origin.x = 0
        addLeadingToTrailingGradient(to: self.leftGradientView)
        self.viewActivityTrack.addSubview(self.leftGradientView)

        self.rightGradientView.frame.size.height = self.view.frame.size.height
        self.rightGradientView.frame.size.width = 45
        self.rightGradientView.frame.origin.y = 0
        self.rightGradientView.frame.origin.x = self.view.frame.size.width - self.leftGradientView.frame.size.width
        addTrailingToLeadingGradient(to: self.rightGradientView)
        self.viewActivityTrack.addSubview(self.rightGradientView)
    }

    func convertToPolylineString(path: GMSMutablePath) -> String {
        var coords: [CLLocationCoordinate2D] = []

        for index in 0..<path.count() {
            coords.append(path.coordinate(at: index))
        }
        // converts CLLocationCoordinate2D into a Encoded polyline string
        let polylineString = Polyline(coordinates: coords).encodedPolyline
        print(polylineString)

        return polylineString
    }
}

// MARK: - Audio Feedback Functions
extension ActivityLiveTrackingViewController {

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

    func announceAveragePace(_ pace: Double) {
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

    func checkIfGoalSetAndCompleted() {

        guard let distanceGoal = self.distanceGoalSet else {
            return
        }

        if distanceGoal > 0.0 {

            let totalTimeSet = (hourGoalSet ?? 0) * 60 + (minGoalSet ?? 0)

            if totalTimeSet > 0 {

                let totalTimeElapsed = activityManager.minutes
                    + activityManager.hours * 60
                    + activityManager.seconds / 60

                if totalTimeElapsed <= totalTimeSet &&
                    activityManager.totalDistance >= distanceGoal {

                    self.playAudioFile(named: "youHaveCompletedTodaysGoal")
                }
                else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        guard self.isAudioFeedbackOn else { return }

                        let utterance = AVSpeechUtterance(string: "You have not met your goal")
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-gb")
                        utterance.rate = 0.5
                        self.speechSynthesizer.speak(utterance)
                    }
                }
            }
            else {

                if activityManager.totalDistance >= distanceGoal {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        guard self.isAudioFeedbackOn else { return }

                        let utterance = AVSpeechUtterance(string: "Distance goal met!")
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-gb")
                        utterance.rate = 0.5
                        self.speechSynthesizer.speak(utterance)
                    }
                }
                else {
                    let remainingDistance = distanceGoal - activityManager.totalDistance

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

//        var coords: [ActivityRouteCoordinates] = []
//
//        for i in 0..<self.mapManager.path.count() {
//            let c = self.mapManager.path.coordinate(at: i)
//            coords.append(ActivityRouteCoordinates(activityID: nil, latitude: c.latitude, longitude: c.longitude, sequence: Int(i)))
//        }

//    func convertGMSMutablePathAndInsert(_ path: GMSMutablePath, activityID: UUID) async {
//
//        var routeCoordinates: [ActivityRouteCoordinates] = []
//
//        for i in 0..<path.count() {
//            let coordinate = path.coordinate(at: i)
//
//            routeCoordinates.append(
//                ActivityRouteCoordinates(activityID: activityID, latitude: coordinate.latitude, longitude: coordinate.longitude, sequence: Int(i)))
//        }
//
//        await insertActivityRouteCoordinates(routeCoordinates)
//        self.datasource.setCurrentActivityCoordinates(routeCoordinates)
//    }
