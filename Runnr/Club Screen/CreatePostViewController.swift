//
//  CreatePostViewController.swift
//  Runnr
//
//  Created by SDC-USER on 04/03/26.
//

import UIKit
import PhotosUI
import Kingfisher

class CreatePostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mediaContainerView: UIView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var bottomActionsStack: UIStackView!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var addPhotosView: UIView!
    @IBOutlet weak var clubNameLabel: UILabel!
    
    private let userProfile = DataSource.shared.getUserProfile()
    let placeholderText = "What's on your mind?"
    var clubDetails: Club?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Ensure dashed border frame updates correctly if resized
        if let dashedLayer = mediaContainerView.layer.sublayers?.first(where: { $0.name == "dashedBorder" }) as? CAShapeLayer {
            dashedLayer.path = UIBezierPath(roundedRect: mediaContainerView.bounds, cornerRadius: 16).cgPath
            dashedLayer.frame = mediaContainerView.bounds
        }
        
    }
    
    @IBAction func addPostImage(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraButton = UIAlertAction(title: String(localized: "Camera"), style: .default, handler: {_ in
            self.openCamera()
        })
        let photoLibraryButton = UIAlertAction(title: String(localized: "Gallery"), style: .default, handler: {_ in
            self.openPhotoLibrary()
        })
        let cancelButton = UIAlertAction(title: String("Cancel"), style: .cancel)
        
        alert.addAction(cameraButton)
        alert.addAction(photoLibraryButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true)
    }
    
    private func setupUI() {
        
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.cardLightBlack.cgColor
        textView.layer.cornerRadius = 15
        buttonSave.layer.cornerRadius = buttonSave.frame.height / 2
        buttonCancel.layer.cornerRadius = buttonSave.frame.height / 2
        setGlassEffect(for: buttonSave, withImage: "checkmark")
        setGlassEffect(for: buttonCancel, withImage: "multiply")
        // Profile Image setup
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        if let url = URL(string: clubDetails!.clubProfileImageURL!) {
            profileImageView.kf.setImage(with: url)
        }
        
        clubNameLabel.text = clubDetails?.clubName
        textView.delegate = self
        textView.text = placeholderText
        textView.textColor = .darkGray
        
        setupMediaContainer()
        self.imagePost.clipsToBounds = true
        self.mediaContainerView.clipsToBounds = true
    }

    private func setupMediaContainer() {
        // Dashed Border
        let dashedBorder = CAShapeLayer()
        dashedBorder.name = "dashedBorder"
        dashedBorder.strokeColor = UIColor.darkGray.cgColor
        dashedBorder.fillColor = nil
        dashedBorder.lineDashPattern = [6, 4]
        dashedBorder.lineWidth = 1
        mediaContainerView.layer.addSublayer(dashedBorder)
        
        // Add StackView for center content
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 15
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        mediaContainerView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: mediaContainerView.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: mediaContainerView.centerYAnchor)
        ])
        
        self.addPhotosView.layer.cornerRadius = addPhotosView.layer.frame.height / 2
        self.addPhotosView.clipsToBounds = true
        
    }

    
    // MARK: - UITextViewDelegate Placeholder Logic
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .darkGray
        }
    }

    @IBAction func cancelTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Discard Changes", message: "Do you want to discard your current changes?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let discardAction = UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.dismiss(animated: true)

        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(discardAction)
        self.present(alertController, animated: true)

    }
    
    @IBAction func postTapped(_ sender: UIButton) {
        Task {
            let newPost = ClubPost(clubID: clubDetails!.clubID, postOwner: userProfile.userID, caption: textView.text, postImageURL: "", likeCount: 0, createdTimestamp: Date())
            
            var post = await insertNewClubPost(postDetails: newPost)!
            
            if let postID = post.postID {
                let imageURl = await saveClubPostImage(postID: postID, with: self.imagePost.image!)
                post.postImageURL = imageURl
            }
            
            await updateClubPost(postDetails: post)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension CreatePostViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openPhotoLibrary() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }

        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        for result in results {
            let provider = result.itemProvider
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self.imagePost.image = image
                        }
                    }
                }
            }
        }
                
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            self.imagePost.image = image
        }
    }
}


//    private func setupBottomActions() {
//        bottomActionsStack.backgroundColor = UIColor(white: 0.11, alpha: 1)
//
//        let actions = [
//            ("person.badge.plus", "Tag People", UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1)),
//            ("mappin.and.ellipse", "Add Location", UIColor(red: 0.8, green: 0.3, blue: 0.3, alpha: 1)),
//            ("figure.run", "Link Recent Run", UIColor(red: 0.4, green: 0.6, blue: 0.1, alpha: 1))
//        ]
//
//        for (index, action) in actions.enumerated() {
//            let rowView = createActionRow(iconName: action.0, title: action.1, tintColor: action.2)
//            bottomActionsStack.addArrangedSubview(rowView)
//
//            // Add separator
//            if index < actions.count - 1 {
//                let separator = UIView()
//                separator.backgroundColor = UIColor(white: 0.2, alpha: 1)
//                separator.translatesAutoresizingMaskIntoConstraints = false
//                bottomActionsStack.addSubview(separator)
//                NSLayoutConstraint.activate([
//                    separator.heightAnchor.constraint(equalToConstant: 0.5),
//                    separator.leadingAnchor.constraint(equalTo: bottomActionsStack.leadingAnchor, constant: 60),
//                    separator.trailingAnchor.constraint(equalTo: bottomActionsStack.trailingAnchor),
//                    separator.bottomAnchor.constraint(equalTo: rowView.bottomAnchor)
//                ])
//            }
//        }
//    }
//
//    private func createActionRow(iconName: String, title: String, tintColor: UIColor) -> UIView {
//        let container = UIView()
//        container.translatesAutoresizingMaskIntoConstraints = false
//
//        // Icon circular background
//        let iconBg = UIView()
//        iconBg.backgroundColor = UIColor(white: 0.18, alpha: 1)
//        iconBg.layer.cornerRadius = 18
//        iconBg.translatesAutoresizingMaskIntoConstraints = false
//        container.addSubview(iconBg)
//
//        // Icon Image
//        let iconView = UIImageView(image: UIImage(systemName: iconName))
//        iconView.tintColor = tintColor
//        iconView.contentMode = .scaleAspectFit
//        iconView.translatesAutoresizingMaskIntoConstraints = false
//        iconBg.addSubview(iconView)
//
//        // Title Label
//        let label = UILabel()
//        label.text = title
//        label.textColor = .white
//        label.font = .systemFont(ofSize: 16, weight: .medium)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        container.addSubview(label)
//
//        // Chevron right
//        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
//        chevron.tintColor = .systemGray
//        chevron.contentMode = .scaleAspectFit
//        chevron.translatesAutoresizingMaskIntoConstraints = false
//        container.addSubview(chevron)
//
//        // Button Overly to handle tap
//        let btn = UIButton(type: .system)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        container.addSubview(btn)
//
//        NSLayoutConstraint.activate([
//            container.heightAnchor.constraint(equalToConstant: 60),
//
//            iconBg.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
//            iconBg.centerYAnchor.constraint(equalTo: container.centerYAnchor),
//            iconBg.widthAnchor.constraint(equalToConstant: 36),
//            iconBg.heightAnchor.constraint(equalToConstant: 36),
//
//            iconView.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
//            iconView.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
//            iconView.widthAnchor.constraint(equalToConstant: 20),
//            iconView.heightAnchor.constraint(equalToConstant: 20),
//
//            label.leadingAnchor.constraint(equalTo: iconBg.trailingAnchor, constant: 16),
//            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
//
//            chevron.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
//            chevron.centerYAnchor.constraint(equalTo: container.centerYAnchor),
//            chevron.widthAnchor.constraint(equalToConstant: 12),
//            chevron.heightAnchor.constraint(equalToConstant: 16),
//
//            btn.topAnchor.constraint(equalTo: container.topAnchor),
//            btn.bottomAnchor.constraint(equalTo: container.bottomAnchor),
//            btn.leadingAnchor.constraint(equalTo: container.leadingAnchor),
//            btn.trailingAnchor.constraint(equalTo: container.trailingAnchor)
//        ])
//
//        return container
//    }
