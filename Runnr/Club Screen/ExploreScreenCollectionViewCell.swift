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

    func configureCell(with data: ExploreClubData) {
        LabelTitle.text = data.clubName
        ClubSport.text = data.sport
        NumberOfRunners.text = data.numberOfMembers
        clubProfile.image = data.clubProfileImg
    }
}

//    settingLabelStyle(withValue: data.number, withUnit: data.unit)
//    labelCardTitle.text = data.title
//    labelTrend.text = data.trend
//    imageViewChevron.image = UIImage(systemName: data.trendChevron)
//    struct clubData: Codable {
//        let image: String
//        let clubName: String
//        let numberOfMembers: String
//        let sport: String
//    }
