import UIKit

class ActivityScreenViewController: UIViewController {
    
    @IBOutlet weak var tableViewMyActivity: UITableView!
    @IBOutlet weak var labelRecentActivities: UILabel!
    @IBOutlet weak var segmentedControlActivityScreen: UISegmentedControl!
    @IBOutlet weak var tableViewFriendsActivity: UITableView!
    
    let label = UILabel()
    var myActivity: [MyRunActivity] {
        DataSource.shared.getMyActivityData()
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
        
        label.text = "No activities"
        label.frame = CGRect(x: 0, y: view.frame.height / 2 , width: view.frame.width, height: 50)
        label.textAlignment = .center
        label.textColor = .lightGray
        
        if myActivity.isEmpty {
            view.addSubview(label)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableViewMyActivity.reloadData()
        if myActivity.isEmpty == false {
            label.isHidden = true
        }
        print(myActivity.count)
    }
    
    func settingLabelStyle() {
        let thinFont = UIFont(name: "SFProText-Thin", size: 25) ?? UIFont.systemFont(ofSize: 25, weight: .thin)
        let boldFont = UIFont(name: "SFProText-Bold", size: 25) ?? UIFont.boldSystemFont(ofSize: 25)
        let recentText = NSAttributedString(string: "Recent ", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        let activitiesText = NSAttributedString(string: "Activities", attributes: [.font: boldFont, .foregroundColor: UIColor.white])

        let fullText = NSMutableAttributedString()
        fullText.append(recentText)
        fullText.append(activitiesText)

        labelRecentActivities.attributedText = fullText
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
            if myActivity.isEmpty
            {
                label.isHidden = false
            }
            tableViewMyActivity.isHidden = false
            tableViewFriendsActivity.isHidden = true
        }
    }
}

//Table View
extension ActivityScreenViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableViewMyActivity {
            //Changed here - by pranjal
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
        print("selected")
    }
}




