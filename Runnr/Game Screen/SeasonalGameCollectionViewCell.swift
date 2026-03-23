//
//  SeasonalGameCollectionViewCell.swift
//  Runnr
//
//  Created by Pranjal Shinde on 27/01/26.
//

import UIKit

class SeasonalGameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewCellBackground: UIView!
    @IBOutlet weak var labelMonthlyEvent: UILabel!
    @IBOutlet weak var labelSeason1Month: UILabel!
    @IBOutlet weak var viewGreyLine: UIView!
    @IBOutlet weak var viewMonthlyEvent: UIView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var buttonInviteFriend: UIButton!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var progressViewCapturedTiles: UIProgressView!
    @IBOutlet weak var labelGoal: UILabel!
    @IBOutlet weak var imageViewGameBackground: UIImageView!
    @IBOutlet weak var labelBattleRun: UILabel!
    @IBOutlet weak var viewCountDown: UIView!
    
    let userProfile = DataSource.shared.getUserProfile()
    
    // Closure called when user taps "Invite Friend" — set by the parent VC
    var onInviteFriendTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    // One-time visual setup only — no async work here
    func configure() {
        viewCellBackground.layer.cornerRadius = 15
        viewCountDown.layer.cornerRadius = 15
        viewCellBackground.clipsToBounds = true
        if(progressViewCapturedTiles.progress == 1){
            viewCountDown.isHidden = false
        }
        viewMonthlyEvent.layer.cornerRadius = viewMonthlyEvent.frame.height / 2
        viewMonthlyEvent.clipsToBounds = true
        
        buttonInviteFriend.layer.cornerRadius = buttonInviteFriend.frame.size.height / 2
        buttonInviteFriend.clipsToBounds = true
        imageView1.layer.cornerRadius = imageView1.frame.size.height / 2
        imageView1.clipsToBounds = true
        imageView2.layer.cornerRadius = imageView1.frame.size.height / 2
        imageView2.clipsToBounds = true
        imageView3.layer.cornerRadius = imageView1.frame.size.height / 2
        imageView3.clipsToBounds = true
        
        labelGoal.isHidden = true  // permanently hidden — progress bar is shown instead
        refreshData()
    }

    // Called every time the cell is displayed (from cellForItemAt) to get fresh data
    func refreshData() {
        Task {
            guard let userID = userProfile.userID else { return }

            if let cachedGameID = DataSource.shared.getGameID() {
                // Verify the game still exists in Supabase (may have been deleted)
                if let _ = await fetchActiveGameForUser(userID: userID) {
                    await MainActor.run {
                        buttonInviteFriend.isEnabled = false
                        buttonInviteFriend.backgroundColor = .systemGray2
                    }
                    await updateTileProgress(gameID: cachedGameID)
                } else {
                    // Deleted from Supabase — clear stale cache and reset UI
                    DataSource.shared.clearGameID()
                    await MainActor.run {
                        buttonInviteFriend.isEnabled = true
                        buttonInviteFriend.backgroundColor = .accent
                        progressViewCapturedTiles.progress = 0
                    }
                }
                return
            }

            // No cached ID — check Supabase directly
            if let existingGame = await fetchActiveGameForUser(userID: userID),
               let gameID = existingGame.gameID {
                DataSource.shared.setGameID(gameID)
                await MainActor.run {
                    buttonInviteFriend.isEnabled = false
                    buttonInviteFriend.backgroundColor = .systemGray2
                }
                await updateTileProgress(gameID: gameID)
            } else {
                // No active game at all
                await MainActor.run {
                    buttonInviteFriend.isEnabled = true
                    buttonInviteFriend.backgroundColor = .accent
                    progressViewCapturedTiles.progress = 0
                }
            }
        }
    }

    private func updateTileProgress(gameID: UUID) async {
        if let tiles = await fetchGameTileStatus(gameID: gameID) {
            let capturedCount = tiles.filter { $0.ownerID != nil }.count
            let totalTiles = 19
            await MainActor.run {
                progressViewCapturedTiles.isHidden = false
                progressViewCapturedTiles.progress = Float(capturedCount) / Float(totalTiles)
                viewCountDown.isHidden = (capturedCount < totalTiles)
            }
        }
    }
    
    @IBAction func inviteFriendClicked(_ sender: UIButton) {
        onInviteFriendTapped?()
    }
    

}
