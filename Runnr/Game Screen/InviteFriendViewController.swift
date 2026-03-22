//
//  InviteFriendViewController.swift
//  Runnr
//
//  Created on 20/03/26.
//

import UIKit

class InviteFriendViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    
    private var friendsList: [UserProfile] = []
    private let userProfile = DataSource.shared.getUserProfile()
    
    // Called after an invite is successfully sent, passing back the invited friend's userID
    var onInviteSent: ((UUID) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.overrideUserInterfaceStyle = .dark
        
        setupUI()
        loadFriends()
    }
    
    private func setupUI() {
        // Title
        titleLabel.text = "Invite a Friend"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FriendListTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadFriends() {
        guard let userID = userProfile.userID else { return }
        Task {
            let following = await fetchFollowingList(userID: userID)
            await MainActor.run {
                self.friendsList = following
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - TableView DataSource & Delegate

extension InviteFriendViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! FriendListTableViewCell
        let friend = friendsList[indexPath.row]
        
        cell.configureCell(with: friend)
        
        // Override button title to "Invite" instead of "Follow"
        cell.buttonFollow.setTitle("Invite", for: .normal)
        cell.buttonFollow.backgroundColor = .accent
        
        // Override the follow action to send an invite instead
        cell.isFollowing = false
        cell.followAction = nil // clear default
        
        // Remove existing targets and add invite action
        cell.buttonFollow.removeTarget(nil, action: nil, for: .allEvents)
        cell.buttonFollow.tag = indexPath.row
        cell.buttonFollow.addTarget(self, action: #selector(inviteButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc private func inviteButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index < friendsList.count else { return }
        let friend = friendsList[index]
        guard let friendID = friend.userID,
              let myID = userProfile.userID else { return }
        
        // Disable the button immediately
        sender.isEnabled = false
        sender.setTitle("Invited", for: .normal)
        sender.backgroundColor = .systemGray2
        
        Task {
            // 1. Create the game with ONLY playerOneID — playerTwoID is set when they accept
            var newGame = TerritoryGame(playerOneID: myID, playerTwoID: nil)
            newGame = await insertNewGame(gameData: newGame)!
            DataSource.shared.setGameDetails(newGame)
            
            if let gameID = newGame.gameID {
                DataSource.shared.setGameID(gameID)
            }
            
            // 2. Send notification to the friend
            let senderName = userProfile.userName ?? "Someone"
            let notification = BattleInviteNotification(
                senderID: myID,
                receiverID: friendID,
                senderName: senderName,
                gameID: newGame.gameID,
                message: "\(senderName) invited you to a Battle Run!",
                isRead: false
            )
            await insertBattleInviteNotification(notification)
            
            await MainActor.run {
                self.onInviteSent?(friendID)
                self.dismiss(animated: true)
            }
        }
    }
}
