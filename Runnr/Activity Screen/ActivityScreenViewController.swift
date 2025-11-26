import UIKit

class ActivityScreenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelRecentActivities: UILabel!
    @IBOutlet weak var segmentedControlActivityScreen: UISegmentedControl!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark
        
        settingSegmentedControl()
        settingLabelStyle()
        settingTableView()

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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    func settingSegmentedControl() {
        segmentedControlActivityScreen.layer.borderWidth = 0.5
        segmentedControlActivityScreen.layer.borderColor = UIColor.accent.cgColor
        segmentedControlActivityScreen.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }
}

//Table View
extension ActivityScreenViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return activities.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyActivityTableViewCell
        let activity = activities[indexPath.section]
        cell.configure(with: activity)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }
}



