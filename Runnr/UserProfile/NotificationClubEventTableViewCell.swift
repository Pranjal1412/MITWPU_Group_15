//
//  NotificationClubEventTableViewCell.swift
//  Runnr
//

import UIKit

class NotificationClubEventTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelEventHeading: UILabel!
    @IBOutlet weak var labelEventDescription: UILabel!
    @IBOutlet weak var labelTimestamp: UILabel!
    @IBOutlet weak var imageClubProfile: UIImageView!
    
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
        self.imageClubProfile.layer.cornerRadius = self.imageClubProfile.frame.height / 2
    }
    
    func configure(with notification: RunnrNotification) {
        labelEventHeading.text = notification.title
        labelEventDescription.text = notification.body
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM HH:mm"
        labelTimestamp.text = formatter.string(from: notification.createdAt)
        
        imageClubProfile.image = UIImage(systemName: "calendar.circle.fill")
        imageClubProfile.tintColor = UIColor.accent
        imageClubProfile.backgroundColor = UIColor.accent.withAlphaComponent(0.15)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0))
    }
}
