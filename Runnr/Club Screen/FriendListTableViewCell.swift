//
//  FriendListTableViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 17/11/25.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {

    @IBOutlet weak var imageProfileFriends: UIImageView!
    
    @IBOutlet var buttonFollow: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        buttonFollow.titleLabel?.textColor = UIColor.black
        
    }

   
}


