import UIKit

class AllActivitiesViewController: UIViewController {
    
    @IBOutlet weak var tableViewMyActivity: UITableView!

    let label = UILabel()
    
    var dataSource = DataSource.shared
    var myActivity: [ActivityDetails] {
        dataSource.getAllActivities()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingLabel()
        settingTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateScreenElements()
    }
    
    func settingTableView() {
        tableViewMyActivity.delegate = self
        tableViewMyActivity.dataSource = self
        tableViewMyActivity.register(UINib(nibName: "MyActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableViewMyActivity.showsVerticalScrollIndicator = false
        tableViewMyActivity.separatorStyle = .none
    }
    
    func settingLabel() {
        let thinFont = UIFont(name: "SFProText-Thin", size: 25) ?? UIFont.systemFont(ofSize: 25, weight: .thin)
        let boldFont = UIFont(name: "SFProText-Bold", size: 25) ?? UIFont.boldSystemFont(ofSize: 25)
        
        let thinText = NSAttributedString(string: "No ", attributes: [.font: thinFont, .foregroundColor: UIColor.lightGray])
        let boldText = NSAttributedString(string: "Activities", attributes: [.font: boldFont, .foregroundColor: UIColor.lightGray])
        
        let completeText = NSMutableAttributedString()
        completeText.append(thinText)
        completeText.append(boldText)
        label.attributedText = completeText
        view.addSubview(label)
    }
    
}

//MARK: - TableView Settings
extension AllActivitiesViewController : UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return myActivity.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyActivityTableViewCell
            
            let activityDetails = myActivity[indexPath.row]
            cell.configure(with: activityDetails.activity!)
            return cell
        }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if tableView == tableViewMyActivity {
                let activity = myActivity[indexPath.row]

                    Task {
                        self.dataSource.setCurrentActivity(activity)

                        let routeCoordinates = await fetchActivityRouteCoordinates(activity.activity!.activityID!)
                        self.dataSource.setCurrentActivityCoordinates(routeCoordinates)
                        
                        let paceData = await fetchActivityPaceGraphData(activity.activity!.activityID!)
                        self.dataSource.setCurrentActivityPaceData(paceData)
                        
                        let activityImages = await fetchActivityImages(activity.activity!.activityID!)
                        self.dataSource.setCurrentActivityImages(activityImages)
                        
                        await MainActor.run {
                            let destinationVC = ActivitySummaryViewController()
                            destinationVC.isNewActivity = false
                            destinationVC.onActivityDeleted = {
                                self.updateScreenElements()
                            }
                            destinationVC.modalPresentationStyle = .overFullScreen
                            self.present(destinationVC, animated: true)
                        }
                    }
                
            }
        }

    
    @objc func didTapOnMoreOptions(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: String(localized: "Share Activity"), style: .default)
        let deleteAction = UIAlertAction(title: String(localized: "Delete Activity"), style: .default) { _ in
            self.updateScreenElements()
        }
        let cancelAction = UIAlertAction(title: String(localized: "Cancel"), style: .cancel, handler: nil)
        
        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func updateScreenElements() {
        tableViewMyActivity.reloadData()
        
        if myActivity.isEmpty {
            label.isHidden = false
        }
        else {
            label.isHidden = true
        }
        
    }
}

