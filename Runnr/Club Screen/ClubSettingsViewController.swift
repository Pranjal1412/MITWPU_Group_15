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
    
    @IBOutlet weak var buttonEditBanner: UIButton!
    @IBOutlet weak var imageClubProfile: UIImageView!
    @IBOutlet weak var imageClubBanner: UIImageView!
    @IBOutlet weak var textFieldClubName: UITextField!
    @IBOutlet weak var textFieldTagline: UITextField!
    @IBOutlet weak var textViewClubBio: UITextView!
    @IBOutlet weak var textFieldClubSport: UITextField!
    
    var clubProfileData: Club?
    var profileImageChanged = false
    var bannerImageChanged = false
    var delegate: UpdateClubProfile?
    
    private var tag = 0
    
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        super.viewDidLoad()
        setup()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setup() {
        
        self.textViewClubBio.delegate = self
        
        self.scrollView.contentSize.height = self.stackJoinApproval.frame.origin.y + self.stackJoinApproval.frame.height + 50
        
        setGlassEffect(for: self.buttonCancel, withImage: "multiply")
        setGlassEffect(for: self.buttonSave, withImage: "checkmark")
        
        if let url = URL(string: clubProfileData?.clubProfileImageURL ?? "") {
            imageClubProfile.kf.setImage(with: url)
        }
        
        if let url = URL(string: clubProfileData?.clubBannerImageURL ?? "") {
            imageClubBanner.kf.setImage(with: url)
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
            let originalProfileURL = self.clubProfileData!.clubProfileImageURL!
            let originalBannerURL = self.clubProfileData!.clubBannerImageURL!
            
            if self.profileImageChanged == true {
                
                await deleteImageFromStorage(imageURL: self.clubProfileData!.clubProfileImageURL!)
                
                if let newURL = await saveClubProfileImage(clubID: (self.clubProfileData?.clubID)!, with: self.imageClubProfile.image!) {
                    self.clubProfileData!.clubProfileImageURL = newURL
                }
                else {
                    self.clubProfileData!.clubProfileImageURL! = originalProfileURL
                }
            }
            
            if self.bannerImageChanged == true {
                
                await deleteImageFromStorage(imageURL: self.clubProfileData!.clubBannerImageURL!)
                
                if let newURL = await saveClubBannerImage(clubID: (self.clubProfileData?.clubID)!, with: self.imageClubBanner.image!) {
                    self.clubProfileData!.clubBannerImageURL = newURL
                }
                else {
                    self.clubProfileData!.clubBannerImageURL! = originalBannerURL
                }
            }

            
            await updateClubInfo(clubID: self.clubProfileData!.clubID!, updatedData: self.clubProfileData!)
            self.delegate?.updatedClubData(club: self.clubProfileData!)
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func editClubImages(_ sender: UIButton) {
        
        self.tag = sender.tag
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraButton = UIAlertAction(title: String(localized: "Camera"), style: .default, handler: {_ in
            self.openCamera()
        })
        let photoLibraryButton = UIAlertAction(title: String(localized: "Gallery"), style: .default, handler: {_ in
            self.openPhotoLibrary()
        })
        let cancelButton = UIAlertAction(title: String("Cancel"), style: .cancel)

        alert.addAction(cameraButton)
        alert.addAction(photoLibraryButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true)

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
                            if self.tag == 0 {
                                self.imageClubProfile.image = image
                                self.profileImageChanged = true
                            }
                            else if self.tag == 1 {
                                self.imageClubBanner.image = image
                                self.bannerImageChanged = true
                            }
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
            if self.tag == 0 {
                self.imageClubProfile.image = image
                self.profileImageChanged = true
            }
            else if self.tag == 1 {
                self.imageClubBanner.image = image
                self.bannerImageChanged = true
            }
        }
    }
}

protocol UpdateClubProfile {
    func updatedClubData(club: Club)
}

