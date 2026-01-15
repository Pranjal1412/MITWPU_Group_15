//
//  ClubProfileTableViewCell.swift
//  Runnr
//
//  Created by Aditi Bhange on 15/12/25.
//

import UIKit


class ClubLeaderboardTableViewCell: UITableViewCell {
    
    @IBOutlet var levelName: UILabel!
    @IBOutlet var levelDescription: UILabel!
    @IBOutlet var chevron: NSLayoutConstraint!
    @IBOutlet var badgeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with data: LeaderBoard) {
        levelName.text = data.levelName
        levelDescription.text = data.levelDescription
        badgeImage.image = UIImage(named: data.badge)
    }
}
