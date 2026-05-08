//
//  NotificationViewController.swift
//  Runnr
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    private var battleNotifications: [BattleInviteNotification] = DataSource.shared.getBattleInviteNotifications()
    private var generalNotifications: [RunnrNotification] { NotificationManager.shared.notifications }
    private var acceptedRows: Set<Int> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableView.automaticDimension
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.contentInset = .zero
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        
        setGlassEffect(for: self.closeButton, withImage: "multiply")
        
        let challengeNib = UINib(nibName: "NotificationChallengeTableViewCell", bundle: nil)
        tableView.register(challengeNib, forCellReuseIdentifier: "NotificationChallengeTableViewCell")
        
        let clubNib = UINib(nibName: "NotificationClubEventTableViewCell", bundle: nil)
        tableView.register(clubNib, forCellReuseIdentifier: "NotificationClubEventTableViewCell")
        
        tableView.separatorStyle = .none
        
        NotificationManager.shared.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        
        loadNotifications()
        
        Task {
            await NotificationManager.shared.markAllRead()
        }
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadNotifications() {
        guard let userID = DataSource.shared.getUserProfile().userID else { return }
        Task {
            var fetched = await fetchBattleInviteNotifications(for: userID)
            
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
                for await result in group { results.append(result) }
                return results
            }
            
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                if !fetched.isEmpty {
                    self.battleNotifications = fetched
                    DataSource.shared.setBattleInviteNotifications(fetched)
                }
                self.tableView?.reloadData()
            }
        }
    }
}

// MARK: - TableView
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Only show "Challenges" header when there are battle notifications, nothing for general
        if section == 0 {
            return battleNotifications.isEmpty ? nil : "Challenges"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && !battleNotifications.isEmpty {
            return UITableView.automaticDimension
        }
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? battleNotifications.count : generalNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationChallengeTableViewCell", for: indexPath) as! NotificationChallengeTableViewCell
            let notification = battleNotifications[indexPath.row]
            cell.configure(with: notification)
            
            if acceptedRows.contains(indexPath.row) {
                let myImageURL = DataSource.shared.getUserProfile().userProfileImageURL
                cell.showAcceptedState(senderImageURL: notification.senderProfileImageURL,
                                       receiverImageURL: myImageURL)
            }
            
            cell.onAccept = { [weak self] in
                guard let self = self else { return }
                guard let gameID = notification.gameID else { return }
                Task { await updateGamePlayerTwo(gameID: gameID, playerTwoID: notification.receiverID) }
                DataSource.shared.setGameID(gameID)
                self.acceptedRows.insert(indexPath.row)
                let myImageURL = DataSource.shared.getUserProfile().userProfileImageURL
                cell.showAcceptedState(senderImageURL: notification.senderProfileImageURL,
                                       receiverImageURL: myImageURL)
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
            cell.onDecline = { [weak self] in
                guard let self = self else { return }
                guard indexPath.row < self.battleNotifications.count else { return }
                self.battleNotifications.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationClubEventTableViewCell", for: indexPath) as! NotificationClubEventTableViewCell
            cell.configure(with: generalNotifications[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
