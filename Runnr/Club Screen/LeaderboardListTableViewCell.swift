//
//  LeaderBoardTableViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 05/01/26.
//

import UIKit

class LeaderboardListTableViewCell: UITableViewCell {

    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelRank: UILabel!
    @IBOutlet var labelValue: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
    }
    
    func configure(rank: Int, name: String, value: String) {
        labelRank.text = "\(rank)"
        labelName.text = name
        labelValue.text = value
    }
    
}
