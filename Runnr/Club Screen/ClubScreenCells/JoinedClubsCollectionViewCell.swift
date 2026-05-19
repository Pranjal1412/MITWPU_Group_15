//
//  JoinedClubsCollectionViewCell.swift
//  Runnr
//
//  Created by Aditi Bhange on 07/01/26.
//

import UIKit
import Kingfisher

class JoinedClubsCollectionViewCell: UICollectionViewCell {

    @IBOutlet var clubProfileImage: UIImageView!
    @IBOutlet var labelClubName: UILabel!
    @IBOutlet var labelNumberOfRunners: UILabel!
    @IBOutlet var labelSportType: UILabel!
    @IBOutlet var joinedClubView: UIView!
    @IBOutlet weak var imageSportType: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        joinedClubView.layer.cornerRadius = 10
        joinedClubView.clipsToBounds = true

        clubProfileImage.layer.cornerRadius = 10
        clubProfileImage.clipsToBounds = true
    }

    func configureCell(with data: ClubRoleAndData) {
        labelClubName.text = data.club.clubName
        labelSportType.text = data.club.clubSport?.rawValue

        if let url = URL(string: data.club.clubProfileImageURL ?? "") {
            self.clubProfileImage.kf.setImage(with: url)
        }
        else {
            self.clubProfileImage.image = UIImage(named: "Club")
        }

        let formattedNumberOfMembers = formatMemberCount(data.club.memberCount ?? 0)
        labelNumberOfRunners.text = String(formattedNumberOfMembers)

        imageSportType.image = UIImage(systemName: setSportImage(for: data.club.clubSport!.rawValue))
        // ClubProfileImage.image = data.clubProfileImg
    }

}
