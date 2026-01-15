import UIKit

class ActivityScreenViewController: UIViewController {
    
    @IBOutlet weak var tableViewMyActivity: UITableView!
    @IBOutlet weak var labelRecentActivities: UILabel!
    @IBOutlet weak var segmentedControlActivityScreen: UISegmentedControl!
    @IBOutlet weak var tableViewFriendsActivity: UITableView!
    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var stackRecentActivities: UIStackView!
    @IBOutlet weak var labelTotalPoints: UILabel!
    
    let label = UILabel()

    var dataSource = DataSource.shared
    var totalPoints: Int {
        dataSource.getTotalRunnrPoints()
    }
    var myActivity: [MyRunActivity] {
        dataSource.getMyActivityData()
    }
    
    let friendsActivity : [FriendsRunActivity] = DataSource.shared.getFriendsActivityData()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark
        
        settingSegmentedControl()
        settingLabelStyle()
        settingTableView()
        tableViewMyActivity.isHidden = false
        tableViewFriendsActivity.isHidden = true
        
        label.frame = CGRect(x: 0, y: view.frame.height / 2 + 20.0, width: view.frame.width, height: 50)
        label.textAlignment = .center
        view.addSubview(label)
        
        self.labelScreenTitle.text = String(localized: "Activities")
        labelScreenTitle.sizeToFit()
        tableViewFriendsActivity.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
                
        updateScreenElements()
        print(myActivity.count)
        self.labelTotalPoints.text = "\(totalPoints)"
    }
    
    func settingLabelStyle() {
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
        tableViewFriendsActivity.delegate = self
        tableViewFriendsActivity.dataSource = self
        tableViewMyActivity.register(UINib(nibName: "MyActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableViewMyActivity.showsVerticalScrollIndicator = false
        tableViewFriendsActivity.register(UINib(nibName: "FriendsActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "cellFriends")
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
}

//MARK: - Table View Settings
extension ActivityScreenViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableViewMyActivity {
            return min(myActivity.count, 3)
        } else if tableView == tableViewFriendsActivity {
            return friendsActivity.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableViewMyActivity {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                     for: indexPath) as! MyActivityTableViewCell
            let activity = myActivity[indexPath.section]
            cell.configure(with: activity)
            
            cell.buttonMoreOptions.tag = indexPath.section
            cell.buttonMoreOptions.addTarget(self, action: #selector(didTapOnMoreOptions(_:)), for: .touchUpInside)
            
            return cell

        } else { // tableViewfriendsActivity
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellFriends",
                                                     for: indexPath) as! FriendsActivityTableViewCell
            let activity = friendsActivity[indexPath.section]
            cell.configure(with: activity)
            return cell
        }

    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewMyActivity {
            let activity = myActivity[indexPath.section]
            
            let destinationVC = ActivitySummaryViewController()
            destinationVC.activityData = activity
            destinationVC.showAlert = false
            
            destinationVC.modalPresentationStyle = .overFullScreen
            self.present(destinationVC, animated: true)
            
        }
    }
}

extension ActivityScreenViewController {
    @objc func didTapOnMoreOptions(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: String(localized: "Share Activity"), style: .default){
            _ in self.dataSource.shareActivity(atIndex: sender.tag, presentingViewController: self)
        }
        let deleteAction = UIAlertAction(title: String(localized: "Delete Activity"), style: .destructive) { _ in
            self.dataSource.deleteMyActivity(atIndex: sender.tag)
            self.updateScreenElements()
        }
        let cancelAction = UIAlertAction(title: String(localized: "Edit Activity"), style: .default, handler: nil)
        
        alert.addAction(shareAction)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
}



