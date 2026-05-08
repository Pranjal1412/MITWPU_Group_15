//
//  SignUpViewController.swift
//  Runnr
//
//  Created by SDC-USER on 08/12/25.
//

import UIKit
import Supabase

class LoginViewController: UIViewController {

    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var viewEmailBackground: UIView!
    @IBOutlet weak var viewPasswordBackground: UIView!
    @IBOutlet weak var buttonGoogle: UIButton!
    @IBOutlet weak var buttonApple: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonBack: UIButton!

    let supabase = SupabaseManager.shared.client
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        settingTitle()
        SettingViews()
        settingButton()
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        isSignUpComplete = true
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func settingTitle() {
        let thinFont = UIFont(name: "SF-Pro-Display-Thin", size: 33) ?? UIFont.systemFont(ofSize: 33, weight: .thin)
        let boldFont = UIFont(name: "SF-Pro-Display-Bold", size: 33) ?? UIFont.boldSystemFont(ofSize: 35)
        
        let thinText = NSAttributedString(string: String(localized: "Login to"), attributes: [.font: thinFont , .foregroundColor: UIColor.white])
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
        
        viewEmailBackground.layer.borderColor = UIColor.lightGray.cgColor
        viewPasswordBackground.layer.borderColor = UIColor.lightGray.cgColor
        
        viewEmailBackground.layer.borderWidth = 0.5
        viewPasswordBackground.layer.borderWidth = 0.5
    }
    
    func settingButton() {
        buttonLogin.layer.cornerRadius = buttonLogin.frame.height / 2
        buttonLogin.setTitle(String(localized: "Login"), for: .normal)
        buttonApple.layer.cornerRadius = buttonApple.frame.height / 2
        buttonGoogle.layer.cornerRadius = buttonGoogle.frame.height / 2
        
        setGlassEffect(for: self.buttonBack, withImage: "chevron.backward")
    }
    
    @IBAction func buttonGooglePressed(_ sender: UIButton) {
        print("Google Button Tapped")
        Task {
            do {
                try await supabase.auth.signInWithOAuth(provider: .google, redirectTo: URL(string: "DevTeamRunnr://login-callback"))
                await self.checkSession()
            }
            catch {
                print("error : \(error)")
            }
        }
    }
    func checkSession() async {
        if let session = supabase.auth.currentSession {
            Task {
                await NotificationManager.shared.start(userId: session.user.id)
            }
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
}
