//
//  ClubSettingsViewController.swift
//  Runnr
//
//  Created by Mrunal Aralkar on 24/01/26.
//

import UIKit

class ClubSettingsViewController: UIViewController {

  
    @IBOutlet var stackJoinApproval: UIStackView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        scrollView.contentSize.height = self.stackJoinApproval.frame.origin.y + self.stackJoinApproval.frame.height + 20
        
        // Do any additional setup after loading the view.
    }
    
    func setup() {
//        imageViewClubProfilePicture.layer.cornerRadius = imageViewClubProfilePicture.frame.size.height / 2
////        buttonEditProfilePhoto.layer.cornerRadius = buttonEditProfilePhoto.frame.size.height / 2
//        viewClubName.layer.cornerRadius = 10
//        viewDescription.layer.cornerRadius = 10
//        viewClubName.clipsToBounds = true
//        viewClubPrivacy.layer.cornerRadius = 10
//        viewClubPrivacy.clipsToBounds = true
//        viewDescription.clipsToBounds = true
//        
//        viewClubName.layer.borderWidth = 1
//        viewClubName.layer.borderColor = UIColor.cardLightBlack.cgColor
//        viewDescription.layer.borderWidth = 1
//        viewDescription.layer.borderColor = UIColor.cardLightBlack.cgColor
//        viewClubPrivacy.layer.borderWidth = 1
//        viewClubPrivacy.layer.borderColor = UIColor.cardLightBlack.cgColor
        
        setGlassEffect(for: self.buttonCancel, withImage: "multiply")
        setGlassEffect(for: self.buttonSave, withImage: "checkmark")
    }
    
    @IBAction func buttonSave(_ sender: UIButton) {
    }
    
    @IBAction func buttonCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
