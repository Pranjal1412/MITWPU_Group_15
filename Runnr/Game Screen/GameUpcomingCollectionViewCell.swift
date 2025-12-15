//
//  GameUpcomingCollectionViewCell.swift
//  Runnr
//
//  Created by Nidhi Aralkar on 14/12/25.
//

import UIKit

class GameUpcomingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewBattleRun: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelUpcoming: UILabel!
    @IBOutlet weak var labelYourName: UILabel!
    @IBOutlet weak var labelFriendName: UILabel!
    @IBOutlet weak var labelGetReady: UILabel!
    @IBOutlet weak var progressViewUpcoming: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Make progress track visible even when progress = 0
        progressViewUpcoming.progressTintColor = .clear
        progressViewUpcoming.trackTintColor = UIColor.white.withAlphaComponent(0.4)
        progressViewUpcoming.layer.cornerRadius = 1.5
        progressViewUpcoming.clipsToBounds = true
        progressViewUpcoming.progress = 0

        viewBattleRun.layer.cornerRadius = 15
        viewBattleRun.clipsToBounds = true
        viewBattleRun.backgroundColor = .cardLightBlack
    }

    func configure(with model: UpcomingGameCard) {
        labelTitle.text = model.title
        labelUpcoming.text = model.upcoming
        labelYourName.text = model.youName
        labelFriendName.text = model.friendName
        labelGetReady.text = model.getReady

        // Keep progress at 0 without animation
        progressViewUpcoming.setProgress(model.progress, animated: false)
    }
}
