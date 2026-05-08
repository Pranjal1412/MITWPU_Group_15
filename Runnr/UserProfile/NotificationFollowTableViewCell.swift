//
//  NotificationFollowTableViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 26/03/26.
//

import UIKit

class NotificationFollowTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imageUserProfile: UIImageView!
    @IBOutlet weak var buttonFollow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func setupUI() {
        self.viewBackground.layer.cornerRadius = 15
        self.viewBackground.layer.borderWidth = 1
        self.viewBackground.layer.borderColor = UIColor(named: "outlineColor")?.cgColor
        self.imageUserProfile.layer.cornerRadius = self.imageUserProfile.frame.height / 2
    }
    
    
}
