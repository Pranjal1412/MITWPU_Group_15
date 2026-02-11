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
    @IBOutlet weak var imageSportType: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        joinedClubView.layer.cornerRadius = 10
        joinedClubView.clipsToBounds = true
        
        ClubProfileImage.layer.cornerRadius = 10
        ClubProfileImage.clipsToBounds = true
    }
            
    func configureCell(with data: ClubRoleAndData) {
        ClubName.text = data.club.clubName
        Sport.text = data.club.clubSport.rawValue
        
        let formattedNumberOfMembers = formatMemberCount(data.club.memberCount)
        NumberOfRunners.text = String(formattedNumberOfMembers)

        imageSportType.image = UIImage(systemName: setSportImage(for: data.club.clubSport.rawValue))
        //ClubProfileImage.image = data.clubProfileImg
    }
   
}

