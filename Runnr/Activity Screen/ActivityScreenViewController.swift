import UIKit

class ActivityScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var labelRecentActivities: UILabel!
    @IBOutlet weak var segmentedControlActivityScreen: UISegmentedControl!
    // Example Data Model
    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark
        segmentedControlActivityScreen.layer.borderWidth = 0.5
        segmentedControlActivityScreen.layer.borderColor = UIColor.accent.cgColor
        segmentedControlActivityScreen.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        let thinFont = UIFont(name: "SFProText-Thin", size: 25) ?? UIFont.systemFont(ofSize: 25, weight: .thin)
        let boldFont = UIFont(name: "SFProText-Bold", size: 25) ?? UIFont.boldSystemFont(ofSize: 25)

        let recentText = NSAttributedString(
            string: "Recent ",
            attributes: [
                .font: thinFont,
                .foregroundColor: UIColor.white // or your preferred color
            ]
        )

        let activitiesText = NSAttributedString(
            string: "Activities",
            attributes: [
                .font: boldFont,
                .foregroundColor: UIColor.white
            ]
        )

        let fullText = NSMutableAttributedString()
        fullText.append(recentText)
        fullText.append(activitiesText)

        // Set this attributed string on your UILabel
        labelRecentActivities.attributedText = fullText

    }

    @IBAction func didTapChevron(_ sender: UIButton) {
        //let allActivitiesVC = AllActivitiesViewController()
        //navigationController?.pushViewController(allActivitiesVC, animated: true)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return activities.count
        }

        // Only one row per section
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyActivityTableViewCell
            let activity = activities[indexPath.section]
            cell.configure(with: activity)
            return cell
        }

        // Add space via section footer
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 30 // Amount of vertical space wanted
        }

        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let spacer = UIView()
            spacer.backgroundColor = .clear // Invisible
            return spacer
        }
    }



