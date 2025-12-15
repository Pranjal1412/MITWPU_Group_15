//
//  GameCompletedCollectionViewCell.swift
//  Runnr
//
//  Created by Nidhi Aralkar on 14/12/25.
//

import UIKit

class GameCompletedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewCompleted: UIView!
    @IBOutlet weak var labelFriend: UILabel!
    @IBOutlet weak var labelYourBlocks: UILabel!
    @IBOutlet weak var labelWinner: UILabel!
    @IBOutlet weak var labelFriendBlocks: UILabel!
    @IBOutlet weak var labelYou: UILabel!
    @IBOutlet weak var labelCompleted: UILabel!
    override func awakeFromNib() {
            super.awakeFromNib()
        viewCompleted.backgroundColor = .cardLightBlack
        viewCompleted.layer.cornerRadius = 15
        viewCompleted.clipsToBounds = true
        }
    func configure(with model: CompletedGameCard) {
        labelTitle.text = model.title
        labelCompleted.text = model.completed
        labelYou.text = model.youName
        labelFriend.text = model.friendName
        labelYourBlocks.text = model.yourBlocks
        labelFriendBlocks.text = model.friendBlocks
        labelWinner.text = model.Winner

    }

}
