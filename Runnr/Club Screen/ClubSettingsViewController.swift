//
//  ClubSettingsViewController.swift
//  Runnr
//
//  Created by Mrunal Aralkar on 24/01/26.
//

import UIKit
import Kingfisher

class ClubSettingsViewController: UIViewController {

  
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        scrollView.contentSize.height = self.stackJoinApproval.frame.origin.y + self.stackJoinApproval.frame.height + 20
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
    }
    
    @IBAction func buttonCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
