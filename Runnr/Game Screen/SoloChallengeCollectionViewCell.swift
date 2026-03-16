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
    
    var challenge: AssignedChallengesProgress?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetCellUI()
                
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resetCellUI()
    }
    
    func configureCell(challenge: AssignedChallengesProgress) {
        
        self.challenge = challenge
        
        self.imageViewChallenge.image = UIImage(systemName: challenge.challengeDetails.SFSymbolName)
        labelChallengeHeading.text = challenge.challengeDetails.title
        labelRewardPoints.text = "+" + String(challenge.challengeDetails.rewardPoints)
        labelRewardPoints.sizeToFit()
        labelRewardPoints.frame.size.width += 15
        labelRewardPoints.frame.size.height += 10
        labelRewardPoints.frame.origin.x = viewCellBackground.frame.origin.x + viewCellBackground.frame.width - 20 - labelRewardPoints.frame.width
        
        labelChallengeDescription.text = "Goal: " + challenge.challengeDetails.description
        labelCompletionPercent.text = "\(Int(progressChallengeCompletion.progress * 100))%"
        
        if let totalSessions = challenge.challengeDetails.totalSessions {
            labelCompletionNumber.text = "\(challenge.assignedChallenge.currentProgress) / \(totalSessions) " + challenge.challengeDetails.goalUnit
            progressChallengeCompletion.progress = Float(challenge.assignedChallenge.currentProgress) / Float(totalSessions)

        }
        else {
            labelCompletionNumber.text = String(challenge.assignedChallenge.currentProgress) + " / " + String(challenge.challengeDetails.goalValue) + " " + challenge.challengeDetails.goalUnit
            progressChallengeCompletion.progress = Float(challenge.assignedChallenge.currentProgress) / Float(challenge.challengeDetails.goalValue)
        }
        
        if challenge.assignedChallenge.isCompleted {
            viewGradient.isHidden = false
            
            if challenge.assignedChallenge.rewardClaimed {
                rewardClamiedUpdateUI()
            }
            else {
                self.buttonClaimPoints.backgroundColor = .accent
                self.buttonClaimPoints.setTitle("CLAIM", for: .normal)
                self.buttonClaimPoints.isEnabled = true
                applyGradientIfNeeded(colour: .accentColorLight)
            }
        }
        else {
            viewGradient.isHidden = true
        }
    
    }
            
    @IBAction func claimPointsPressed(_ sender: UIButton) {
        
        self.challenge?.assignedChallenge.rewardClaimed = true
        rewardClamiedUpdateUI()
        
        var userStats = DataSource.shared.getUserStats()
        userStats?.totalPointsEarned += challenge!.challengeDetails.rewardPoints
        
        Task {
            await updateAssignedChallengeRewards(challenge: self.challenge!.assignedChallenge)
            await updateUserStats(userID: userStats!.userID, newStats: userStats!)
        }
    }
    
    func rewardClamiedUpdateUI() {
        self.buttonClaimPoints.backgroundColor = .lightGray
        self.buttonClaimPoints.setTitle("CLAIMED", for: .normal)
        self.buttonClaimPoints.isEnabled = false
        self.viewChallenge.backgroundColor = .darkGray
        self.labelChallengeHeading.textColor = .darkGray
        self.progressChallengeCompletion.progressTintColor = .darkGray
        self.labelCompletionPercent.textColor = .darkGray
        self.labelRewardPoints.backgroundColor = .darkGray
        self.labelRewardPoints.layer.borderColor = UIColor.darkGray.cgColor
        applyGradientIfNeeded(colour: .darkGray)
    }
    
    func resetCellUI() {
        
        self.viewChallenge.layer.cornerRadius = self.viewChallenge.bounds.height / 2
        self.viewChallenge.backgroundColor = .accent
        self.viewChallenge.clipsToBounds = true
        
        self.imageViewChallenge.clipsToBounds = true
        
        self.viewCellBackground.layer.cornerRadius = 15
        self.viewCellBackground.layer.borderWidth = 0

        self.labelRewardPoints.backgroundColor = .accentColorLight
        self.labelRewardPoints.layer.borderColor = UIColor.accent.cgColor
        self.labelRewardPoints.layer.borderWidth = 1
        self.labelRewardPoints.layer.cornerRadius = self.labelRewardPoints.bounds.height / 2
        self.labelRewardPoints.clipsToBounds = true
                
        self.buttonClaimPoints.layer.cornerRadius = self.buttonClaimPoints.bounds.height / 2
        self.buttonClaimPoints.backgroundColor = .lightGray
        self.buttonClaimPoints.setTitle("CLAIMED", for: .normal)
        self.buttonClaimPoints.isEnabled = false
        
        if let sublayers = viewGradient.layer.sublayers {
            sublayers
                .filter { $0 is CAGradientLayer }
                .forEach { $0.removeFromSuperlayer() }
        }
        self.viewGradient.backgroundColor = .clear
        self.viewGradient.clipsToBounds = true
        self.viewGradient.layer.cornerRadius = 15
        self.viewGradient.isHidden = true
        
        self.labelChallengeHeading.textColor = .white
        self.progressChallengeCompletion.progressTintColor = .accent
        self.labelCompletionPercent.textColor = .accent
    }
    
    func applyGradientIfNeeded(colour: UIColor) {
        
        // Remove old gradients (safe for reuse + relayout)
        if let sublayers = viewGradient.layer.sublayers {
            sublayers
                .filter { $0 is CAGradientLayer }
                .forEach { $0.removeFromSuperlayer() }
        }

        self.viewCellBackground.layer.borderColor = colour.cgColor
        self.viewCellBackground.layer.borderWidth = 1
        addHorizontalCardGradient(to: viewGradient, colour: colour)
        
    }
    
    private func addHorizontalCardGradient(to view: UIView, colour: UIColor) {
        // Create gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            colour.cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)  // Left center
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)    // Right center
        gradientLayer.locations = [0.0, 1.0]
        
        // Insert at the bottom so it doesn't cover content
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

}
