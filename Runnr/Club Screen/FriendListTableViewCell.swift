//
//  FriendListTableViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 17/11/25.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {

    @IBOutlet weak var imageProfileFriends: UIImageView!
    @IBOutlet var FriendName: UILabel!
    
    @IBOutlet var buttonFollow: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        buttonFollow.layer.cornerRadius = buttonFollow.frame.height / 2.0
        
    }

    func configureCell(with data: friendsData) {
       
        //buttonFollow.textLabel?.text = data.followStatus
        FriendName.text = data.name
        imageProfileFriends.image = UIImage(named: data.profilePhoto)
    }
}


