//
//  CollectionViewCellClubExploreScreen.swift
//  Runnr
//
//  Created by SDC-USER on 18/11/25.
//
import UIKit
import Kingfisher

class ExploreScreenCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewExploreClub: UIView!
    @IBOutlet weak var clubProfile: UIImageView!
    @IBOutlet weak var numberOfRunners: UILabel!
    @IBOutlet weak var clubSport: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageSportType: UIImageView!
    var joinAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        viewExploreClub.layer.cornerRadius = 10
        viewExploreClub.clipsToBounds = true
        clubProfile.layer.cornerRadius = 11.89
        clubProfile.clipsToBounds = true
    }

    func configureCell(with data: Club) {
        labelTitle.text = data.clubName
        clubSport.text = data.clubSport?.rawValue
        numberOfRunners.text = String(data.memberCount ?? 0)

        if let url = URL(string: data.clubProfileImageURL ?? "") {
            clubProfile.kf.setImage(with: url)
        } else {
            self.clubProfile.image = UIImage(named: "Club")
        }
    }
}
