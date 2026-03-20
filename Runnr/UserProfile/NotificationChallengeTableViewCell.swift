//
//  NotificationChallengeTableViewCell.swift
//  Runnr
//
//  Created by Aditi Bhange on 18/03/26.
//

import UIKit

class NotificationChallengeTableViewCell: UITableViewCell {

    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var stackViewButtons: UIStackView!
    @IBOutlet weak var buttonAccept: UIButton!
    @IBOutlet weak var buttonDecline: UIButton!
    
    var onAccept: (() -> Void)?
    var onDecline: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
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

