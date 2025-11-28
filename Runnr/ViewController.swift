//
//  ViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 16/10/25.
//

import UIKit

class ViewController: UIViewController {

    let tabBar = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        let activitiesVC = ActivityScreenViewController()
        let itemOne = UINavigationController(rootViewController: activitiesVC)
        let iconOne = UITabBarItem(title:NSLocalizedString("Activities", comment: ""), image: UIImage(systemName: "figure.run.square.stack.fill"), selectedImage: UIImage(systemName: "figure.run.square.stack.fill"))
        itemOne.tabBarItem = iconOne
        
        let itemTwo = ClubScreenViewController()
        let iconTwo = UITabBarItem(title:NSLocalizedString("Clubs", comment: ""), image: UIImage(systemName: "person.2.fill"), selectedImage: UIImage(systemName: "person.2.fill"))
        itemTwo.tabBarItem = iconTwo

        let itemThree = TrackScreenViewController()
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

