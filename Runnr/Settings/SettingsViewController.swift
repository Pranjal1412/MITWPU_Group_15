//
//  SettingsViewController.swift
//  Runnr
//
//  Created by SDC-USER on 12/01/26.
//

import UIKit
import Supabase

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewSettings: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewSettings.dataSource = self
        self.tableViewSettings.delegate = self
        
        self.tableViewSettings.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray[section]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        
        let section = indexPath.section
        let cellData = settingsArray[section]![indexPath.row]
        
        cell.configureCell(with: cellData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView()
        headerView.backgroundColor = .black

        let titleLabel = UILabel()
        titleLabel.textColor = .accent
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.frame = CGRect(x: 5, y: 0, width: tableView.frame.width, height: 30)

        switch section {
        case 0:
            titleLabel.text = "Account Details"
        case 1:
            titleLabel.text = "Privacy & Control"
        case 2:
            titleLabel.text = "Personalization"
        default:
            titleLabel.text = ""
        }

        headerView.addSubview(titleLabel)

        return headerView
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let cellSelected = settingsArray[indexPath.section]![indexPath.row]
        
        switch cellSelected.title {
        case "Connect a Device" :
            self.present(ConnectDeviceViewController(), animated: true)
            
        case "Logout" :
            let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (action) in
                
                Task {
                    do {
//                        try await self.supabase.auth.signOut()
                        print("Session deleted successfully")
                        
                        if let presenter = self.presentingViewController {
                            self.dismiss(animated: true) {
                                presenter.dismiss(animated: false, completion: nil)
                            }
                        }
                        
                    } catch {
                        print("Error signing out:", error)
                    }
                }
                
            }
            
            alert.addAction(cancelAction)
            alert.addAction(logoutAction)
            present(alert, animated: true, completion: nil)
            
        case "Privacy Controls" :
            self.present(PrivacyControlsViewController(), animated: true)
            
        default:
            break
        }
        
        if cellSelected.title == "Logout" {
            
        }
        
    }
    
}

