//
//  RunStartedViewController.swift
//  Runnr
//
//  Created by SDC-USER on 14/11/25.
//

import UIKit

class RunStartedViewController: UIViewController {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var viewPace: UIView!
    @IBOutlet weak var viewHeartRate: UIView!
    @IBOutlet weak var viewDistance: UIView!
    @IBOutlet weak var buttonPause: UIButton!
    
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
        
        settingCornerRadius()
        settingPauseButtonImg()
    }

    func settingCornerRadius() {
        viewBackground.layer.cornerRadius = 20
        viewPace.layer.cornerRadius = 20
        viewHeartRate.layer.cornerRadius = 20
        viewTime.layer.cornerRadius = 20
        viewDistance.layer.cornerRadius = 20
        buttonPause.layer.cornerRadius = 50
        
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
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        
        print("pause button pressed")
        let nextVC = RunPausedViewController(nibName: "RunPausedViewController", bundle: nil)
        self.navigationController?.pushViewController(nextVC, animated: true)
    } 
    
}
