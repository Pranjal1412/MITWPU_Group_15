//
//  NotificationClubEventTableViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 27/03/26.
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
        self.viewBackground.layer.cornerRadius = 15
        self.viewBackground.layer.borderWidth = 1
        self.viewBackground.layer.borderColor = UIColor(named: "outlineColor")?.cgColor
        
        self.imageClubProfile.layer.cornerRadius = self.imageClubProfile.frame.height / 2
    }

}
