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
    
    var followAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        buttonFollow.layer.cornerRadius = buttonFollow.frame.height / 2
        
        imageProfileFriends.layer.cornerRadius = imageProfileFriends.frame.height / 2
        imageProfileFriends.clipsToBounds = true
    }

    func configureCell(with data: friendsData) {
        FriendName.text = data.name
        imageProfileFriends.image = UIImage(named: data.profilePhoto)

        if data.isFollowing {
            buttonFollow.setTitle("Following", for: .normal)
            buttonFollow.backgroundColor = .lightGray
        } else {
            buttonFollow.setTitle("Follow", for: .normal)
            buttonFollow.backgroundColor = .accent
        }
    }

    @IBAction func followButtonTapped(_ sender: UIButton) {
        followAction?()
    }
    
}
