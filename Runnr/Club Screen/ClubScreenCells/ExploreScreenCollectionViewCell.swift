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
    @IBOutlet weak var buttonJoinClub: UIButton!
    @IBOutlet weak var clubProfile: UIImageView!
    @IBOutlet weak var NumberOfRunners: UILabel!
    @IBOutlet weak var ClubSport: UILabel!
    @IBOutlet weak var LabelTitle: UILabel!
    @IBOutlet weak var imageSportType: UIImageView!
    var joinAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewExploreClub.layer.cornerRadius = 10
        viewExploreClub.clipsToBounds = true
        buttonJoinClub.layer.cornerRadius = buttonJoinClub.frame.height / 2
        clubProfile.layer.cornerRadius = 11.89
        clubProfile.clipsToBounds = true
        
        buttonJoinClub.addTarget(self, action: #selector(joinTapped), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        buttonJoinClub.setTitle("Join", for: .normal)
        buttonJoinClub.setTitleColor(.black, for: .normal)
        buttonJoinClub.backgroundColor = .accent
        buttonJoinClub.layer.borderWidth = 0
    }

    @objc func joinTapped() {
        if buttonJoinClub.title(for: .normal) == "Join" {
            buttonJoinClub.setTitle("Joined", for: .normal)
            buttonJoinClub.setTitleColor(.accent, for: .normal)
            buttonJoinClub.backgroundColor = .black
            buttonJoinClub.layer.borderColor = UIColor.accent.cgColor
            buttonJoinClub.layer.borderWidth = 1
            
            joinAction?()
        }
    }

    func configureCell(with data: Club) {
        LabelTitle.text = data.clubName
        ClubSport.text = data.clubSport.rawValue
        NumberOfRunners.text = String(data.memberCount)
//        MARK: - Force unwrap
//        imageSportType.image = UIImage(systemName: setSportImage(for: data.clubSport.rawValue))
        if let url = URL(string: data.clubProfileImageURL!) {
            clubProfile.kf.setImage(with: url)
        }
    }
}
