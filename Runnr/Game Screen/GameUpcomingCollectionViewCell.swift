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
        progressViewUpcoming.setProgress(model.progress, animated: false)
    }
}
