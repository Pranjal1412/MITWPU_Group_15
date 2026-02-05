//
//  ChallengesCollectionViewCell.swift
//  Runnr
//
//  Created by Pranjal Shinde on 27/01/26.
//

import UIKit

class SoloChallengeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewCellBackground: UIView!
    @IBOutlet weak var viewChallenge: UIView!
    @IBOutlet weak var imageViewChallenge: UIImageView!
    @IBOutlet weak var labelChallengeHeading: UILabel!
    @IBOutlet weak var labelRewardPoints: UILabel!
    @IBOutlet weak var labelChallengeDescription: UILabel!
    @IBOutlet weak var progressChallengeCompletion: UIProgressView!
    @IBOutlet weak var labelCompletionPercent: UILabel!
    @IBOutlet weak var labelCompletionNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Delay corner radius until after layout
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.viewChallenge.layer.cornerRadius = self.viewChallenge.bounds.height / 2
            self.viewChallenge.clipsToBounds = true
            self.imageViewChallenge.clipsToBounds = true
            
        }
    }

    func configureCell() {
        viewCellBackground.layer.cornerRadius = 15
        
        imageViewChallenge.image = UIImage(systemName: "sun.horizon.fill")
        
        labelChallengeHeading.text = String(localized: "Sunrise Run")
        labelRewardPoints.text = "+50"
        
        self.labelRewardPoints.layer.borderWidth = 1
        self.labelRewardPoints.layer.borderColor = UIColor.accent.cgColor
        self.labelRewardPoints.layer.cornerRadius = self.labelRewardPoints.bounds.height / 2
        self.labelRewardPoints.clipsToBounds = true
        
        labelChallengeDescription.text = String(localized: "Goal: Run before 7 AM three days in a week")
        progressChallengeCompletion.progress = 0.2
        labelCompletionPercent.text = "20%"
        labelCompletionNumber.text = "2.4/5.0 Km"
    }
}
