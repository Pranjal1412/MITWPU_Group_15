//
//  YourInformationViewController.swift
//  Runnr
//
//  Created by Archit Kankaria on 12/01/26.
//

import UIKit
import PhotosUI
class YourInformationViewController: UIViewController {

    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var buttonProfileImage: UIButton!
    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var viewDOB: UIView!
    @IBOutlet weak var buttonGender: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var viewHeight: UIView!
    @IBOutlet weak var textFieldHeight: UITextField!
    @IBOutlet weak var viewWeight: UIView!
    @IBOutlet weak var textFieldWeight: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    func setUpUI(){
        overrideUserInterfaceStyle = .dark
        imageProfile.layer.cornerRadius = imageProfile.frame.size.width / 2
        imageProfile.layer.borderWidth = 1
        imageProfile.layer.borderColor = UIColor.white.cgColor
        buttonProfileImage.layer.cornerRadius = buttonProfileImage.frame.height / 2
        [viewFirstName, viewLastName, viewGender, viewDOB,viewHeight,viewWeight].forEach {$0.layer.borderWidth = 1; $0.layer.borderColor = UIColor.white.cgColor;$0.layer.cornerRadius = 15
            }
        [textFieldFirstName, textFieldLastName, textFieldHeight, textFieldWeight].forEach {
            $0?.borderStyle = .none
        }
        let today = Date()
            datePicker.maximumDate = today
        if let nextYear = Calendar.current.date(bySetting: .year, value: 100, of: today) {
                datePicker.minimumDate = nextYear
            }
    }
    
    @IBAction func profilePhotoClicked(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Choose a source", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                self.showCamera()
            }))
            actionSheet.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: { _ in
                self.showPhotoLibrary()
            }))

            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(actionSheet, animated: true)
    }
    func showPhotoLibrary() {
            var config = PHPickerConfiguration()
            config.filter = .images
            config.selectionLimit = 1
            
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            present(picker, animated: true)
        }
        
        func showCamera() {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                present(picker, animated: true)
            } else {
                print("Camera not available")
            }
        }
    
    @IBAction func pickDate(_ sender: UIDatePicker) {
        let selectedDate = sender.date
    }
    
    @IBAction func continueToTrack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
       
    }
}

    extension YourInformationViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // Gallery Handler
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                DispatchQueue.main.async {
                    self?.imageProfile.image = image as? UIImage
                }
            }
        }
        
        // Camera Handler
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                imageProfile.image = selectedImage
            }
            picker.dismiss(animated: true)
        }
    
}
