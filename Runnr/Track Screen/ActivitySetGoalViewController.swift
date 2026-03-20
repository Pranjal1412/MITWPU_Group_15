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
    @IBOutlet weak var labelAudioFeedback: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    
    @IBOutlet weak var viewBackgroungActivity: UIView!
    @IBOutlet weak var viewBackgroundDistance: UIView!
    @IBOutlet weak var viewBackgroundTime: UIView!
    @IBOutlet weak var viewBackgroundAudio: UIView!
    
    @IBOutlet weak var switchAudioFeedback: UISwitch!
    @IBOutlet weak var buttonActivity: UIButton!
    
    var originalYValue: CGFloat = 0
    var keyboardTappedCount = 2
    var distanceGoal = 0.0
    var hourGoal = 0
    var minuteGoal = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = .clear
        self.viewMainBackground.layer.cornerRadius = 20
        self.viewSubBackground.layer.cornerRadius = 15
        
        self.originalYValue = view.frame.origin.y
        
        self.settingScreen()
        self.setupMenu()
        self.registerNotifications()
        self.labelAudioFeedback.sizeToFit()
        
        setGlassEffect(for: self.buttonCancel, withImage: "multiply")
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func settingScreen() {
        let thinFont = UIFont(name: "SF-Pro-Display-Thin", size: 33) ?? UIFont.systemFont(ofSize: 33, weight: .thin)
        let boldFont = UIFont(name: "SF-Pro-Display-Bold", size: 33) ?? UIFont.boldSystemFont(ofSize: 33)
        
        let thinText = NSAttributedString(string: "Set Your ", attributes: [.font: thinFont , .foregroundColor: UIColor.white])
        let boldText = NSAttributedString(string: "Goal", attributes: [.font: boldFont , .foregroundColor: UIColor.white])
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(thinText)
        attributedString.append(boldText)
        self.labelScreenTitle.attributedText = attributedString
        
        
        let regularFont = UIFont(name: "SF-Pro-Display-Thin", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .regular)
        let lightFont = UIFont(name: "SF-Pro-Display-Bold", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .light)
        
        
        let regularText = NSAttributedString(string: "Distance ", attributes: [.font: regularFont , .foregroundColor: UIColor.white])
        let lightText = NSAttributedString(string: "(Km)", attributes: [.font: lightFont , .foregroundColor: UIColor.white])
        
        let fullDistancetext = NSMutableAttributedString()
        fullDistancetext.append(regularText)
        fullDistancetext.append(lightText)
        self.labelDistance.attributedText = fullDistancetext
        
        self.buttonStart.layer.cornerRadius = buttonStart.frame.height / 2
        
        self.viewBackgroundTime.layer.cornerRadius = 15
        self.viewBackgroundAudio.layer.cornerRadius = 15
        self.viewBackgroundDistance.layer.cornerRadius = 15
        self.viewBackgroungActivity.layer.cornerRadius = 15
    }
    
    @IBAction func buttonStartActivityPressed(_ sender: UIButton) {
                
        if self.buttonActivity.titleLabel?.text != "Select Activity" {
            if let presenter = self.presentingViewController {
                            
    //          now we are writing that upon dimissal of the screen perform the following code
                self.dismiss(animated: true) {

                    let rootController = ActivityLiveTrackingViewController(nibName: "ActivityLiveTrackingViewController", bundle: nil)
                    rootController.isAudioFeedbackOn = self.switchAudioFeedback.isOn
                    rootController.activityTypeSelected = ActivityType(rawValue: self.buttonActivity.titleLabel!.text!)
                    rootController.distanceGoalSet = self.distanceGoal
                    rootController.minGoalSet = self.minuteGoal
                    rootController.hourGoalSet = self.hourGoal
                    
                    
                    let navigationController = UINavigationController(rootViewController: rootController)

                    navigationController.modalPresentationStyle = .fullScreen
                    navigationController.navigationBar.isHidden = true

                    presenter.present(navigationController, animated: false, completion: nil)
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Select an Activity", message: "You need to select an activity before starting", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func distanceGoalSet(_ sender: UITextField) {
        if let text = sender.text {
            let value = Double(text) ?? 0.0
            if sender.tag == 0 {
                distanceGoal = value
            }
            else if sender.tag == 1 {
                self.hourGoal = Int(value)
            }
            else if sender.tag == 2 {
                self.minuteGoal = Int(value)
            }
            
        } else {
            distanceGoal = 0.0
        }
    }
    
    
    func setupMenu() {

        let defaultActivity = UIAction(title: "Select Activity") { _ in
            self.buttonActivity.setTitle("Select Activity", for: .normal)
            self.buttonActivity.setTitleColor(.darkGray, for: .normal)
        }
        
        let run = UIAction(title: "Running") { _ in
            self.buttonActivity.setTitle("Running", for: .normal)
            self.buttonActivity.setTitleColor(.accent, for: .normal)

        }

        let walk = UIAction(title: "Walking") { _ in
            self.buttonActivity.setTitle("Walking", for: .normal)
            self.buttonActivity.setTitleColor(.accent, for: .normal)

        }

        let hike = UIAction(title: "Hiking") { _ in
            self.buttonActivity.setTitle("Hiking", for: .normal)
            self.buttonActivity.setTitleColor(.accent, for: .normal)

        }

        let marathon = UIAction(title: "Marathon") { _ in
            self.buttonActivity.setTitle("Marathon", for: .normal)
            self.buttonActivity.setTitleColor(.accent, for: .normal)

        }
        
        self.buttonActivity.menu = UIMenu(children: [defaultActivity, run, walk, marathon, hike])
        self.buttonActivity.showsMenuAsPrimaryAction = true
        self.buttonActivity.setTitleColor(.accent, for: .normal)
    }
    
}

// MARK: - Keyboard Settings

extension ActivitySetGoalViewController {
    
    @IBAction func viewBackgroundClicked(_ sender: UIControl) {
        view.endEditing(true)
    }
    
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if self.keyboardTappedCount > 0{
            self.view.frame.origin.y -= 70
            self.keyboardTappedCount -= 1
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = self.originalYValue
        self.keyboardTappedCount = 2
    }
    
}
