//
//  GameOngoingCollectionViewCell.swift
//  Runnr
//
//  Created by Archit Kankaria on 28/11/25.
//

import UIKit

class GameOngoingCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var labelYou: UILabel!
    @IBOutlet weak var labelFriendOngoing: UILabel!
    
    @IBOutlet weak var labelBattleRun: UILabel!
    @IBOutlet weak var progressViewOngoing: UIProgressView!
    
    @IBOutlet weak var labelTimeLeft: UILabel!
    
    @IBOutlet weak var viewBattleRun: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(with model: GameCard) {
        labelBattleRun.text = model.title
        labelYou.text = model.youName
        labelFriendOngoing.text = model.friendName
        progressViewOngoing.progress = model.progress
        labelTimeLeft.text = model.timeLeftText
        viewBattleRun.layer.cornerRadius = 15
        viewBattleRun.clipsToBounds = true
        viewBattleRun.backgroundColor = .cardLightBlack
    }

}
