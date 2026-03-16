//
//  ClubSettingsViewController.swift
//  Runnr
//
//  Created by Mrunal Aralkar on 24/01/26.
//

import UIKit
import Kingfisher
import PhotosUI

class ClubSettingsViewController: UIViewController, UITextViewDelegate {

  
    @IBOutlet var stackJoinApproval: UIStackView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    @IBOutlet weak var imageClubProfile: UIImageView!
    @IBOutlet weak var imageClubBanner: UIImageView!
    @IBOutlet weak var textFieldClubName: UITextField!
    @IBOutlet weak var textFieldTagline: UITextField!
    @IBOutlet weak var textViewClubBio: UITextView!
    @IBOutlet weak var textFieldClubSport: UITextField!
    
    var clubProfileData: Club?
    var profileImageChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        
        self.textViewClubBio.delegate = self
        
        self.scrollView.contentSize.height = self.stackJoinApproval.frame.origin.y + self.stackJoinApproval.frame.height + 20
        setGlassEffect(for: self.buttonCancel, withImage: "multiply")
        setGlassEffect(for: self.buttonSave, withImage: "checkmark")
        
        if let url = URL(string: clubProfileData?.clubProfileImageURL ?? "") {
            imageClubProfile.kf.setImage(with: url)
        }
        
        self.imageClubProfile.layer.cornerRadius = 10
        self.textFieldClubName.text = clubProfileData?.clubName
        self.textFieldTagline.text = clubProfileData?.clubMotive
        self.textViewClubBio.text = clubProfileData?.clubDescription
        self.textFieldClubSport.text = clubProfileData?.clubSport.rawValue
    }
    
    @IBAction func buttonSave(_ sender: UIButton) {
        self.clubProfileData!.clubName = self.textFieldClubName.text ?? self.clubProfileData!.clubName
        self.clubProfileData!.clubMotive = self.textFieldTagline.text ?? self.clubProfileData!.clubMotive
        self.clubProfileData!.clubDescription = self.textViewClubBio.text ?? self.clubProfileData!.clubDescription
        self.clubProfileData!.clubSport = ActivityType(rawValue: self.textFieldClubSport.text ?? "") ?? self.clubProfileData!.clubSport
        
        Task {
            await updateClubInfo(clubID: self.clubProfileData!.clubID!, updatedData: self.clubProfileData!)
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func buttonCancel(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Discard Changes", message: "Do you want to discard your current changes?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let discardAction = UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.dismiss(animated: true)

        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(discardAction)
        self.present(alertController, animated: true)
    }
}

//MARK: - Photos
extension ClubSettingsViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
                            self.imageClubProfile.image = image
                            self.profileImageChanged = true
                        }
                    }
                }
            }
        }
                
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
//MARK: - Not working
        if let image = info[.originalImage] as? UIImage {
            self.imageClubProfile.image = image
            self.profileImageChanged = true
        }
    }
}
