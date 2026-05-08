//
//  NotificationFollowTableViewCell.swift
//  Runnr
//

import UIKit
import Kingfisher

class NotificationFollowTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imageUserProfile: UIImageView!
    @IBOutlet weak var labelMessage: UILabel!
    // @IBOutlet weak var buttonFollow: UIButton!
    @IBOutlet weak var labelTimeStamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func setupUI() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.viewBackground.layer.cornerRadius = 15
        self.viewBackground.layer.borderWidth = 1
        self.viewBackground.layer.borderColor = UIColor(named: "outlineColor")?.cgColor
        self.viewBackground.clipsToBounds = true
        self.imageUserProfile.layer.cornerRadius = self.imageUserProfile.frame.height / 2
        self.imageUserProfile.clipsToBounds = true
        self.imageUserProfile.contentMode = .scaleAspectFill
        self.labelMessage.numberOfLines = 0
        self.labelTimeStamp.numberOfLines = 0
    }
    
    func configure(with notification: RunnrNotification, followerName: String, followerImageURL: String?) {
        labelMessage.text = "\(followerName) started following you"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM HH:mm"
        labelTimeStamp.text = formatter.string(from: notification.createdAt)
        
        if let urlString = followerImageURL, let url = URL(string: urlString) {
            imageUserProfile.kf.setImage(with: url, placeholder: UIImage(systemName: "person.circle.fill"))
        } else {
            imageUserProfile.image = UIImage(systemName: "person.circle.fill")
            imageUserProfile.tintColor = UIColor.accent
        }
        
        // buttonFollow.isHidden = true
    }
}
