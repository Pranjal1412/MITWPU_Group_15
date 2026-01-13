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
    
    @IBOutlet var viewJoinedClub: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewJoinedClub.layer.cornerRadius = 10
        viewJoinedClub.clipsToBounds = true
        
    }
    func configureCell(with data: myClubData) {
        ClubName.text = data.clubName
        Sport.text = data.sport
        NumberOfRunners.text = data.numberOfMembers
        ClubProfileImage.image = UIImage(named: data.clubProfileImg)
        
    }
}

