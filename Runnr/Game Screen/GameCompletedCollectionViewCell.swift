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
        self.viewCompleted.backgroundColor = .cardLightBlack
        self.viewCompleted.layer.cornerRadius = 15
        self.viewCompleted.clipsToBounds = true
        
        self.labelYourBlocks.sizeToFit()
        self.labelFriendBlocks.sizeToFit()
    }
    
    func configure(with model: CompletedGameCard) {
        self.labelTitle.text = model.title
        self.labelCompleted.text = model.completed
        self.labelYou.text = model.youName
        self.labelFriend.text = model.friendName
        self.labelYourBlocks.text = model.yourBlocks
        self.labelFriendBlocks.text = model.friendBlocks
        self.labelWinner.text = model.Winner
    }

}
