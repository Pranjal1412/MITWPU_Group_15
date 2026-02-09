import UIKit

class DuelChallengeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelWeeklyClash: UILabel!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var viewCellBackground: UIView!
    @IBOutlet weak var labelCriteria: UILabel!
    @IBOutlet weak var imageViewYou: UIImageView!
    @IBOutlet weak var imageViewOpponent: UIImageView!
    @IBOutlet weak var viewYourName: UIView!
    @IBOutlet weak var labelYourName: UILabel!
    @IBOutlet weak var viewReward: UIView!
    @IBOutlet weak var labelReward: UILabel!
    @IBOutlet weak var viewOpponent: UIView!
    @IBOutlet weak var labelOpponentsName: UILabel!
    @IBOutlet weak var viewVS: UIView!
    @IBOutlet weak var labelVS: UILabel!

    private let progressBar = DualProgressBarView()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupProgressBar()
        configure()
    }

    private func setupProgressBar() {
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressContainerView.addSubview(progressBar)

        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: progressContainerView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: progressContainerView.trailingAnchor),
            progressBar.topAnchor.constraint(equalTo: progressContainerView.topAnchor),
            progressBar.bottomAnchor.constraint(equalTo: progressContainerView.bottomAnchor)
        ])

        // TEMP DATA (replace later)
        progressBar.maxValue = 10
        progressBar.leftValue = 7.4
        progressBar.rightValue = 5.8
    }

    func configure() {
        
        viewCellBackground.layer.cornerRadius = 15
        viewCellBackground.clipsToBounds = true

        imageViewYou.layer.cornerRadius = imageViewYou.frame.size.height / 2
        imageViewYou.layer.borderWidth = 2
        imageViewYou.layer.borderColor = UIColor.accent.cgColor

        imageViewOpponent.layer.cornerRadius = imageViewOpponent.frame.size.height / 2
        imageViewOpponent.layer.borderWidth = 2
        imageViewOpponent.layer.borderColor = UIColor.white.cgColor

        viewVS.layer.cornerRadius = viewVS.frame.size.height / 2
        viewVS.clipsToBounds = true

        viewYourName.layer.cornerRadius = 10
        viewOpponent.layer.cornerRadius = 10

        labelVS.textColor = .black
        labelYourName.textColor = .black
        labelOpponentsName.textColor = .black

        viewOpponent.backgroundColor = .white

        viewReward.layer.cornerRadius = 10
        viewReward.layer.borderWidth = 1
        viewReward.layer.borderColor = UIColor.accent.cgColor
    }
}

