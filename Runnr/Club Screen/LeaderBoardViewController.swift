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
    @IBOutlet var goldRunner: UIImageView!
    @IBOutlet var silverRunner: UIImageView!
    @IBOutlet var bronzeRunner: UIImageView!
    @IBOutlet var backButton: UIButton!

    var users: [LeaderboardUser] = leaderboardUsersArray
    private(set) var currentMode: LeaderboardMode = .kilometer

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.register(UINib(nibName: "LeaderboardListTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "LeaderboardListTableViewCell")
        setMode(.kilometer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeCircular(goldRunner)
        makeCircular(silverRunner)
        makeCircular(bronzeRunner)
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

// MARK: - TableView Settings

extension LeaderBoardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardListTableViewCell", for: indexPath) as? LeaderboardListTableViewCell else {
            return UITableViewCell()
        }

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
