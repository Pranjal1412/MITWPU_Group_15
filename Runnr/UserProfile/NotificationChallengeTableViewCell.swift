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
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with notification: BattleInviteNotification) {
        labelMessage.text = notification.message
    }
    
    @IBAction func acceptTapped(_ sender: UIButton) {
        onAccept?()
    }
    
    @IBAction func declineTapped(_ sender: UIButton) {
        onDecline?()
    }
    
}

