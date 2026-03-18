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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptTapped(_ sender: UIButton) {
        labelMessage.text = "Challenge accepted"
        
        if #available(iOS 15.0, *) {
            var acceptConfig = buttonAccept.configuration
            acceptConfig?.title = "Start"
            buttonAccept.configuration = acceptConfig
            
            var declineConfig = buttonDecline.configuration
            declineConfig?.title = "Leave"
            buttonDecline.configuration = declineConfig
        } else {
            buttonAccept.setTitle("Start", for: .normal)
            buttonDecline.setTitle("Leave", for: .normal)
        }
    }
    
}
