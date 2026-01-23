//
//  EditProfileViewController.swift
//  Runnr
//
//  Created by Mrunal Aralkar on 22/01/26.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var imageViewProfilePhoto: UIImageView!
    @IBOutlet weak var buttonEditProfilePhoto: UIButton!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelDisplayName: UILabel!
    @IBOutlet weak var viewUsername: UIView!
    @IBOutlet weak var viewDisplayName: UIView!
    @IBOutlet weak var textFieldDisplayName: UITextField!
    @IBOutlet weak var viewBio: UIView!
    @IBOutlet weak var labelBio: UILabel!
    @IBOutlet weak var textFieldBio: UITextField!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var buttonSaveChanges: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        // Do any additional setup after loading the view.
    }
    
    func setup() {
        imageViewProfilePhoto.layer.cornerRadius = imageViewProfilePhoto.frame.size.height / 2
        buttonEditProfilePhoto.layer.cornerRadius = buttonEditProfilePhoto.frame.size.height / 2
        viewUsername.layer.cornerRadius = 10
        viewDisplayName.layer.cornerRadius = 10
        viewUsername.clipsToBounds = true
        viewBio.layer.cornerRadius = 10
        viewBio.clipsToBounds = true
        viewDisplayName.clipsToBounds = true
        
        viewUsername.layer.borderWidth = 1
        viewUsername.layer.borderColor = UIColor.cardLightBlack.cgColor
        viewDisplayName.layer.borderWidth = 1
        viewDisplayName.layer.borderColor = UIColor.cardLightBlack.cgColor
        viewBio.layer.borderWidth = 1
        viewBio.layer.borderColor = UIColor.cardLightBlack.cgColor
    }
    
    @IBAction func buttonSave(_ sender: Any) {
    }
    
    @IBAction func buttonCancel(_ sender: Any) {
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
