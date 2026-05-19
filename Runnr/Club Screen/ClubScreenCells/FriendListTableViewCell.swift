//
//  FriendListTableViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 17/11/25.
//

import UIKit
import Kingfisher

class FriendListTableViewCell: UITableViewCell {

    @IBOutlet weak var imageProfileFriends: UIImageView!
    @IBOutlet var friendName: UILabel!
    @IBOutlet var buttonFollow: UIButton!
    
    var isFollowing = false
    var followAction: ((Bool) -> Void)?
    var followerID = DataSource.shared.getUserProfile().userID
    var followingID: UUID?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonFollow.layer.cornerRadius = buttonFollow.frame.height / 2
        
        imageProfileFriends.layer.cornerRadius = imageProfileFriends.frame.height / 2
        imageProfileFriends.clipsToBounds = true
    }

    func configureCell(with data: UserProfile) {
        friendName.text = data.userName
        
        if let url = URL(string: data.userProfileImageURL!) {
            self.imageProfileFriends.kf.setImage(with: url)
        }
        
        self.followingID = data.userID
        
        buttonFollow.setTitle("Follow", for: .normal)
        buttonFollow.backgroundColor = .accent
    }

    @IBAction func followButtonTapped(_ sender: UIButton) {
        if isFollowing == true {
            followAction?(isFollowing)
            buttonFollow.setTitle("Follow", for: .normal)
            buttonFollow.backgroundColor = .accent
            isFollowing = false
        }
        else {
            Task {
                await insertFollowedUser(followerID: followerID!, followingID: followingID!)
            }
            buttonFollow.setTitle("Following", for: .normal)
            buttonFollow.backgroundColor = .lightGray
            isFollowing = true
        }
    }
    
}
