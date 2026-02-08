import UIKit

class ActivityScreenViewController: UIViewController {
    
    @IBOutlet weak var tableViewMyActivity: UITableView!
    @IBOutlet weak var labelRecentActivities: UILabel!
    @IBOutlet weak var segmentedControlActivityScreen: UISegmentedControl!
    @IBOutlet weak var tableViewFriendsActivity: UITableView!
    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var stackRecentActivities: UIStackView!
    @IBOutlet weak var labelTotalPoints: UILabel!
    @IBOutlet weak var buttonUserProfile: UIButton!
    
    let label = UILabel()

    var totalPoints: Int {
        dataSource.getTotalRunnrPoints()
    }
    
    private var dataSource = DataSource.shared
    
    private var userProfile: UserProfile {
        DataSource.shared.getUserProfile()
    }
    private var myActivity: [UserActivity] {
        dataSource.getAllActivities()
    }
    let friendsActivity : [UserActivity] = DataSource.shared.getFriendsActivityData()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        settingTableView()
        settingLabelStyle()
        settingSegmentedControl()
        
        tableViewMyActivity.isHidden = false
        tableViewFriendsActivity.isHidden = true

        label.frame = CGRect(x: 0, y: view.frame.height / 2 + 20.0, width: view.frame.width, height: 50)
        label.textAlignment = .center
        view.addSubview(label)
        
        self.buttonUserProfile.layer.cornerRadius = self.buttonUserProfile.frame.height / 2
        self.buttonUserProfile.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            
            let activities = await fetchAllMyActivities(userID: userProfile.userID!)
            self.dataSource.setAllActivities(activities)
            
            updateScreenElements()
            labelTotalPoints.text = "\(totalPoints)"
        }
    }
    
    func settingLabelStyle() {
        self.labelScreenTitle.text = String(localized: "Activities")
        labelScreenTitle.sizeToFit()
        
        let thinFont = UIFont(name: "SFProText-Thin", size: 25) ?? UIFont.systemFont(ofSize: 25, weight: .thin)
        let boldFont = UIFont(name: "SFProText-Bold", size: 25) ?? UIFont.boldSystemFont(ofSize: 25)
        let recentText = NSAttributedString(string: "Recent ", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        let activitiesText = NSAttributedString(string: "Activities", attributes: [.font: boldFont, .foregroundColor: UIColor.white])

        let fullText = NSMutableAttributedString()
        fullText.append(recentText)
        fullText.append(activitiesText)

        let thinText = NSAttributedString(string: "No ", attributes: [.font: thinFont, .foregroundColor: UIColor.lightGray])
        let boldText = NSAttributedString(string: "Activities", attributes: [.font: boldFont, .foregroundColor: UIColor.lightGray])
        
        let completeText = NSMutableAttributedString()
        completeText.append(thinText)
        completeText.append(boldText)
        
        labelRecentActivities.attributedText = fullText
        label.attributedText = completeText
        labelRecentActivities.sizeToFit()
    }
    
    func settingTableView() {
        tableViewMyActivity.delegate = self
        tableViewMyActivity.dataSource = self
        tableViewMyActivity.showsVerticalScrollIndicator = false
        tableViewMyActivity.register(UINib(nibName: "MyActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        tableViewFriendsActivity.delegate = self
        tableViewFriendsActivity.dataSource = self
        tableViewFriendsActivity.showsVerticalScrollIndicator = false
        tableViewFriendsActivity.register(UINib(nibName: "FriendsActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "cellFriends")
        tableViewMyActivity.separatorStyle = .none

    }

    func settingSegmentedControl() {
        segmentedControlActivityScreen.layer.borderWidth = 0.5
        segmentedControlActivityScreen.layer.borderColor = UIColor.accent.cgColor
        segmentedControlActivityScreen.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }
    
    func updateScreenElements() {
        if myActivity.isEmpty {
            label.isHidden = false
            stackRecentActivities.isHidden = true
        }
        else {
            label.isHidden = true
            stackRecentActivities.isHidden = false
        }
        
        tableViewMyActivity.reloadData()
    }
    
    @IBAction func chevronToAllActivities(_ sender: UIButton) {
        let vc = AllActivitiesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func segmentChangeToFriends(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            tableViewMyActivity.isHidden = true
            tableViewFriendsActivity.isHidden = false
            label.isHidden = true
        }
        else {
            self.updateScreenElements()
            tableViewMyActivity.isHidden = false
            tableViewFriendsActivity.isHidden = true
        }
    }
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        
        let destinationVC = UserProfileViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true, completion: nil)
        
    }
}

//MARK: - TableView Settings
extension ActivityScreenViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewMyActivity {
            return min(myActivity.count, 3)
        } else if tableView == tableViewFriendsActivity {
            return friendsActivity.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableViewMyActivity {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyActivityTableViewCell
            
            let activity = myActivity[indexPath.row]
            cell.configure(with: activity)
            
            return cell

        } else {
            // tableViewfriendsActivity
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellFriends", for: indexPath) as! FriendsActivityTableViewCell
            
            let activity = friendsActivity[indexPath.section]
            cell.configure(with: activity)
            return cell
        }

    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 30
//    }

//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let spacer = UIView()
//        spacer.backgroundColor = .clear
//        return spacer
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewMyActivity {
            let activity = myActivity[indexPath.row]

                Task {
                    self.dataSource.setCurrentActivity(activity)

                    let routeCoordinates = await fetchActivityRouteCoordinates(activity.activityID!)
                    self.dataSource.setCurrentActivityCoordinates(routeCoordinates)

                    let paceData = await fetchActivityPaceGraphData(activity.activityID!)
                    self.dataSource.setCurrentActivityPaceData(paceData)
                    
                    await MainActor.run {
                        let destinationVC = ActivitySummaryViewController()
                        destinationVC.showAlert = false
                        destinationVC.modalPresentationStyle = .overFullScreen
                        self.present(destinationVC, animated: true)
                    }
                }
            
        }
    }
    
}

//MARK: - Activity Settings
//extension ActivityScreenViewController {
//    
//    @objc func didTapOnMoreOptions(_ sender: UIButton) {
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        
//        let shareAction = UIAlertAction(title: String(localized: "Share Activity"), style: .default){
//            _ in self.dataSource.shareActivity(atIndex: sender.tag, presentingViewController: self)
//        }
//        let deleteAction = UIAlertAction(title: String(localized: "Delete Activity"), style: .destructive) { _ in
//            self.dataSource.deleteMyActivity(atIndex: sender.tag)
//            self.updateScreenElements()
//        }
//        let cancelAction = UIAlertAction(title: String(localized: "Canel"), style: .cancel, handler: nil)
//        
//        alert.addAction(shareAction)
//        alert.addAction(cancelAction)
//        alert.addAction(deleteAction)
//        present(alert, animated: true, completion: nil)
//    }
//    
//}



