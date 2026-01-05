//
//  LeaderBoardViewController.swift
//  Runnr
//
//  Created by Aditi Bhange on 04/01/26.
//

import UIKit

enum LeaderboardMode {
    case kilometer
    case streak
    case points
}

class LeaderBoardViewController: UIViewController {

    @IBOutlet var totalKmLine: UIView!
    @IBOutlet var longestStreakLine: UIView!
    @IBOutlet var pointLine: UIView!
    @IBOutlet var labelValueTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var GoldRunner: UIImageView!
    @IBOutlet var SilverRunner: UIImageView!
    @IBOutlet var BronzeRunner: UIImageView!
    
    var currentMode: LeaderboardMode = .kilometer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        view.overrideUserInterfaceStyle = .dark
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(UINib(nibName: "LeaderBoardTableViewCell", bundle: nil), forCellReuseIdentifier: "LeaderBoardTableViewCell")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        makeCircular(GoldRunner)
        makeCircular(SilverRunner)
        makeCircular(BronzeRunner)
    }
    private func makeCircular(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
    }
}
 


extension LeaderBoardViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
                withIdentifier: "LeaderBoardTableViewCell",
                for: indexPath
            ) as! LeaderBoardTableViewCell

            switch currentMode {

            case .kilometer:
                cell.configure(
                    rank: indexPath.row + 4,
                    name: "Ava Brooks",
                    value: "15"
                )

            case .streak:
                cell.configure(
                    rank: indexPath.row + 4,
                    name: "Ava Brooks",
                    value: "37"
                )

            case .points:
                cell.configure(
                    rank: indexPath.row + 4,
                    name: "Ava Brooks",
                    value: "436"
                )
            }

            return cell
        }
    
    
}
