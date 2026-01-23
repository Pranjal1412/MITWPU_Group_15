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
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonMale: UIButton!
    @IBOutlet weak var buttonFemale: UIButton!
    @IBOutlet weak var buttonOther: UIButton!
    
    private var selectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewMainOne.frame.origin.x = 25
        self.viewMainOne.frame.origin.y = self.labelSubHeading.frame.height + self.labelSubHeading.frame.origin.y + 30
        
        self.viewMainTwo.frame.origin.x = (self.viewMainOne.frame.origin.x * 2) + self.viewMainTwo.frame.width
        self.viewMainTwo.frame.origin.y = self.labelSubHeading.frame.height + self.labelSubHeading.frame.origin.y + 30
        
        self.buttonBack.isHidden = true
        
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
        
        self.viewTextHeight.layer.cornerRadius = 10
        self.viewTextHeight.layer.borderColor = UIColor.cardLightBlack.cgColor
        self.viewTextHeight.layer.borderWidth = 1
        
        self.viewTextWeight.layer.cornerRadius = 10
        self.viewTextWeight.layer.borderColor = UIColor.cardLightBlack.cgColor
        self.viewTextWeight.layer.borderWidth = 1
        
        self.buttonNext.layer.cornerRadius = self.buttonNext.frame.height / 2
        
        setGlassEffect(for: self.buttonBack, withImage: "chevron.backward")

        [buttonMale, buttonFemale, buttonOther].forEach {
            $0?.layer.cornerRadius = 10
            $0?.setTitleColor(.white, for: .normal)
        }
        
    }
    
    func selectButton(_ button: UIButton) {

        if let previous = selectedButton {
            previous.backgroundColor = .cardDarkBlack
            previous.layer.borderWidth = 0
            previous.setTitleColor(.white, for: .normal)
            previous.layer.shadowOpacity = 0
        }

        button.backgroundColor = .accent.withAlphaComponent(0.1)
        button.setTitleColor(.accent, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = button.backgroundColor?.cgColor

        selectedButton = button
    }

    @IBAction func genderTapped(_ sender: UIButton) {
        selectButton(sender)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        self.buttonNext.setTitle(String(localized: "Next"), for: .normal)
        
        self.progressBar.setProgress(0.5, animated: true)
        
        self.buttonBack.isHidden = true
        
        UIView.animate(withDuration: 0.5) {
            self.viewMainOne.frame.origin.x += self.viewMainOne.frame.width + 50
            self.viewMainTwo.frame.origin.x += self.viewMainTwo.frame.width + 25
        }
        
    }
    
    @IBAction func buttonNextClicked(_ sender: UIButton) {
        if self.buttonNext.titleLabel?.text == "Next" {
            self.buttonNext.setTitle(String(localized: "Complete Profile"), for: .normal)
            self.progressBar.setProgress(1, animated: true)
            self.buttonBack.isHidden = false
            
            UIView.animate(withDuration: 0.5) {
                self.viewMainOne.frame.origin.x -= self.viewMainOne.frame.width + 50
                self.viewMainTwo.frame.origin.x -= self.viewMainTwo.frame.width + 25
            }
        }
        else if self.buttonNext.titleLabel?.text == "Complete Profile" {
            
            isSignUpComplete = true
            
            if let presenter = self.presentingViewController as? UINavigationController {
                self.dismiss(animated: true) {
                    presenter.popToRootViewController(animated: true)
                }
            }
            
        }
        
    }
}
