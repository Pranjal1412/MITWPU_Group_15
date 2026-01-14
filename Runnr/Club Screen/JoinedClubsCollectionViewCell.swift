//
//  JoinedClubsCollectionViewCell.swift
//  Runnr
//
//  Created by Aditi Bhange on 07/01/26.
//

import UIKit

class JoinedClubsCollectionViewCell: UICollectionViewCell {

    @IBOutlet var ClubProfileImage: UIImageView!
    @IBOutlet var ClubName: UILabel!
    @IBOutlet var NumberOfRunners: UILabel!
    @IBOutlet var Sport: UILabel!
    @IBOutlet var joinedClubView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        joinedClubView.layer.cornerRadius = 10
        joinedClubView.clipsToBounds = true
    }
    func configureCell(with data: MyClubData) {
        ClubName.text = data.clubName
        Sport.text = data.sport
        NumberOfRunners.text = data.numberOfMembers
        ClubProfileImage.image = data.clubProfileImg
    }
}

