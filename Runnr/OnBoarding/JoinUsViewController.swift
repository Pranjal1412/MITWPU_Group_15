//
//  SignUpViewController.swift
//  Runnr
//
//  Created by SDC-USER on 08/12/25.
//

import UIKit
import Auth
import Supabase

class JoinUsViewController: UIViewController {
    
    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var viewEmailBackground: UIView!
    @IBOutlet weak var viewPasswordBackground: UIView!
    @IBOutlet weak var buttonGoogle: UIButton!
    @IBOutlet weak var buttonApple: UIButton!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    
    let supabase = SupabaseManager.shared.client
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        settingTitle()
        SettingViews()
        settingButton()
        print("View appeared")
        
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let destinationVC = SetProfileViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func settingTitle() {
        let thinFont = UIFont(name: "SF-Pro-Display-Thin", size: 33) ?? UIFont.systemFont(ofSize: 33, weight: .thin)
        let boldFont = UIFont(name: "SF-Pro-Display-Bold", size: 33) ?? UIFont.boldSystemFont(ofSize: 35)
        
        let thinText = NSAttributedString(string: String(localized: "SignUp to"), attributes: [.font: thinFont , .foregroundColor: UIColor.white])
        let boldText = NSAttributedString(string: String(localized: " Runnr"), attributes: [.font: boldFont , .foregroundColor: UIColor.white])
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(thinText)
        attributedString.append(boldText)
        
        labelScreenTitle.attributedText = attributedString
        labelScreenTitle.sizeToFit()
    }
    
    func SettingViews() {
        viewEmailBackground.backgroundColor = UIColor.clear
        viewPasswordBackground.backgroundColor = UIColor.clear
        
        viewEmailBackground.layer.cornerRadius = 15
        viewPasswordBackground.layer.cornerRadius = 15
        
        viewEmailBackground.layer.borderColor = UIColor.white.cgColor
        viewPasswordBackground.layer.borderColor = UIColor.white.cgColor
        
        viewEmailBackground.layer.borderWidth = 0.5
        viewPasswordBackground.layer.borderWidth = 0.5
    }
    
    func settingButton() {
        buttonSignUp.layer.cornerRadius = buttonSignUp.frame.height / 2
        buttonSignUp.setTitle(String(localized: "Sign Up"), for: .normal)
        
        buttonApple.layer.cornerRadius = buttonApple.frame.height / 2
        buttonApple.setTitle(String(localized: "Sign Up with Apple ID"), for: .normal)
        
        buttonGoogle.layer.cornerRadius = buttonGoogle.frame.height / 2
        setGlassEffect(for: self.buttonBack, withImage: "chevron.backward")
        
        self.buttonBack.tintColor = UIColor.white
        self.buttonBack.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        buttonGoogle.isUserInteractionEnabled = true
        buttonGoogle.bringSubviewToFront(buttonGoogle.titleLabel!)
    }
    
    @IBAction func buttonGooglePressed(_ sender: UIButton) {
        Task {
            do {
    //            let url = try await supabase.auth.signInWithOAuth(provider: .google, redirectTo: URL(string: "DevTeamRunnr://"))
                let url = try supabase.auth.getOAuthSignInURL(provider: .google, redirectTo: URL(string: "DevTeamRunnr://"))
                if UIApplication.shared.canOpenURL(url) {
                    await UIApplication.shared.open(url)
                }
            }
            catch {
                print("error : \(error)")
            }
        }
    }
    

}
