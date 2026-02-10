//
//  CollectionViewCellClubExploreScreen.swift
//  Runnr
//
//  Created by SDC-USER on 18/11/25.
//
import UIKit

class ExploreScreenCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewExploreClub: UIView!
    @IBOutlet weak var buttonJoinClub: UIButton!
    @IBOutlet weak var clubProfile: UIImageView!
    @IBOutlet weak var NumberOfRunners: UILabel!
    @IBOutlet weak var ClubSport: UILabel!
    @IBOutlet weak var LabelTitle: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewExploreClub.layer.cornerRadius = 10
        viewExploreClub.clipsToBounds = true
        buttonJoinClub.layer.cornerRadius = buttonJoinClub.frame.height / 2
        clubProfile.layer.cornerRadius = 11.89
        clubProfile.clipsToBounds = true
    }

    func configureCell(with data: Club) {
        LabelTitle.text = data.clubName
        ClubSport.text = data.clubSport.rawValue
        //NumberOfRunners.text = data.numberOfMembers
        //clubProfile.image = data.clubProfileImg
    }
}
