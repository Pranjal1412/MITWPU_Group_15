//
//  NotificationChallengeTableViewCell.swift
//  Runnr
//
//  Created by Aditi Bhange on 18/03/26.
//

import UIKit

class NotificationChallengeTableViewCell: UITableViewCell {

    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var buttonAccept: UIButton!
    @IBOutlet weak var buttonDecline: UIButton!
    @IBOutlet weak var viewNotificationBackground: UIView!
    @IBOutlet weak var imageviewGameIcon: UIImageView!
    @IBOutlet weak var labelNotificationHeading: UILabel!
    
    var onAccept: (() -> Void)?
    var onDecline: (() -> Void)?

    // MARK: - VS View (programmatic)
    private let vsContainerView = UIView()
    private let playerOneImageView = UIImageView()
    private let playerTwoImageView = UIImageView()
    private let vsLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonAccept.layer.cornerRadius = buttonAccept.frame.height / 2
        self.buttonDecline.layer.cornerRadius = buttonDecline.frame.height / 2
        self.imageviewGameIcon.layer.cornerRadius = self.imageviewGameIcon.frame.height / 2
        self.imageviewGameIcon.layer.borderColor = UIColor.accent.cgColor
        self.imageviewGameIcon.layer.borderWidth = 0.5
        self.viewNotificationBackground.layer.cornerRadius = 15
        self.viewNotificationBackground.layer.borderColor = UIColor(named: "outlineColor")?.cgColor
        self.viewNotificationBackground.layer.borderWidth = 1
        
        setupVSView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - VS View Setup
    private func setupVSView() {
        // Container hidden until accepted
        vsContainerView.isHidden = true
        vsContainerView.translatesAutoresizingMaskIntoConstraints = false
        viewNotificationBackground.addSubview(vsContainerView)
        
        // Player image views
        [playerOneImageView, playerTwoImageView].forEach { iv in
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.layer.cornerRadius = 28
            iv.layer.borderWidth = 2
            iv.layer.borderColor = UIColor.accent.cgColor
            iv.backgroundColor = UIColor(named: "AccentColorLight") ?? .systemGray5
            iv.image = UIImage(systemName: "person.circle.fill")
            iv.tintColor = UIColor(named: "AccentColor") ?? .systemGreen
        }
        
        vsLabel.translatesAutoresizingMaskIntoConstraints = false
        vsLabel.text = "VS"
        vsLabel.textAlignment = .center
        vsLabel.font = UIFont(name: "SFPro-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
        vsLabel.textColor = UIColor.accent
        
        vsContainerView.addSubview(playerOneImageView)
        vsContainerView.addSubview(vsLabel)
        vsContainerView.addSubview(playerTwoImageView)
        
        NSLayoutConstraint.activate([
            // Container anchored below the message label (same area as buttons)
            vsContainerView.leadingAnchor.constraint(equalTo: viewNotificationBackground.leadingAnchor, constant: 15),
            vsContainerView.trailingAnchor.constraint(equalTo: viewNotificationBackground.trailingAnchor, constant: -15),
            vsContainerView.bottomAnchor.constraint(equalTo: viewNotificationBackground.bottomAnchor, constant: -12),
            vsContainerView.heightAnchor.constraint(equalToConstant: 56),
            
            // Player One image
            playerOneImageView.leadingAnchor.constraint(equalTo: vsContainerView.leadingAnchor),
            playerOneImageView.centerYAnchor.constraint(equalTo: vsContainerView.centerYAnchor),
            playerOneImageView.widthAnchor.constraint(equalToConstant: 56),
            playerOneImageView.heightAnchor.constraint(equalToConstant: 56),
            
            // VS label in center
            vsLabel.centerXAnchor.constraint(equalTo: vsContainerView.centerXAnchor),
            vsLabel.centerYAnchor.constraint(equalTo: vsContainerView.centerYAnchor),
            
            // Player Two image
            playerTwoImageView.trailingAnchor.constraint(equalTo: vsContainerView.trailingAnchor),
            playerTwoImageView.centerYAnchor.constraint(equalTo: vsContainerView.centerYAnchor),
            playerTwoImageView.widthAnchor.constraint(equalToConstant: 56),
            playerTwoImageView.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
    
    // MARK: - Configure
    func configure(with notification: BattleInviteNotification) {
        labelMessage.text = notification.message
        buttonAccept.isHidden = false
        buttonDecline.isHidden = false
        vsContainerView.isHidden = true
    }
    
    // MARK: - Show accepted state with VS player images
    func showAcceptedState(senderImageURL: String?, receiverImageURL: String?) {
        labelMessage.text = "Challenge accepted! 🎮"
        buttonAccept.isHidden = true
        buttonDecline.isHidden = true
        vsContainerView.isHidden = false
        
        loadImage(from: senderImageURL, into: playerOneImageView)
        loadImage(from: receiverImageURL, into: playerTwoImageView)
    }
    
    private func loadImage(from urlString: String?, into imageView: UIImageView) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
    
    @IBAction func acceptTapped(_ sender: UIButton) {
        onAccept?()
    }
    
    @IBAction func declineTapped(_ sender: UIButton) {
        onDecline?()
    }
    
}
