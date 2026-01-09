//  SetGoalViewController.swift
//  Runnr
//
//  Created by SDC-USER on 28/11/25.
//

import UIKit
import GoogleMaps

class ActivitySetGoalViewController: UIViewController {

    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var viewSubBackground: UIView!
    @IBOutlet weak var viewMainBackground: UIView!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var buttonSkip: UIButton!
    @IBOutlet weak var labelAudioFeedback: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet weak var viewBackgroungActivity: UIView!
    @IBOutlet weak var viewBackgroundDistance: UIView!
    @IBOutlet weak var viewBackgroundTime: UIView!
    @IBOutlet weak var viewBackgroundAudio: UIView!
    
    @IBOutlet weak var buttonActivity: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        viewMainBackground.layer.cornerRadius = 20
        viewSubBackground.layer.cornerRadius = 15
        
        self.buttonActivity.setTitle("Select Activity", for: .normal)
        self.buttonActivity.setTitleColor(.gray, for: .normal)
        
        settingScreen()
        setupMenu()
        hideKeyboardWhenTappedAround()
        labelAudioFeedback.sizeToFit()
    }
    
    func settingScreen() {
        let thinFont = UIFont(name: "SF-Pro-Display-Thin", size: 33) ?? UIFont.systemFont(ofSize: 33, weight: .thin)
        let boldFont = UIFont(name: "SF-Pro-Display-Bold", size: 33) ?? UIFont.boldSystemFont(ofSize: 33)
        
        let thinText = NSAttributedString(string: "Set Your ", attributes: [.font: thinFont , .foregroundColor: UIColor.white])
        let boldText = NSAttributedString(string: "Goal", attributes: [.font: boldFont , .foregroundColor: UIColor.white])
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(thinText)
        attributedString.append(boldText)
        labelScreenTitle.attributedText = attributedString
        
        
        let regularFont = UIFont(name: "SF-Pro-Display-Thin", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .regular)
        let lightFont = UIFont(name: "SF-Pro-Display-Bold", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .light)
        
        
        var regularText = NSAttributedString(string: "Distance ", attributes: [.font: regularFont , .foregroundColor: UIColor.white])
        var lightText = NSAttributedString(string: "(km)", attributes: [.font: lightFont , .foregroundColor: UIColor.white])
        
        let fullDistancetext = NSMutableAttributedString()
        fullDistancetext.append(regularText)
        fullDistancetext.append(lightText)
        labelDistance.attributedText = fullDistancetext
        
        regularText = NSAttributedString(string: "Time ", attributes: [.font: regularFont , .foregroundColor: UIColor.white])
        lightText = NSAttributedString(string: "(hrs)", attributes: [.font: lightFont , .foregroundColor: UIColor.white])
        
        let fullTimetext = NSMutableAttributedString()
        fullTimetext.append(regularText)
        fullTimetext.append(lightText)
        labelTime.attributedText = fullTimetext

        buttonSkip.layer.borderWidth = 1
        buttonSkip.layer.borderColor = UIColor.accent.cgColor
        buttonSkip.layer.cornerRadius = buttonSkip.frame.height / 2
        
        buttonStart.layer.cornerRadius = buttonStart.frame.height / 2
        
        viewBackgroundTime.layer.cornerRadius = 15
        viewBackgroundAudio.layer.cornerRadius = 15
        viewBackgroundDistance.layer.cornerRadius = 15
        viewBackgroungActivity.layer.cornerRadius = 15
    }
    
    @IBAction func buttonStartActivityPressed(_ sender: UIButton) {
                
//      Using self.presentingViewController as we need the same object that is been created and hence
//      let presenter = SetGoalViewController() doesn't work as it creates a brand new onject that is unused
        
        if let presenter = self.presentingViewController {
                        
//          now we are writing that upon dimissal of the screen perform the following code
            self.dismiss(animated: true) {

                let rootController = ActivityLiveTrackingViewController(nibName: "ActivityLiveTrackingViewController", bundle: nil)
                let navigationController = UINavigationController(rootViewController: rootController)

                navigationController.modalPresentationStyle = .fullScreen
                navigationController.navigationBar.isHidden = true

                presenter.present(navigationController, animated: false, completion: nil)
            }
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    
    func setupMenu() {

        let run = UIAction(title: "Run") { _ in
            self.buttonActivity.setTitle("Run", for: .normal)
        }

        let walk = UIAction(title: "Walk") { _ in
            self.buttonActivity.setTitle("Walk", for: .normal)
        }

        let cycle = UIAction(title: "Cycle") { _ in
            self.buttonActivity.setTitle("Cycle", for: .normal)
        }

        buttonActivity.menu = UIMenu(children: [run, walk, cycle])
        buttonActivity.showsMenuAsPrimaryAction = true
        self.buttonActivity.setTitleColor(.accent, for: .normal)
    }
    
}

extension ActivitySetGoalViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
