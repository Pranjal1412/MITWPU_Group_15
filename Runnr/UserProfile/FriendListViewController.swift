import UIKit

class FriendListViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableViewFriends: UITableView!
    
    var pageTitle: String = "Friends"
    var usersList: [UserProfile] = []
    var showFollowButton : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.labelTitle.text = pageTitle
        
        tableViewFriends.dataSource = self
        tableViewFriends.delegate = self
        tableViewFriends.register(UINib(nibName: "FriendListTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        self.view.backgroundColor = .black 
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - TableView Settings
extension FriendListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! FriendListTableViewCell
        
        let user = usersList[indexPath.row]
        cell.configureCell(with: user)
        cell.buttonFollow.isHidden = !showFollowButton
        cell.followAction = { isFollowing in
            // Handle follow/unfollow action if needed
            // Currently it can just be UI update or we can perform the actual follow/unfollow logic here.
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let destinationVC = UserProfileViewController()
        destinationVC.isFromFriendsScreen = true
        destinationVC.friendData = usersList[indexPath.row]
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true, completion: nil)
    }
}
