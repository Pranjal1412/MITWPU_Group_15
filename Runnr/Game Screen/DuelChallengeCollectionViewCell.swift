import UIKit

class DuelChallengeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelWeeklyClash: UILabel!
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
    @IBOutlet var trailingLabel: UIView!
    @IBOutlet var trailingView: UIView!
    @IBOutlet var yourProgress: UIView!
    @IBOutlet var opponentProgress: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet weak var labelTrailingValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        imageViewYou.isHidden = true
        imageViewOpponent.isHidden = true
        viewYourName.isHidden = true
        viewOpponent.isHidden = true
        viewVS.isHidden = true
        trailingView.isHidden = true
        labelTrailingValue.isHidden = true
        
        viewCellBackground.layer.cornerRadius = 15
        viewCellBackground.clipsToBounds = true
        
        viewYourName.layer.cornerRadius = viewYourName.frame.height/2
        viewOpponent.layer.cornerRadius = viewOpponent.frame.height/2
        viewOpponent.backgroundColor = .white
        
        viewReward.layer.cornerRadius = 10
        viewReward.layer.borderWidth = 1
        viewReward.layer.borderColor = UIColor.accent.cgColor
        
        trailingView.layer.cornerRadius = trailingView.frame.height / 2
    }
    
    func setExpanded() {
        imageViewYou.isHidden.toggle()
        imageViewOpponent.isHidden.toggle()
        viewYourName.isHidden.toggle()
        viewOpponent.isHidden.toggle()
        viewVS.isHidden.toggle()
        trailingView.isHidden.toggle()
        labelTrailingValue.isHidden.toggle()
        
        imageViewYou.layer.cornerRadius = imageViewYou.frame.height / 2
        imageViewYou.layer.borderWidth = 2
        imageViewYou.layer.borderColor = UIColor.accent.cgColor
        
        imageViewOpponent.layer.cornerRadius = imageViewOpponent.frame.height / 2
        imageViewOpponent.layer.borderWidth = 2
        imageViewOpponent.layer.borderColor = UIColor.white.cgColor
        
        viewVS.layer.cornerRadius = viewVS.frame.height / 2
        viewVS.clipsToBounds = true
        
    }
    
}

