//  SetGoalViewController.swift
//  Runnr
//
//  Created by SDC-USER on 28/11/25.
//

import UIKit
import GoogleMaps

class SetGoalViewController: UIViewController {

    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var viewSubBackground: UIView!
    @IBOutlet weak var viewMainBackground: UIView!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var buttonSkip: UIButton!
    
    @IBOutlet weak var viewBackgroungActivity: UIView!
    @IBOutlet weak var viewBackgroundDistance: UIView!
    @IBOutlet weak var viewBackgroundTime: UIView!
    @IBOutlet weak var viewBackgroundAudio: UIView!
    
//    let userLocation = UserLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        viewMainBackground.layer.cornerRadius = 20
        viewSubBackground.layer.cornerRadius = 15
        
        view.overrideUserInterfaceStyle = .dark
        settingScreen()
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if #available(iOS 26.0, *) {
//                view.window?.backgroundColor = .clear
//                presentingViewController?.view.backgroundColor = .clear
//        }
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

                let rootController = ActivityProgressViewController(nibName: "ActivityProgressViewController", bundle: nil)
                let navigationController = UINavigationController(rootViewController: rootController)

                navigationController.modalPresentationStyle = .fullScreen
                navigationController.navigationBar.isHidden = true

                presenter.present(navigationController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    
}

extension SetGoalViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
