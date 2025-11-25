import UIKit

class ActivityScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

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
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyActivityTableViewCell
        
        let activity = activities[indexPath.row]
        cell.configure(with: activity)
        return cell
    }
}
