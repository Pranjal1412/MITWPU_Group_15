//
//  LoginViewController.swift
//  Runnr
//

import UIKit
import Supabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var viewEmailBackground: UIView!
    @IBOutlet weak var viewPasswordBackground: UIView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonGoogle: UIButton!
    @IBOutlet weak var buttonApple: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    
    let supabase = SupabaseManager.shared.client
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        
        settingTitle()
        settingViews()
        settingButton()
        settingTextFields()
    }
    
    // MARK: - Keyboard
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Setup
    
    func settingTitle() {
        let thinFont = UIFont(name: "SF-Pro-Display-Thin", size: 33) ?? UIFont.systemFont(ofSize: 33, weight: .thin)
        let boldFont = UIFont(name: "SF-Pro-Display-Bold", size: 33) ?? UIFont.boldSystemFont(ofSize: 35)
        
        let thinText = NSAttributedString(string: String(localized: "Login to"), attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        let boldText = NSAttributedString(string: String(localized: " Runnr"), attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(thinText)
        attributedString.append(boldText)
        
        labelScreenTitle.attributedText = attributedString
        labelScreenTitle.sizeToFit()
    }
    
    func settingViews() {
        viewEmailBackground.backgroundColor = .clear
        viewPasswordBackground.backgroundColor = .clear
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
    
    func settingTextFields() {
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
        
        textFieldEmail.keyboardType = .emailAddress
        textFieldEmail.autocapitalizationType = .none
        textFieldEmail.autocorrectionType = .no
        textFieldEmail.returnKeyType = .next
        textFieldEmail.textColor = .white
        textFieldEmail.attributedPlaceholder = NSAttributedString(
            string: String(localized: "Email"),
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.returnKeyType = .done
        textFieldPassword.textColor = .white
        textFieldPassword.attributedPlaceholder = NSAttributedString(
            string: String(localized: "Password"),
            attributes: [.foregroundColor: UIColor.lightGray]
        )
    }
    
    // MARK: - Validation
    
    func validateInputs() -> Bool {
        guard let email = textFieldEmail.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: String(localized: "Missing Email"), message: String(localized: "Please enter your email address."))
            return false
        }
        guard let password = textFieldPassword.text, !password.isEmpty else {
            showAlert(title: String(localized: "Missing Password"), message: String(localized: "Please enter your password."))
            return false
        }
        return true
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String(localized: "OK"), style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard validateInputs() else { return }
        
        let email = textFieldEmail.text!.trimmingCharacters(in: .whitespaces)
        let password = textFieldPassword.text!
        
        buttonLogin.isEnabled = false
        
        Task {
            do {
                let session = try await supabase.auth.signIn(
                    email: email,
                    password: password
                )
                
                await MainActor.run {
                    self.buttonLogin.isEnabled = true
                    Task {
                        await NotificationManager.shared.start(userId: session.user.id)
                    }
                    isSignUpComplete = true
                    self.navigationController?.popToRootViewController(animated: false)
                }
            } catch {
                await MainActor.run {
                    self.buttonLogin.isEnabled = true
                    self.showAlert(title: String(localized: "Login Failed"), message: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonGooglePressed(_ sender: UIButton) {
        Task {
            do {
                try await supabase.auth.signInWithOAuth(
                    provider: .google,
                    redirectTo: URL(string: "DevTeamRunnr://login-callback")
                )
                await self.checkSession()
            } catch {
                print("Google sign-in error: \(error)")
            }
        }
    }
    
    // MARK: - Session
    
    func checkSession() async {
        if let session = supabase.auth.currentSession {
            Task {
                await NotificationManager.shared.start(userId: session.user.id)
            }
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
