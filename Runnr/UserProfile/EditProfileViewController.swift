//
//  EditProfileViewController.swift
//  Runnr
//
//  Created by Mrunal Aralkar on 22/01/26.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        hideKeyboardWhenTappedAround()
        registerNotifications()
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
        textFieldHeight.text = String(self.userProfile.height!)
        textFieldWeight.text = String(self.userProfile.weight!)
        textFieldUsername.text = self.userProfile.userName
        textViewBio.text = self.userProfile.userBio
        
        editProfileScrollview.contentSize.height = viewBiography.frame.origin.y + viewBiography.frame.height + 20
        
    }
    
    @IBAction func buttonSave(_ sender: Any) {
    }
    
    @IBAction func buttonCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }

}

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
