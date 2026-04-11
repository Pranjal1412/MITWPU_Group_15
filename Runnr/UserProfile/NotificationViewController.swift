//
//  NotificationViewController.swift
//  Runnr
//
//  Created by Aditi Bhange on 18/03/26.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    private var notifications: [BattleInviteNotification] = DataSource.shared.getBattleInviteNotifications()
    
    // Tracks which rows are in accepted state
    private var acceptedRows: Set<Int> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        setGlassEffect(for: self.closeButton, withImage: "multiply")
        
        let nib = UINib(nibName: "NotificationChallengeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NotificationChallengeTableViewCell")
        tableView.separatorStyle = .none
        loadNotifications()
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadNotifications() {
        guard let userID = DataSource.shared.getUserProfile().userID else { return }
        Task {
            var fetched = await fetchBattleInviteNotifications(for: userID)
            
            // Enrich each notification with the sender's profile image URL
            fetched = await withTaskGroup(of: BattleInviteNotification.self) { group -> [BattleInviteNotification] in
                for notification in fetched {
                    group.addTask {
                        var enriched = notification
                        if let profile = await fetchUserProfile(userId: notification.senderID) {
                            enriched.senderProfileImageURL = profile.userProfileImageURL
                        }
                        return enriched
                    }
                }
                var results: [BattleInviteNotification] = []
                for await result in group {
                    results.append(result)
                }
                return results
            }
            
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                // Only replace dummy/existing data if Supabase returns real rows
                if !fetched.isEmpty {
                    self.notifications = fetched
                    DataSource.shared.setBattleInviteNotifications(fetched)
                }
                self.tableView?.reloadData()
            }
        }
    }

}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationChallengeTableViewCell", for: indexPath) as! NotificationChallengeTableViewCell
        
        let notification = notifications[indexPath.row]
        cell.configure(with: notification)
        
        // Re-apply accepted visual state for rows already accepted
        if acceptedRows.contains(indexPath.row) {
            let myImageURL = DataSource.shared.getUserProfile().userProfileImageURL
            cell.showAcceptedState(senderImageURL: notification.senderProfileImageURL,
                                   receiverImageURL: myImageURL)
        }
        
        cell.onAccept = { [weak self] in
            guard let self = self else { return }
            guard let gameID = notification.gameID else { return }
            let receiverID = notification.receiverID
            
            Task {
                // Use the receiverID from the notification — this is always the invited player's ID,
                // set at invite time, so it's correct regardless of which device runs this code.
                await updateGamePlayerTwo(gameID: gameID, playerTwoID: receiverID)
                DataSource.shared.setGameID(gameID)
            }
            
            // Mark row as accepted and update UI
            self.acceptedRows.insert(indexPath.row)
            let myImageURL = DataSource.shared.getUserProfile().userProfileImageURL
            cell.showAcceptedState(senderImageURL: notification.senderProfileImageURL,
                                   receiverImageURL: myImageURL)
            
            // Refresh row height for the new layout
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        cell.onDecline = { [weak self] in
            guard let self = self else { return }
            guard indexPath.row < self.notifications.count else { return }
            self.notifications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
