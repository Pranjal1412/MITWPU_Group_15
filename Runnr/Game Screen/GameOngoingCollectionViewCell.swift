//
//  GameOngoingCollectionViewCell.swift
//  Runnr
//
//  Created by Archit Kankaria on 28/11/25.
//

import UIKit

class GameOngoingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelYou: UILabel!
    @IBOutlet weak var labelFriendOngoing: UILabel!
    @IBOutlet weak var labelBattleRun: UILabel!
    @IBOutlet weak var progressViewOngoing: UIProgressView!
    @IBOutlet weak var labelTimeLeft: UILabel!
    @IBOutlet weak var viewBattleRun: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model: CurrentGameCard) {
        self.labelBattleRun.text = model.title
        self.labelYou.text = model.youName
        self.labelFriendOngoing.text = model.friendName
        self.progressViewOngoing.progress = model.progress
        self.labelTimeLeft.text = model.timeLeftText
        self.viewBattleRun.layer.cornerRadius = 15
        self.viewBattleRun.clipsToBounds = true
        self.viewBattleRun.backgroundColor = .cardLightBlack
    }

}
