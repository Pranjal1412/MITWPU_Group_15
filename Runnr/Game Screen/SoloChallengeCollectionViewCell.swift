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
    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var buttonClaimPoints: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradientIfNeeded()
    }

    func configureCell() {
        self.viewChallenge.layer.cornerRadius = self.viewChallenge.bounds.height / 2
        self.viewChallenge.clipsToBounds = true
        self.imageViewChallenge.clipsToBounds = true
        self.viewCellBackground.layer.cornerRadius = 15
        self.viewGradient.backgroundColor = .clear
        self.viewGradient.clipsToBounds = true
        self.viewGradient.layer.cornerRadius = 15
        
        self.buttonClaimPoints.layer.cornerRadius = self.buttonClaimPoints.bounds.height / 2
        
        imageViewChallenge.image = UIImage(systemName: "sun.horizon.fill")
        
        labelChallengeHeading.text = String(localized: "Sunrise Run")
        labelRewardPoints.text = "+50"
        labelRewardPoints.sizeToFit()
        labelRewardPoints.frame.size.width += 5
        labelRewardPoints.frame.size.height += 10
        labelRewardPoints.frame.origin.x = viewCellBackground.frame.origin.x + viewCellBackground.frame.width - 20 - labelRewardPoints.frame.width
        
        self.labelRewardPoints.layer.borderWidth = 1
        self.labelRewardPoints.layer.borderColor = UIColor.accent.cgColor
        self.labelRewardPoints.layer.cornerRadius = self.labelRewardPoints.bounds.height / 2
        self.labelRewardPoints.clipsToBounds = true
        
        labelChallengeDescription.text = String(localized: "Goal: Run before 7 AM three days in a week")
        progressChallengeCompletion.progress = 0.2
        labelCompletionPercent.text = "20%"
        labelCompletionNumber.text = "5.0/5.0 Km"
    }
    
    func applyGradientIfNeeded() {
        
        // Remove old gradients (safe for reuse + relayout)
        if progressChallengeCompletion.progress == 1 {
            viewGradient.isHidden = false

            if let sublayers = viewGradient.layer.sublayers {
                sublayers
                    .filter { $0 is CAGradientLayer }
                    .forEach { $0.removeFromSuperlayer() }
            }

            self.viewCellBackground.layer.borderColor = UIColor.accentColorLight.cgColor
            self.viewCellBackground.layer.borderWidth = 0.5
            addHorizontalCardGradient(to: viewGradient)
        } else {
            self.viewCellBackground.layer.borderWidth = 0
            viewGradient.isHidden = true
        }
    }
    
    private func addHorizontalCardGradient(to view: UIView) {
        // Create gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.accentColorLight.cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)  // Left center
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)    // Right center
        gradientLayer.locations = [0.0, 1.0]
        
        // Insert at the bottom so it doesn't cover content
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
        
    @IBAction func claimPointsPressed(_ sender: UIButton) {
        
        self.buttonClaimPoints.backgroundColor = .lightGray
        self.buttonClaimPoints.setTitle("CLAIMED", for: .normal)
        self.buttonClaimPoints.isEnabled = false
        self.viewChallenge.backgroundColor = .darkGray
        self.labelChallengeHeading.textColor = .darkGray
        self.progressChallengeCompletion.progressTintColor = .darkGray
        self.labelCompletionPercent.textColor = .darkGray
        self.viewCellBackground.layer.borderColor = UIColor.darkGray.cgColor
        self.viewCellBackground.layer.borderWidth = 1
    }
}
