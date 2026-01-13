//
//  LeaderBoardViewController.swift
//  Runnr
//
//  Created by Aditi Bhange on 04/01/26.
//

import UIKit


class LeaderBoardViewController: UIViewController {

    @IBOutlet var totalKmLine: UIView!
    @IBOutlet var longestStreakLine: UIView!
    @IBOutlet var pointLine: UIView!
    @IBOutlet var labelValueTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var GoldRunner: UIImageView!
    @IBOutlet var SilverRunner: UIImageView!
    @IBOutlet var BronzeRunner: UIImageView!
    
    var users: [LeaderboardUser] = leaderboardUsersArray
    private(set) var currentMode: LeaderboardMode = .kilometer

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        navigationItem.hidesBackButton = true
        view.overrideUserInterfaceStyle = .dark
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(UINib(nibName: "LeaderBoardTableViewCell", bundle: nil), forCellReuseIdentifier: "LeaderBoardTableViewCell")
        
        setMode(.kilometer)
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
    
    @IBAction func totalKmTapped(_ sender: UIButton) {
        setMode(.kilometer)
    }

    @IBAction func longestStreakTapped(_ sender: UIButton) {
        setMode(.streak)
    }

    @IBAction func pointsTapped(_ sender: UIButton) {
        setMode(.points)
    }

    private func setMode(_ mode: LeaderboardMode) {
        currentMode = mode
        updateUnderline()
        tableView.reloadData()
    }

    private func updateUnderline() {
        // Reset
        totalKmLine.alpha = 0.3
        longestStreakLine.alpha = 0.3
        pointLine.alpha = 0.3

        totalKmLine.backgroundColor = .white
        longestStreakLine.backgroundColor = .white
        pointLine.backgroundColor = .white

        switch currentMode {
        case .kilometer:
            totalKmLine.alpha = 1
            totalKmLine.backgroundColor = .accent
            labelValueTitle.text = "Kilometers"

        case .streak:
            longestStreakLine.alpha = 1
            longestStreakLine.backgroundColor = .accent
            labelValueTitle.text = "Streak"

        case .points:
            pointLine.alpha = 1
            pointLine.backgroundColor = .accent
            labelValueTitle.text = "Points"
        }
    }

    }


 


extension LeaderBoardViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "LeaderBoardTableViewCell",
            for: indexPath
        ) as! LeaderboardListTableViewCell

        let user = users[indexPath.row]

        let value: String
        switch currentMode {
        case .kilometer:
            value = "\(user.kilometers)"
        case .streak:
            value = "\(user.streak)"
        case .points:
            value = "\(user.points)"
        }

        cell.configure(
            rank: indexPath.row + 4,
            name: user.name,
            value: value
        )

        return cell
    }

    
    
}
