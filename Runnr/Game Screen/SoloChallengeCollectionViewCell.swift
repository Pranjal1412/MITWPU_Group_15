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
        configureCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Delay corner radius until after layout
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.imageViewChallenge.layer.cornerRadius = self.imageViewChallenge.bounds.height / 2
            self.imageViewChallenge.clipsToBounds = true
            
            self.viewRewardPoints.layer.cornerRadius = self.viewRewardPoints.bounds.height / 2
        }
    }

    func configureCell() {
        viewCellBackground.layer.cornerRadius = 15
        
        imageViewChallenge.image = UIImage(systemName: "sun.horizon.fill")
        
        labelChallengeHeading.text = String(localized: "Sunrise Run")
        labelRewardPoints.text = "+50"
        
        viewRewardPoints.layer.borderWidth = 1
        viewRewardPoints.layer.borderColor = UIColor.accent.cgColor
        
        labelChallengeDescription.text = String(localized: "Goal: Run before 7 AM three days in a week")
        progressChallengeCompletion.progress = 0.2
        labelCompletionPercent.text = "20%"
        labelCompletionNumber.text = "2.4/5.0 Km"
    }
}
