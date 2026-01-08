//
//  ViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 16/10/25.
//

import UIKit

let tabBar = UITabBarController()

class ViewController: UIViewController {

    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonJoinUs: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!

    var newUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.overrideUserInterfaceStyle = .dark
        
        self.buttonJoinUs.layer.cornerRadius = buttonJoinUs.frame.height / 2
        self.buttonJoinUs.setTitle(String(localized: "Join Us"), for: .normal)
        self.buttonJoinUs.clipsToBounds = true
        
        self.buttonLogin.layer.cornerRadius = buttonLogin.frame.height / 2
        self.buttonLogin.setTitle(String(localized: "Login"), for: .normal)
        self.buttonLogin.layer.borderColor = UIColor.white.cgColor
        self.buttonLogin.layer.borderWidth = 1.0
        self.buttonLogin.clipsToBounds = true
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if isSignUpComplete == true {
            let activitiesVC = ActivityScreenViewController()
            let itemOne = UINavigationController(rootViewController: activitiesVC)
            let iconOne = UITabBarItem(title:NSLocalizedString("Activities", comment: ""), image: UIImage(systemName: "figure.run.square.stack.fill"), selectedImage: UIImage(systemName: "figure.run.square.stack.fill"))
            itemOne.tabBarItem = iconOne
            
            let itemTwo = ClubScreenViewController()
            let iconTwo = UITabBarItem(title:NSLocalizedString("Clubs", comment: ""), image: UIImage(systemName: "person.2.fill"), selectedImage: UIImage(systemName: "person.2.fill"))
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
            
            let tabBarControllerArray = [itemOne, itemTwo, itemThree, itemFour, itemFive]
            tabBar.overrideUserInterfaceStyle = .dark
            tabBar.setViewControllers(tabBarControllerArray, animated: false)
            tabBar.selectedIndex = 2
            tabBar.modalPresentationStyle = .fullScreen
            self.present(tabBar, animated: false)
        }
    }
    
    @IBAction func joinUsButtonPressed(_ sender: UIButton) {
        self.newUser = true
        self.navigationController?.pushViewController(JoinUsViewController(), animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
}

