//
//  RunStartedViewController.swift
//  Runnr
//
//  Created by SDC-USER on 14/11/25.
//

import UIKit
import GoogleMaps

class RunStartedViewController: UIViewController {

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
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    let userLocation = UserLocationManager()
    var pageControlInitialized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        view.overrideUserInterfaceStyle = .dark
        
        scrollView.delegate = self
        settingScreenElements()
        settingPauseButtonImg()
        buttonEndRun.isHidden = true
        
        userLocation.requestLocation()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        
        if self.pageControlInitialized == false {
            settingHorizontalScroll()
            self.pageControlInitialized = true
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
        
        buttonPause.frame.origin.x = (view.frame.width - buttonPause.frame.width) / 2
        
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
        buttonPause.imageEdgeInsets = UIEdgeInsets(top: 32, left: 35, bottom: 32, right: 35)
        
        buttonEndRun.contentVerticalAlignment = .fill
        buttonEndRun.contentHorizontalAlignment = .fill
        buttonEndRun.imageEdgeInsets = UIEdgeInsets(top: 38, left: 38, bottom: 38, right: 38)
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        
//        print("pause button pressed")
//        let nextVC = RunPausedViewController(nibName: "RunPausedViewController", bundle: nil)
//        self.navigationController?.pushViewController(nextVC, animated: false)
        
        buttonEndRun.layer.borderWidth = 1.0
        buttonEndRun.layer.borderColor = UIColor.accent.cgColor
        
        if buttonPause.tag == 0 {
            
            self.userLocation.stopLocation()
            
            UIView.animate(withDuration: 0.5) {
                self.buttonPause.frame.origin.x = (UIScreen.main.bounds.width - (self.buttonPause.frame.width * 2) - 70.0)/2.0
                self.buttonPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
                self.buttonEndRun.isHidden = false
                self.buttonEndRun.frame.origin.x = (self.buttonPause.frame.origin.x + self.buttonPause.frame.width + 70.0)
            }
            
            buttonPause.tag = 1
        }
        
        else if buttonPause.tag == 1 {
            
            self.userLocation.requestLocation()
            
            UIView.animate(withDuration: 0.5) {
                self.buttonPause.frame.origin.x = (UIScreen.main.bounds.width - self.buttonPause.frame.width)/2.0
                self.buttonPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                
                self.buttonEndRun.frame.origin.x = (UIScreen.main.bounds.width - self.buttonPause.frame.width)/2.0
                
            }
            buttonPause.tag = 0

        }
        
    }
    
    @IBAction func EndRunButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: NSLocalizedString("End Run", comment: ""),
                                      message: NSLocalizedString("Are you sure you want to end this run?", comment: ""), preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let end = UIAlertAction(title: NSLocalizedString("End Anyway", comment: ""), style: .destructive, handler: { _ in
            
            let destinationVC = SaveActivityViewController()
            destinationVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
//          here self.navigationController?.present(destinationVC, animated: true) doesn't add the screen inside the nav stack
//          it just presents above the navcontroller, and beacuse of which
//          self.navigationController?.dismiss(animated: true, completion: nil) was not working in SaveActivityViewController
            
        })
        
        alert.overrideUserInterfaceStyle = .dark
        alert.addAction(end)
        
        present(alert, animated: true , completion: nil)
        
    }
    
}

// MARK: - Page Control Code & Scroll View Setting

extension RunStartedViewController : UIScrollViewDelegate {
    
    func settingHorizontalScroll() {
        scrollView.contentSize.width = view.frame.width * 3

            for i in 0..<3 {
                let page = UIView(frame: CGRect(x: CGFloat(i) * view.frame.width, y: 0,
                                                width: UIScreen.main.bounds.width, height: scrollView.frame.height))

                switch i {
                case 0:
                    let liveTrackingView = LiveTrackingViewController(nibName: "LiveTrackingViewController", bundle: nil)
                    page.addSubview(liveTrackingView.view)
                    
                case 1:
                    self.viewActivityProgress.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
                    
                    page.addSubview(self.viewActivityProgress)
                                                            
                case 2: 
                    self.viewActivitySettings.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
                    page.addSubview(self.viewActivitySettings)
                    
                default: break
                }

                scrollView.addSubview(page)
            }
        scrollView.contentOffset = CGPoint(x: view.frame.width, y: 0)
    }
    
    @IBAction func toggleScrollingTapped(_ sender: UIButton) {
        scrollView.isScrollEnabled.toggle()
        
        if scrollView.isScrollEnabled {
            sender.setImage(UIImage(systemName: "lock.open.fill"), for: .normal)
        }
        else {
            sender.setImage(UIImage(systemName: "lock.fill"), for: .normal)
        }
    }
    
//    @IBAction func pageValueChanged(_ sender: UIPageControl) {
//        let currentPage = sender.currentPage
//        
//        scrollView.setContentOffset(CGPoint(x: CGFloat(currentPage) * view.frame.width, y: 0), animated: true)
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / view.frame.width)
    }
    
    
}
