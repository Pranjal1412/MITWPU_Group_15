//
//  NotificationViewController.swift
//  Runnr
//
//  Created by Aditi Bhange on 18/03/26.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var notifications: [BattleInviteNotification] = [BattleInviteNotification(senderID: UUID(uuidString: "70cbd046-c94f-4941-9988-a3ae88398a26")!, receiverID: UUID(uuidString: "24fc68d0-fe86-4863-8166-d2368d179718")!, senderName: "Archit", message: "Game 1", isRead: false)]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "NotificationChallengeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NotificationChallengeTableViewCell")
        
        loadNotifications()
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadNotifications() {
        guard let userID = DataSource.shared.getUserProfile().userID else { return }
        Task {
            let fetched = await fetchBattleInviteNotifications(for: userID)
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
            
            cell.labelMessage.text = "Challenge accepted!"
            cell.stackViewButtons.isHidden = true
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
        return 122
    }
}

