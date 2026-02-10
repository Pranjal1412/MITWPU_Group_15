//
//  SetProfileViewController.swift
//  Runnr
//
//  Created by SDC-USER on 22/01/26.
//

import UIKit
import PhotosUI

class SetProfileViewController: UIViewController, UITextViewDelegate {

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
    @IBOutlet weak var textViewBio: UITextView!
    @IBOutlet weak var textFieldUsername: UITextField!
    
    private var selectedButton: UIButton?
    var userProfile = DataSource.shared.getUserProfile()
    let supabase = SupabaseManager.shared
    var username: String = ""
    var height: String = ""
    var weight: String = ""
    var profileURl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewMainOne.frame.origin.x = 25
        self.viewMainOne.frame.origin.y = self.labelSubHeading.frame.height + self.labelSubHeading.frame.origin.y + 30
        
        self.viewMainTwo.frame.origin.x = (self.viewMainOne.frame.origin.x * 2) + self.viewMainTwo.frame.width
        self.viewMainTwo.frame.origin.y = self.labelSubHeading.frame.height + self.labelSubHeading.frame.origin.y + 30
        
        self.buttonBack.isHidden = true
        self.textViewBio.delegate = self
        self.textFieldUsername.text = self.userProfile.userName
        setScreenElements()
        
    }

    @IBAction func viewTapped(_ sender: UIControl) {
        view.endEditing(true)
    }
    
    @IBAction func valueEnteredInTextField(_ sender: UITextField) {
        
        switch sender.tag {
        case 0:
            self.username = sender.text ?? ""
            
        case 1:
            self.height = sender.text ?? ""
            
        case 2:
            self.weight = sender.text ?? ""
            
        default:
            break
        }
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
    
    @IBAction func selectProfileImage(_ sender: UIButton) {
        
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
            self.completeUserProfile()
            
            Task {
                await insertUserProfile(self.userProfile)
                
                if self.userProfile.userID != nil {
                    await insertUserStats(UserStats(userID: self.userProfile.userID!, totalPointsEarned: 100, totalDistanceCovered: 0, totalActivities: 0, longestStreak: 0))
                }
                
                if let presenter = self.presentingViewController as? UINavigationController {
                    self.dismiss(animated: true) {
                        presenter.popToRootViewController(animated: true)
                    }
                }
            }
            
        }
        
    }
    
    func completeUserProfile() {
        switch selectedButton?.tag {
            case 0:
            self.userProfile.gender = .male
            case 1:
            self.userProfile.gender = .female
            case 2:
            self.userProfile.gender = .other
        default:
            self.userProfile.gender = nil
        }
        
        self.userProfile.userName = self.username
        self.userProfile.height = Double(self.height)
        self.userProfile.weight = Double(self.weight)
        self.userProfile.userLevel = .none
        self.userProfile.userProfileImageURL = self.profileURl
        self.userProfile.userBio = self.textViewBio.text ?? ""
        
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
}


extension SetProfileViewController : PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openPhotoLibrary() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }

        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }

    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        for result in results {
            let provider = result.itemProvider
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            Task {
                                do {
                                    self.profileURl = try await self.supabase.createProfileImageURL(image, self.userProfile.userID!)
                                    print("Uploaded URl: ", self.profileURl)
                                }
                                catch {
                                    print("Upload Failed")
                                }
                            }
                        }
                    }
                }
            }
        }
                
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            Task {
                do {
                    self.profileURl = try await self.supabase.createProfileImageURL(image, self.userProfile.userID!)
                    print("Uploaded URl: ", self.profileURl)
                }
                catch {
                    print("Upload Failed")
                }
            }
        }
    }
}
