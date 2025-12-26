//
//  UserProfileViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 26/12/25.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var buttonEditProfile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.overrideUserInterfaceStyle = .dark
        settingsElements()
    }

    @IBAction func buttonBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func settingsElements() {
        if #available(iOS 26.0, *) {
            buttonBack.configuration = .glass()
            buttonBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            buttonBack.tintColor = .white
        } else {
            buttonBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            buttonBack.frame.origin.x = 100.0
            buttonBack.tintColor = .white
        }
        
        imageProfile.layer.cornerRadius = imageProfile.frame.size.width / 2
        buttonEditProfile.layer.cornerRadius = 10.0
    }
    
}
