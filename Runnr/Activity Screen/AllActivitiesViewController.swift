//
//  AllActivitiesViewController.swift
//  Runnr
//
//  Created by Archit Kankaria on 26/11/25.
//

import UIKit

class AllActivitiesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let label = UILabel()
    let myActivity: [MyRunActivity] = DataSource.shared.getMyActivityData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark
        // Do any additional setup after loading the view.
        settingTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if activities.isEmpty {
            label.text = "No activities"
            label.frame = CGRect(x: 0, y: view.frame.height / 2 , width: view.frame.width, height: 50)
            label.textAlignment = .center
            label.textColor = .lightGray
            view.addSubview(label)
        }
        else {
            label.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    func settingTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.showsVerticalScrollIndicator = false
    }
    
}

// MARK: - Table View code

extension AllActivitiesViewController : UITableViewDelegate, UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return myActivity.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyActivityTableViewCell
            let activity = myActivity[indexPath.section]
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
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("selected")
        }

    }

