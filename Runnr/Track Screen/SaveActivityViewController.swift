//
//  SaveActivityViewController.swift
//  Runnr
//
//  Created by SDC-USER on 27/11/25.
//

import UIKit

class SaveActivityViewController: UIViewController {

    @IBOutlet weak var viewDistance: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var viewPace: UIView!
    @IBOutlet weak var viewCalories: UIView!
    @IBOutlet weak var viewtextField: UIView!
    @IBOutlet weak var scrollViewSaveActivity: UIScrollView!
    @IBOutlet weak var labelPhotos: UILabel!
    @IBOutlet weak var imageViewMap: UIImageView!
    @IBOutlet weak var textViewRemark: UITextView!
    
    @IBOutlet weak var labelRunSummary: UILabel!
    @IBOutlet weak var labelPublicActivity: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelPace: UILabel!
    @IBOutlet weak var labelCalories: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.overrideUserInterfaceStyle = .dark
        SettingLabels()
        settingCardView()
        scrollViewSaveActivity.contentSize.height = labelPhotos.frame.origin.y + labelPhotos.frame.size.height + 20

        registerNotifications()
        hideKeyboardWhenTappedAround()
        textViewRemark.clipsToBounds = true
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: NSLocalizedString("Delete Activity", comment: ""),
                                      message: NSLocalizedString("Are you sure you want to Delete this Activity?", comment: ""),
                                      preferredStyle: .alert)
              
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: {_ in
            activities.remove(at: activities.count - 1)
            print("Array Size: \(activities.count)")
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        alert.overrideUserInterfaceStyle = .dark
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func settingCardView() {
        viewDistance.layer.cornerRadius = 15
        viewPace.layer.cornerRadius = 15
        viewTime.layer.cornerRadius = 15
        viewCalories.layer.cornerRadius = 15
        
        viewtextField.layer.cornerRadius = 15
        viewtextField.layer.borderColor = UIColor.white.cgColor
        viewtextField.layer.borderWidth = 0.5
        
        imageViewMap.layer.cornerRadius = 15
    }
    
    func SettingLabels() {
        labelPhotos.text = NSLocalizedString( "Photos", comment: "")
        labelDescription.text = NSLocalizedString( "Anyone on Runnr can see your activity", comment: "")
        labelRunSummary.text = NSLocalizedString( "Run Summary", comment: "")
        labelPublicActivity.text = NSLocalizedString( "Public Activity", comment: "")
        
        labelDescription.sizeToFit()
        
        labelPace.text = NSLocalizedString( "Pace", comment: "")
        labelTime.text = NSLocalizedString( "Time", comment: "")
        labelCalories.text = NSLocalizedString( "Calories", comment: "")
        labelDistance.text = NSLocalizedString( "Distance", comment: "")
    }
}

extension SaveActivityViewController {
    
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
            scrollViewSaveActivity.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification){
        scrollViewSaveActivity.contentInset.bottom = 0
    }
}
