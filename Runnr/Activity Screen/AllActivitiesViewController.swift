import UIKit

class AllActivitiesViewController: UIViewController {
    
    @IBOutlet weak var tableViewMyActivity: UITableView!
    @IBOutlet weak var buttonCalendar: UIButton!
    
    let label = UILabel()
    
    var dataSource = DataSource.shared
    var selectedFilterDate: Date? = nil
    var myActivity: [ActivityDetails] {
        guard let date = selectedFilterDate else {
            return dataSource.getAllActivities()
        }
        return dataSource.getAllActivities().filter {
            guard let activityDate = $0.activity?.activityStartTime else { return false } // ← replace .date with your actual property
            return Calendar.current.isDate(activityDate, inSameDayAs: date)
        }
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
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @IBAction func buttonCalendarTapped(_ sender: UIButton) {
        let calendarVC = CalendarViewController()
        calendarVC.modalPresentationStyle = .overFullScreen
        calendarVC.modalTransitionStyle = .crossDissolve
        calendarVC.delegate = self
        present(calendarVC, animated: false)
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
                            let destinationVC = ActivityAnalysisViewController()
                            destinationVC.activityData = self.dataSource.getCurrentActivity()
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
            
            let thinFont = UIFont(name: "SFProText-Thin", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .thin)
            let boldFont = UIFont(name: "SFProText-Bold", size: 22) ?? UIFont.boldSystemFont(ofSize: 22)
            
            if selectedFilterDate != nil {
                // Filtered state - no results for that date
                let line1 = NSMutableAttributedString(string: "No activities recorded\n", attributes: [.font: thinFont, .foregroundColor: UIColor.lightGray])
                let line2thin = NSAttributedString(string: "on ", attributes: [.font: thinFont, .foregroundColor: UIColor.lightGray])
                let line2bold = NSAttributedString(string: "selected date", attributes: [.font: thinFont, .foregroundColor: UIColor.lightGray])
                line1.append(line2thin)
                line1.append(line2bold)
                label.attributedText = line1
            } else {
                // No activities at all
                let thinText = NSAttributedString(string: "No ", attributes: [.font: thinFont, .foregroundColor: UIColor.lightGray])
                let boldText = NSAttributedString(string: "Activities", attributes: [.font: boldFont, .foregroundColor: UIColor.lightGray])
                let completeText = NSMutableAttributedString()
                completeText.append(thinText)
                completeText.append(boldText)
                label.attributedText = completeText
            }
        } else {
            label.isHidden = true
        }
    }
}

extension AllActivitiesViewController: CalendarViewControllerDelegate {
    
    func didSelectDate(_ date: Date) {
        selectedFilterDate = date
        updateScreenElements()
    }
    
    func didClearFilter() {
        selectedFilterDate = nil
        updateScreenElements()
    }
}

