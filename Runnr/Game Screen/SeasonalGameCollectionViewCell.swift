//
//  SeasonalGameCollectionViewCell.swift
//  Runnr
//
//  Created by Pranjal Shinde on 27/01/26.
//

import UIKit
import Supabase

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

    private var countdownLabels: [UILabel] = []
    private var countdownTimer: Timer?
    private var overlayView: UIView?

    let userProfile = DataSource.shared.getUserProfile()

    // Closure called when user taps "Invite Friend" — set by the parent VC
    var onInviteFriendTapped: (() -> Void)?
    // Closure called when game ends
    var onGameEnded: ((Bool) -> Void)?

    private func updateSeasonLabel(for date: Date = Date()) {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let formatter = DateFormatter()
        formatter.locale = .current // or Locale(identifier: "en_US") for a fixed language
        formatter.dateFormat = "LLLL" // full month name in the current locale
        let monthName = formatter.string(from: date)
        let seasonNumber = month // Season number aligns with month number
        labelSeason1Month.text = "SEASON \(seasonNumber): \(monthName) Conquest"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    // One-time visual setup only — no async work here
    func configure() {
        viewCellBackground.layer.cornerRadius = 15
        viewCountDown.layer.cornerRadius = 15
        viewCellBackground.clipsToBounds = true
        if progressViewCapturedTiles.progress == 1 {
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

        overlayView = viewCountDown.superview
        setupCountdownLabels()
        refreshData()
        updateSeasonLabel()

    }

    private func setupCountdownLabels() {
        var labels: [UILabel] = []
        for subview in viewCountDown.subviews {
            if let container = subview as? UIView, container.subviews.count == 1, let label = container.subviews.first as? UILabel {
                if label.font.pointSize == 24 {
                    labels.append(label)
                }
            }
        }
        labels.sort { $0.superview!.frame.minX < $1.superview!.frame.minX }
        countdownLabels = labels
    }

    private func updateCountdownUI(timeRemaining: TimeInterval) {
        guard countdownLabels.count == 4 else { return }

        let days = Int(timeRemaining) / 86400
        let hours = (Int(timeRemaining) % 86400) / 3600
        let minutes = (Int(timeRemaining) % 3600) / 60
        let seconds = Int(timeRemaining) % 60

        countdownLabels[0].text = String(format: "%02d", days)
        countdownLabels[1].text = String(format: "%02d", hours)
        countdownLabels[2].text = String(format: "%02d", minutes)
        countdownLabels[3].text = String(format: "%02d", seconds)
    }

    private func checkGameAvailability() -> (isActive: Bool, timeRemaining: TimeInterval?) {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day, .month, .year], from: now)

        if let day = components.day, day >= 1 && day <= 20 {
            return (true, nil)
        } else {
            var nextMonthComponents = DateComponents()
            nextMonthComponents.month = 1
            let nextMonth = calendar.date(byAdding: nextMonthComponents, to: now)!

            var startOfNextMonthComponents = calendar.dateComponents([.month, .year], from: nextMonth)
            startOfNextMonthComponents.day = 1
            startOfNextMonthComponents.hour = 0
            startOfNextMonthComponents.minute = 0
            startOfNextMonthComponents.second = 0

            let startOfNextMonth = calendar.date(from: startOfNextMonthComponents)!
            let timeRemaining = startOfNextMonth.timeIntervalSince(now)
            return (false, timeRemaining)
        }
    }

    private func startCountdown(timeRemaining: TimeInterval) {
        countdownTimer?.invalidate()
        var remaining = timeRemaining

        updateCountdownUI(timeRemaining: remaining)
        overlayView?.isHidden = false
        buttonInviteFriend.isEnabled = false
        buttonInviteFriend.backgroundColor = .systemGray2

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            remaining -= 1
            if remaining <= 0 {
                timer.invalidate()
                self.refreshData() // Refresh to unlock the game
            } else {
                self.updateCountdownUI(timeRemaining: remaining)
            }
        }
    }

    private func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        overlayView?.isHidden = true
    }

    // Called every time the cell is displayed (from cellForItemAt) to get fresh data
    func refreshData() {
        Task {
            await MainActor.run { self.updateSeasonLabel() }
            guard let userID = userProfile.userID else { return }

            let availability = checkGameAvailability()

            if !availability.isActive {
                // Game is currently inactive (e.g., after the 10th)
                if let existingGame = await fetchActiveGameForUser(userID: userID), let gameID = existingGame.gameID {
                    await settleGame(gameID: gameID, timeRemaining: availability.timeRemaining)
                } else {
                    await MainActor.run {
                        buttonInviteFriend.isEnabled = false
                        buttonInviteFriend.backgroundColor = .systemGray2
                        progressViewCapturedTiles.progress = 0
                        if let timeRemaining = availability.timeRemaining {
                            startCountdown(timeRemaining: timeRemaining)
                        }
                    }
                }
                return
            }

            // Game IS active (days 1-10)
            if let cachedGameID = DataSource.shared.getGameID() {
                // Verify the game still exists in Supabase (may have been deleted)
                if let _ = await fetchActiveGameForUser(userID: userID) {
                    await MainActor.run {
                        buttonInviteFriend.isEnabled = false
                        buttonInviteFriend.backgroundColor = .systemGray2
                        stopCountdown()
                    }
                    await updateTileProgress(gameID: cachedGameID)
                } else {
                    // Deleted from Supabase — clear stale cache and reset UI
                    DataSource.shared.clearGameID()
                    await MainActor.run {
                        buttonInviteFriend.isEnabled = true
                        buttonInviteFriend.backgroundColor = .accent
                        progressViewCapturedTiles.progress = 0
                        stopCountdown()
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
                    stopCountdown()
                }
                await updateTileProgress(gameID: gameID)
            } else {
                // No active game at all, user can start one
                await MainActor.run {
                    buttonInviteFriend.isEnabled = true
                    buttonInviteFriend.backgroundColor = .accent
                    progressViewCapturedTiles.progress = 0
                    stopCountdown()
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
            }

            if capturedCount >= totalTiles {
                // User finished the game early
                await settleGame(gameID: gameID)
            }
        }
    }

    private func settleGame(gameID: UUID, timeRemaining: TimeInterval? = nil) async {
        if let tiles = await fetchGameTileStatus(gameID: gameID) {
            let capturedCount = tiles.filter { $0.ownerID != nil }.count
            let myTilesCount = tiles.filter { $0.ownerID == self.userProfile.userID }.count
            let opponentTilesCount = capturedCount - myTilesCount
            let isWinner = myTilesCount >= opponentTilesCount

            await updateGameAsCompleted(gameID: gameID)
            DataSource.shared.clearGameID()

            await MainActor.run {
                self.onGameEnded?(isWinner)

                if let tr = timeRemaining {
                    startCountdown(timeRemaining: tr)
                } else {
                    // Finished early, calculate time to next month
                    let calendar = Calendar.current
                    var nextMonthComponents = DateComponents()
                    nextMonthComponents.month = 1
                    let nextMonth = calendar.date(byAdding: nextMonthComponents, to: Date())!
                    var startOfNextMonthComponents = calendar.dateComponents([.month, .year], from: nextMonth)
                    startOfNextMonthComponents.day = 1
                    let startOfNextMonth = calendar.date(from: startOfNextMonthComponents)!
                    let tRemaining = startOfNextMonth.timeIntervalSince(Date())
                    startCountdown(timeRemaining: tRemaining)
                }
            }
        }
    }

    @IBAction func inviteFriendClicked(_ sender: UIButton) {
        onInviteFriendTapped?()
    }

    private func updateGameAsCompleted(gameID: UUID) async {
        do {
            try await SupabaseManager.shared.client
                .from("TerritoryGame")
                .update(["isCompleted": true])
                .eq("gameID", value: gameID)
                .execute()
            print("Game marked as completed.")
        } catch {
            print("updateGameAsCompleted failed: \\(error)")
        }
    }
}
