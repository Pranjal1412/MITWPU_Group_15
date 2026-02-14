//
//  EditProfileViewController.swift
//  Runnr
//
//  Created by Mrunal Aralkar on 22/01/26.
//

import UIKit
import PhotosUI
import Kingfisher

protocol EditProfileDelegate: AnyObject {
    func didUpdateProfile()
}

class EditProfileViewController: UIViewController {

    @IBOutlet var editProfileScrollview: UIScrollView!
    @IBOutlet weak var imageViewProfilePhoto: UIImageView!
    @IBOutlet weak var buttonSaveChanges: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var viewUsername: UIView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var viewHeight: UIView!
    @IBOutlet weak var viewWeight: UIView!
    @IBOutlet weak var viewSport: UIView!
    @IBOutlet weak var viewBiography: UIView!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldHeight: UITextField!
    @IBOutlet weak var textFieldWeight: UITextField!
    @IBOutlet weak var textViewBio: UITextView!
    
    private var userProfile = DataSource.shared.getUserProfile()
    private var newProfileData = UserProfile()
    var delegate : EditProfileDelegate?
    
    private var profileImageChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        hideKeyboardWhenTappedAround()
        registerNotifications()
        
        if let url = URL(string: self.userProfile.userProfileImageURL!) {
            self.imageViewProfilePhoto.kf.setImage(with: url)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.profileImageChanged = false
    }
    
    func setup() {
        imageViewProfilePhoto.layer.cornerRadius = imageViewProfilePhoto.frame.size.height / 2
        
        setGlassEffect(for: self.buttonCancel, withImage: "multiply")
        setGlassEffect(for: self.buttonSaveChanges, withImage: "checkmark")
        
        viewName.layer.cornerRadius = 10
        viewEmail.layer.cornerRadius = 10
        viewSport.layer.cornerRadius = 10
        viewBiography.layer.cornerRadius = 10
        viewHeight.layer.cornerRadius = 10
        viewWeight.layer.cornerRadius = 10
        viewUsername.layer.cornerRadius = 10
        
        labelEmail.text = self.userProfile.emailAddress
        textFieldHeight.text = String(self.userProfile.height ?? 0)
        textFieldWeight.text = String(self.userProfile.weight ?? 0)
        textFieldUsername.text = self.userProfile.userName
        textViewBio.text = self.userProfile.userBio
        
        editProfileScrollview.contentSize.height = viewBiography.frame.origin.y + viewBiography.frame.height + 20
        
    }
    
    @IBAction func buttonSave(_ sender: UIButton) {
        
        Task {
            self.newProfileData = self.userProfile
            
            if self.profileImageChanged == true {
                
                await deleteImageFromStorage(imageURL: self.userProfile.userProfileImageURL!)
                
                if let newURL = await saveProfileImage(userID: self.userProfile.userID!, with: self.imageViewProfilePhoto.image!) {
                    self.newProfileData.userProfileImageURL = newURL
                }
                else {
                    self.newProfileData.userProfileImageURL = self.userProfile.userProfileImageURL!
                }
            }

            self.newProfileData.height = Double(textFieldHeight.text ?? String(self.userProfile.height!))
            self.newProfileData.weight = Double(textFieldWeight.text ?? String(self.userProfile.weight!))
            self.newProfileData.userBio = textViewBio.text ?? self.userProfile.userBio!
            self.newProfileData.userName = textFieldUsername.text ?? self.userProfile.userName!
            
            await updateUserProfile(userID: self.userProfile.userID!, newProfile: self.newProfileData)
            DataSource.shared.setUserProfile(self.newProfileData)

            self.delegate?.didUpdateProfile()
            
            self.dismiss(animated: true)

        }
    }
    
    @IBAction func buttonCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func editProfileImageTapped(_ sender: UIButton) {
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
    
}

// MARK: - Keyboard Settings
extension EditProfileViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification){
        
        if let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
            editProfileScrollview.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification){
        editProfileScrollview.contentInset.bottom = 0
    }

}

// MARK: - User Profile Image Picker Code
extension EditProfileViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
                            self.imageViewProfilePhoto.image = image
                            self.profileImageChanged = true
                        }
                    }
                }
            }
        }
                
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            self.imageViewProfilePhoto.image = image
            self.profileImageChanged = true
        }
    }
}
