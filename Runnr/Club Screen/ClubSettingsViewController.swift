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
    
    @IBOutlet weak var imageClubProfile: UIImageView!
    @IBOutlet weak var imageClubBanner: UIImageView!
    
    var clubProfileData: Club?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    func setup() {
        scrollView.contentSize.height = self.stackJoinApproval.frame.origin.y + self.stackJoinApproval.frame.height + 20
        setGlassEffect(for: self.buttonCancel, withImage: "multiply")
        setGlassEffect(for: self.buttonSave, withImage: "checkmark")
    }
    
    
    
    @IBAction func buttonSave(_ sender: UIButton) {
    }
    
    @IBAction func buttonCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
