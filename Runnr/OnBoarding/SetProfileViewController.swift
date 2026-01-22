//
//  SetProfileViewController.swift
//  Runnr
//
//  Created by SDC-USER on 22/01/26.
//

import UIKit

class SetProfileViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var labelSubHeading: UILabel!
    @IBOutlet weak var buttonUserProfile: UIButton!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var viewTextBackground: UIView!
    @IBOutlet weak var viewTextHeight: UIView!
    @IBOutlet weak var viewTextWeight: UIView!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var viewBioBackground: UIView!
    @IBOutlet weak var viewMainOne: UIView!
    @IBOutlet weak var viewMainTwo: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewMainOne.frame.origin.x = 25
        self.viewMainOne.frame.origin.y = self.labelSubHeading.frame.height + self.labelSubHeading.frame.origin.y + 30
        
        self.viewMainTwo.frame.origin.x = 25 + self.labelSubHeading.frame.width
        self.viewMainTwo.frame.origin.y = self.labelSubHeading.frame.height + self.labelSubHeading.frame.origin.y + 30
        
        setScreenElements()

    }

    func setScreenElements() {
        self.labelHeading.text = String(localized: "Set Your Identity")
        self.labelSubHeading.text = String(localized: "Choose a name that will lead the leaderboard")
        self.buttonUserProfile.layer.cornerRadius = self.buttonUserProfile.frame.height / 2
        self.buttonUserProfile.layer.borderWidth = 1.0
        
        self.labelFullName.text = String(localized: "Full Name")
        self.viewTextBackground.layer.cornerRadius = 10
        self.viewTextBackground.layer.borderColor = UIColor.cardLightBlack.cgColor
        self.viewTextBackground.layer.borderWidth = 1
        
        self.viewBioBackground.layer.cornerRadius = 10
        self.viewBioBackground.layer.borderColor = UIColor.cardLightBlack.cgColor
        self.viewBioBackground.layer.borderWidth = 1
        
        self.buttonNext.layer.cornerRadius = self.buttonNext.frame.height / 2
    }
    
    @IBAction func buttonNextClicked(_ sender: UIButton) {
        self.buttonNext.setTitle(String(localized: "Complete Profile"), for: .normal)
        
        self.progressBar.setProgress(1, animated: true)
        
        UIView.animate(withDuration: 0.5) {
            self.viewMainOne.frame.origin.x -= self.viewMainOne.frame.width + 50
            self.viewMainTwo.frame.origin.x -= self.viewMainTwo.frame.width + 50
            
        }
        
    }
}
