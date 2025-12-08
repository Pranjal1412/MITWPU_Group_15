//
//  RunStartedViewController.swift
//  Runnr
//
//  Created by SDC-USER on 14/11/25.
//

import UIKit
import GoogleMaps

class RunStartedViewController: UIViewController {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var viewPace: UIView!
    @IBOutlet weak var viewHeartRate: UIView!
    @IBOutlet weak var viewDistance: UIView!
    @IBOutlet weak var buttonPause: UIButton!
    @IBOutlet weak var buttonEndRun: UIButton!
    
    
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelPace: UILabel!
    @IBOutlet weak var labelHeartRate: UILabel!
    
    @IBOutlet weak var labelTimeCounter: UILabel!
    @IBOutlet weak var labelPaceCounter: UILabel!
    @IBOutlet weak var labelHeartRateCounter: UILabel!
    @IBOutlet weak var labelDistanceCounter: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        view.overrideUserInterfaceStyle = .dark
        
        settingScreenElements()
        settingPauseButtonImg()
        buttonEndRun.isHidden = true

    }

    func settingScreenElements() {
        viewBackground.layer.cornerRadius = 20
        viewPace.layer.cornerRadius = 20
        viewHeartRate.layer.cornerRadius = 20
        viewTime.layer.cornerRadius = 20
        viewDistance.layer.cornerRadius = 20
        buttonPause.layer.cornerRadius = 50
        buttonEndRun.layer.cornerRadius = 50
        
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
            UIView.animate(withDuration: 0.5) {
                self.buttonPause.frame.origin.x = (UIScreen.main.bounds.width - (self.buttonPause.frame.width * 2) - 70.0)/2.0
                self.buttonPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
                self.buttonEndRun.isHidden = false
                self.buttonEndRun.frame.origin.x = (self.buttonPause.frame.origin.x + self.buttonPause.frame.width + 70.0)
            }
            buttonPause.tag = 1
        }
        
        else if buttonPause.tag == 1 {
            UIView.animate(withDuration: 0.5) {
                self.buttonPause.frame.origin.x = (UIScreen.main.bounds.width - self.buttonPause.frame.width)/2.0
                self.buttonPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                
                self.buttonEndRun.frame.origin.x = (UIScreen.main.bounds.width - self.buttonPause.frame.width)/2.0
                
            }
            buttonPause.tag = 0
//            buttonEndRun.isHidden = true
        }
        
    }
    
    @IBAction func EndRunButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "End Run", message: "Are you sure you want to end this run?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let end = UIAlertAction(title: "End Anyway", style: .destructive, handler: { _ in
            print("Settings tapped")
            
            let destinationVC = SaveActivityViewController()
            destinationVC.modalPresentationStyle = .fullScreen
            
//          here self.navigationController?.present(destinationVC, animated: true) doesn't add the screen inside the nav stack
//          it just presents above the navcontroller, and beacuse of which
//          self.navigationController?.dismiss(animated: true, completion: nil) was not working in SaveActivityViewController
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
        })
        
        alert.overrideUserInterfaceStyle = .dark
        alert.addAction(end)
        
        present(alert, animated: true , completion: nil)
        
    }
    
    
}
