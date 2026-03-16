//
//  ViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 16/10/25.
//

import UIKit
import Supabase

let tabBar = UITabBarController()

class ViewController: UIViewController {

    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonJoinUs: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!

    var newUser = false
    let loader = UIActivityIndicatorView(style: .large)
    let loaderView = UIView()
    
    override func viewDidLoad() {
            super.viewDidLoad()

            // Join Us button
            buttonJoinUs.layer.cornerRadius = buttonJoinUs.frame.height / 2
            buttonJoinUs.setTitle(String(localized: "Join Us"), for: .normal)
            buttonJoinUs.clipsToBounds = true

            // Login button
            buttonLogin.layer.cornerRadius = buttonLogin.frame.height / 2
            buttonLogin.setTitle(String(localized: "Login"), for: .normal)
            buttonLogin.layer.borderColor = UIColor.white.cgColor
            buttonLogin.layer.borderWidth = 1.0
            buttonLogin.clipsToBounds = true

            setupLoader()
        }

        func setupLoader() {

            loaderView.frame = view.bounds
            loaderView.backgroundColor = UIColor.black.withAlphaComponent(1)

            loader.translatesAutoresizingMaskIntoConstraints = false
            loader.hidesWhenStopped = true

            loaderView.addSubview(loader)
            view.addSubview(loaderView)

            NSLayoutConstraint.activate([
                loader.centerXAnchor.constraint(equalTo: loaderView.centerXAnchor),
                loader.centerYAnchor.constraint(equalTo: loaderView.centerYAnchor)
            ])

            loaderView.isHidden = true
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            loaderView.isHidden = false
            loader.startAnimating()

            Task { @MainActor in
                
                do {
                    let session = try await SupabaseManager.shared.client.auth.session

                    let user = session.user

                    if let userProfile = await fetchUserProfile(userId: user.id) {

                        let userStats = await fetchUserStats(userId: user.id) ??
                        UserStats(
                            userID: user.id,
                            numberOfFollowers: 1,
                            numberOfFollowing: 1,
                            totalPointsEarned: 1,
                            totalDistanceCovered: 1,
                            totalActivities: 0,
                            longestStreak: 0
                        )

                        DataSource.shared.setUserProfile(userProfile)
                        DataSource.shared.setUserStats(userStats)

                        self.setUpTabBar()
                        self.loader.stopAnimating()

                    }

                } catch {
                    self.loader.stopAnimating()
                    self.loaderView.isHidden = true
                    print("User has not logged in")
                }
            }
        }

    @IBAction func joinUsButtonPressed(_ sender: UIButton) {
        self.newUser = true
        self.navigationController?.pushViewController(JoinUsViewController(), animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        self.newUser = false
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    func setUpTabBar() {
        let activitiesVC = ActivityScreenViewController()
        let itemOne = UINavigationController(rootViewController: activitiesVC)
        let iconOne = UITabBarItem(title:NSLocalizedString("Activities", comment: ""), image: UIImage(systemName: "figure.run.square.stack.fill"), selectedImage: UIImage(systemName: "figure.run.square.stack.fill"))
        itemOne.tabBarItem = iconOne
        
        let itemTwo = ClubScreenViewController()
        let iconTwo = UITabBarItem(title:NSLocalizedString("Community", comment: ""), image: UIImage(systemName: "person.2.fill"), selectedImage: UIImage(systemName: "person.2.fill"))
        itemTwo.tabBarItem = iconTwo

        let itemThree = ActivityStartViewController()
        itemThree.newUserAlert = self.newUser
        let iconThree = UITabBarItem(title:NSLocalizedString("Track", comment: ""), image: UIImage(systemName: "figure.run"), selectedImage: UIImage(systemName: "figure.run"))
        itemThree.tabBarItem = iconThree

        let itemFour = GameScreenViewController()
        let iconFour = UITabBarItem(title:NSLocalizedString("Game", comment: ""), image: UIImage(systemName: "gamecontroller.fill"), selectedImage: UIImage(systemName: "gamecontroller.fill"))
        itemFour.tabBarItem = iconFour

        let insightsVC = InsightsScreenViewController()
        let itemFive = UINavigationController(rootViewController: insightsVC)
        let iconFive = UITabBarItem(title:NSLocalizedString("Insights", comment: ""), image: UIImage(systemName: "chart.bar.fill"), selectedImage: UIImage(systemName: "chart.bar.fill"))
        itemFive.tabBarItem = iconFive
        
        let tabBarControllerArray = [itemOne, itemFive, itemThree, itemFour, itemTwo]
        tabBar.setViewControllers(tabBarControllerArray, animated: false)
        tabBar.selectedIndex = 2
        tabBar.modalPresentationStyle = .fullScreen
        self.present(tabBar, animated: false)
    }
    
}

