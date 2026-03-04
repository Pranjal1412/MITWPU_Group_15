//
//  CreatePostViewController.swift
//  Runnr
//
//  Created by SDC-USER on 04/03/26.
//

import UIKit

class CreatePostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mediaContainerView: UIView!
    @IBOutlet weak var bottomActionsStack: UIStackView!
    
    let placeholderText = "What's on your mind?"

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

    private func setupUI() {
        // Post Button glow effect
        postButton.layer.shadowColor = UIColor(named: "AccentColor")?.cgColor ?? UIColor.green.cgColor
        postButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        postButton.layer.shadowRadius = 8
        postButton.layer.shadowOpacity = 0.5
        
        // Profile Image setup
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.image = UIImage(named: "club1") // Use existing asset or default
        
        // Text View Setup
        textView.delegate = self
        textView.text = placeholderText
        textView.textColor = .darkGray
        
        setupMediaContainer()
        setupBottomActions()
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
        
        // Icon View
        let iconContainer = UIView()
        iconContainer.backgroundColor = UIColor(white: 0.2, alpha: 1)
        iconContainer.layer.cornerRadius = 30
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 60),
            iconContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        let iconImageView = UIImageView(image: UIImage(systemName: "photo.badge.plus"))
        iconImageView.tintColor = .lightGray
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        // Labels
        let titleLabel = UILabel()
        titleLabel.text = "Add Photo or Video"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "High quality media looks best"
        subtitleLabel.textColor = .systemGray
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        contentStack.addArrangedSubview(iconContainer)
        contentStack.addArrangedSubview(titleLabel)
        
        // Add spacing between title and subtitle visually
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelStack.axis = .vertical
        labelStack.alignment = .center
        labelStack.spacing = 6
        
        contentStack.addArrangedSubview(iconContainer)
        contentStack.addArrangedSubview(labelStack)
    }

    private func setupBottomActions() {
        bottomActionsStack.backgroundColor = UIColor(white: 0.11, alpha: 1)
        
        let actions = [
            ("person.badge.plus", "Tag People", UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1)),
            ("mappin.and.ellipse", "Add Location", UIColor(red: 0.8, green: 0.3, blue: 0.3, alpha: 1)),
            ("figure.run", "Link Recent Run", UIColor(red: 0.4, green: 0.6, blue: 0.1, alpha: 1))
        ]
        
        for (index, action) in actions.enumerated() {
            let rowView = createActionRow(iconName: action.0, title: action.1, tintColor: action.2)
            bottomActionsStack.addArrangedSubview(rowView)
            
            // Add separator
            if index < actions.count - 1 {
                let separator = UIView()
                separator.backgroundColor = UIColor(white: 0.2, alpha: 1)
                separator.translatesAutoresizingMaskIntoConstraints = false
                bottomActionsStack.addSubview(separator)
                NSLayoutConstraint.activate([
                    separator.heightAnchor.constraint(equalToConstant: 0.5),
                    separator.leadingAnchor.constraint(equalTo: bottomActionsStack.leadingAnchor, constant: 60),
                    separator.trailingAnchor.constraint(equalTo: bottomActionsStack.trailingAnchor),
                    separator.bottomAnchor.constraint(equalTo: rowView.bottomAnchor)
                ])
            }
        }
    }
    
    private func createActionRow(iconName: String, title: String, tintColor: UIColor) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // Icon circular background
        let iconBg = UIView()
        iconBg.backgroundColor = UIColor(white: 0.18, alpha: 1)
        iconBg.layer.cornerRadius = 18
        iconBg.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(iconBg)
        
        // Icon Image
        let iconView = UIImageView(image: UIImage(systemName: iconName))
        iconView.tintColor = tintColor
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconBg.addSubview(iconView)
        
        // Title Label
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        // Chevron right
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .systemGray
        chevron.contentMode = .scaleAspectFit
        chevron.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(chevron)
        
        // Button Overly to handle tap
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(btn)
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 60),
            
            iconBg.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconBg.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconBg.widthAnchor.constraint(equalToConstant: 36),
            iconBg.heightAnchor.constraint(equalToConstant: 36),
            
            iconView.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            
            label.leadingAnchor.constraint(equalTo: iconBg.trailingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            chevron.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 12),
            chevron.heightAnchor.constraint(equalToConstant: 16),
            
            btn.topAnchor.constraint(equalTo: container.topAnchor),
            btn.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            btn.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        return container
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

    // MARK: - Actions
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postTapped(_ sender: UIButton) {
        // Handle Post logic here
        self.dismiss(animated: true, completion: nil)
    }
}
