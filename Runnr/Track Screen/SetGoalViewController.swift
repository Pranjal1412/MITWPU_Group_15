//
//  SetGoalViewController.swift
//  Runnr
//
//  Created by SDC-USER on 28/11/25.
//

import UIKit

class SetGoalViewController: UIViewController {

    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewSubBackground: UIView!
    @IBOutlet weak var viewMainBackground: UIView!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var buttonSkip: UIButton!
    
    @IBOutlet weak var viewBackgroungActivity: UIView!
    @IBOutlet weak var viewBackgroundDistance: UIView!
    @IBOutlet weak var viewBackgroundTime: UIView!
    @IBOutlet weak var viewBackgroundAudio: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBackground.backgroundColor = .clear
        viewMainBackground.backgroundColor = .black
        viewMainBackground.layer.cornerRadius = 20
        viewSubBackground.layer.cornerRadius = 15
        
        view.overrideUserInterfaceStyle = .dark
        settingScreen()
        
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
        
//        viewBackground
        
        buttonSkip.layer.borderWidth = 1
        buttonSkip.layer.borderColor = UIColor.accent.cgColor
        buttonSkip.layer.cornerRadius = buttonSkip.frame.height / 2
        
        buttonStart.layer.cornerRadius = buttonStart.frame.height / 2
    }
    
    @IBAction func buttonStartActivityPressed(_ sender: UIButton) {
        
//        self.dismiss(animated: true)
        
        let rootController = RunStartedViewController(nibName: "RunStartedViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: rootController)
    
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.isHidden = true
    
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
//
}
