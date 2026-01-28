//
//  ChallengesCollectionViewCell.swift
//  Runnr
//
//  Created by Pranjal Shinde on 27/01/26.
//

import UIKit

class SoloChallengeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewCellBackground: UIView!
    @IBOutlet weak var imageViewChallenge: UIImageView!
    @IBOutlet weak var labelChallengeHeading: UILabel!
    @IBOutlet weak var labelRewardPoints: UILabel!
    @IBOutlet weak var labelChallengeDescription: UILabel!
    @IBOutlet weak var progressChallengeCompletion: UIProgressView!
    @IBOutlet weak var labelCompletionPercent: UILabel!
    @IBOutlet weak var labelCompletionNumber: UILabel!    
    @IBOutlet weak var viewRewardPoints: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureCell() {
        self.viewCellBackground.layer.cornerRadius = 15
        self.imageViewChallenge.image = UIImage(systemName: "sun.horizon.fill")
        self.imageViewChallenge.layer.cornerRadius = self.imageViewChallenge.frame.height / 2
        self.labelChallengeHeading.text = String(localized: "Sunrise Run")
        self.labelRewardPoints.text = "+50"
        self.viewRewardPoints.layer.cornerRadius = self.viewRewardPoints.frame.height / 2
        self.viewRewardPoints.layer.borderWidth = 1
        self.viewRewardPoints.layer.borderColor = UIColor.accent.cgColor
        self.labelChallengeDescription.text = String(localized: "Goal: Run before 7 AM three days in a week")
        self.progressChallengeCompletion.progress = 0.2
        self.labelCompletionPercent.text = "20%"
        self.labelCompletionNumber.text = "2.4/5.0 Km"
        
    }
    
}
