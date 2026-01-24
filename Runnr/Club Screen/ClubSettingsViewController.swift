//
//  ClubSettingsViewController.swift
//  Runnr
//
//  Created by Mrunal Aralkar on 24/01/26.
//

import UIKit

class ClubSettingsViewController: UIViewController {

    @IBOutlet weak var viewClubName: UIView!
    @IBOutlet weak var textFieldClubName: UITextField!
    @IBOutlet weak var labelClubName: UILabel!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var viewClubPrivacy: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var switchClubPrivacy: UISwitch!
    @IBOutlet weak var labelClubPrivacy: UILabel!
    @IBOutlet weak var labelTermsClubPrivacy: UILabel!
    @IBOutlet weak var imageViewClubProfilePicture: UIImageView!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

        // Do any additional setup after loading the view.
    }
    
    func setup() {
        imageViewClubProfilePicture.layer.cornerRadius = imageViewClubProfilePicture.frame.size.height / 2
//        buttonEditProfilePhoto.layer.cornerRadius = buttonEditProfilePhoto.frame.size.height / 2
        viewClubName.layer.cornerRadius = 10
        viewDescription.layer.cornerRadius = 10
        viewClubName.clipsToBounds = true
        viewClubPrivacy.layer.cornerRadius = 10
        viewClubPrivacy.clipsToBounds = true
        viewDescription.clipsToBounds = true
        
        viewClubName.layer.borderWidth = 1
        viewClubName.layer.borderColor = UIColor.cardLightBlack.cgColor
        viewDescription.layer.borderWidth = 1
        viewDescription.layer.borderColor = UIColor.cardLightBlack.cgColor
        viewClubPrivacy.layer.borderWidth = 1
        viewClubPrivacy.layer.borderColor = UIColor.cardLightBlack.cgColor
        
        setGlassEffect(for: self.buttonCancel, withImage: "multiply")
        setGlassEffect(for: self.buttonSave, withImage: "checkmark")
    }
    
    @IBAction func buttonSave(_ sender: Any) {
    }
    
    @IBAction func buttonCancel(_ sender: Any) {
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
