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
    @IBOutlet var viewJoinedClub: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        joinedClubView.layer.cornerRadius = 10
        joinedClubView.clipsToBounds = true
        
        ClubProfileImage.layer.cornerRadius = 10
        ClubProfileImage.clipsToBounds = true
    }
    
    private func shortForm(for activity: String) -> String {
        switch activity {
        case "Hiking":
            return "Hike"
        case "Running":
            return "Run"
        case "Walking":
            return "Walk"
        case "Marathons":
            return "Mar"
        default:
            return activity
        }
    }
        
    func configureCell(with data: MyClubData) {
        ClubName.text = data.clubName
        Sport.text = shortForm(for: data.sport)
        NumberOfRunners.text = data.numberOfMembers
        ClubProfileImage.image = data.clubProfileImg
    }
   
}

