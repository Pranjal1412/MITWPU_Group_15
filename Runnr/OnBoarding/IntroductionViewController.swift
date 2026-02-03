//
//  IntroductionViewController.swift
//  Runnr
//
//  Created by SDC-USER on 23/01/26.
//

import UIKit
import SwiftUI

class IntroductionViewController: UIViewController {

    @IBOutlet weak var viewMainBackground: UIView!
    @IBOutlet var viewScreenOne: UIView!
    @IBOutlet var viewScreenTwo: UIView!
    @IBOutlet var viewScreenThree: UIView!
    @IBOutlet weak var viewRunnrCoin: UIView!
    @IBOutlet var viewIntroducingRunnr: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpScreenElements()
        
        self.loadSwiftUIOnboarding()
    }

    @IBAction func skipButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            let alert = UIAlertController(title: String(localized: "Welcome to Runnr."), message: String(localized: "Congratulations! You’ve earned 100 points!"), preferredStyle: .alert)
            
            let claimAction = UIAlertAction(title: String(localized: "Claim!"), style: .default, handler: nil)
            alert.addAction(claimAction)
            alert.view.tintColor = .accent
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setUpScreenElements() {
        self.viewMainBackground.layer.cornerRadius = 20
        self.viewMainBackground.layer.shadowColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        self.viewMainBackground.layer.shadowOpacity = 0.5
        self.viewMainBackground.layer.shadowRadius = 20
        
        self.viewRunnrCoin.layer.cornerRadius = self.viewRunnrCoin.frame.height / 2
        self.viewRunnrCoin.layer.shadowColor = UIColor.accent.withAlphaComponent(0.5).cgColor
        self.viewRunnrCoin.layer.shadowOpacity = 0.5
        self.viewRunnrCoin.layer.shadowRadius = 20

    }
    
    func loadSwiftUIOnboarding() {
        let hostingController = UIHostingController(rootView: OnboardingView())

        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        viewIntroducingRunnr.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: viewIntroducingRunnr.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: viewIntroducingRunnr.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: viewIntroducingRunnr.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: viewIntroducingRunnr.trailingAnchor)
        ])

        hostingController.didMove(toParent: self)
    }
}

