//
//  JoinUsViewController.swift
//  Runnr
//

import UIKit
import Auth
import Supabase

class JoinUsViewController: UIViewController {

    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var viewEmailBackground: UIView!
    @IBOutlet weak var viewPasswordBackground: UIView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonGoogle: UIButton!
    @IBOutlet weak var buttonApple: UIButton!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var buttonBack: UIButton!

    let supabase = SupabaseManager.shared.client
    var userProfile = DataSource.shared.getUserProfile()

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

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func settingTitle() {
        let thinFont = UIFont(name: "SF-Pro-Display-Thin", size: 33) ?? UIFont.systemFont(ofSize: 33, weight: .thin)
        let boldFont = UIFont(name: "SF-Pro-Display-Bold", size: 33) ?? UIFont.boldSystemFont(ofSize: 35)

        let thinText = NSAttributedString(string: "SignUp to", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        let boldText = NSAttributedString(string: " RUNR.", attributes: [.font: boldFont, .foregroundColor: UIColor.white])

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
        buttonGoogle.isUserInteractionEnabled = true
        buttonGoogle.bringSubviewToFront(buttonGoogle.titleLabel!)
        setGlassEffect(for: self.buttonBack, withImage: "chevron.backward")
        self.buttonBack.tintColor = .white
        self.buttonBack.setImage(UIImage(systemName: "chevron.left"), for: .normal)
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

    func validateInputs() -> Bool {
        guard let email = textFieldEmail.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: String(localized: "Missing Email"), message: String(localized: "Please enter your email address."))
            return false
        }
        guard email.contains("@"), email.contains(".") else {
            showAlert(title: String(localized: "Invalid Email"), message: String(localized: "Please enter a valid email address."))
            return false
        }
        guard let password = textFieldPassword.text, password.count >= 6 else {
            showAlert(title: String(localized: "Weak Password"), message: String(localized: "Password must be at least 6 characters."))
            return false
        }
        return true
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String(localized: "OK"), style: .default))
        present(alert, animated: true)
    }

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard validateInputs() else { return }

        let email = textFieldEmail.text!.trimmingCharacters(in: .whitespaces)
        let password = textFieldPassword.text!

        buttonSignUp.isEnabled = false

        Task {
            do {
                let response = try await supabase.auth.signUp(
                    email: email,
                    password: password
                )

                await MainActor.run {
                    self.buttonSignUp.isEnabled = true

                    if response.session == nil {
                        self.showAlert(
                            title: String(localized: "Check Your Email"),
                            message: String(localized: "A confirmation link has been sent to \(email). Please verify your email before logging in.")
                        )
                        return
                    }

                    self.userProfile.userID = response.user.id
                    self.userProfile.emailAddress = response.user.email ?? ""
                    DataSource.shared.setUserProfile(self.userProfile)

                    let destinationVC = SetProfileViewController()
                    destinationVC.modalPresentationStyle = .fullScreen
                    self.present(destinationVC, animated: true)
                }
            } catch {
                await MainActor.run {
                    self.buttonSignUp.isEnabled = true
                    self.showAlert(title: String(localized: "Sign Up Failed"), message: error.localizedDescription)
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
                self.checkSession()
            } catch {
                print("Google sign-in error: \(error)")
            }
        }
    }

    // MARK: - Session

    func checkSession() {
        if let session = supabase.auth.currentSession {
            let user = session.user
            
            Task {
                if let userProfile = await fetchUserProfile(userId: user.id) {
                    DataSource.shared.setUserProfile(userProfile)
                    isSignUpComplete = true
                    self.navigationController?.popToRootViewController(animated: false)
                }
                else {
                    self.userProfile.userID = user.id
                    self.userProfile.emailAddress = user.email ?? ""
                    self.userProfile.userName = user.userMetadata["full_name"]?.stringValue ?? ""
                    self.userProfile.userProfileImageURL = user.userMetadata["avatar_url"]?.stringValue ?? ""
                    DataSource.shared.setUserProfile(self.userProfile)
                    
                    let destinationVC = SetProfileViewController()
                    destinationVC.modalPresentationStyle = .fullScreen
                    self.present(destinationVC, animated: true)
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension JoinUsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
