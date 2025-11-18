//
//  ClubScreenViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 26/10/25.
//

import UIKit

class ClubScreenViewController: UIViewController {

    @IBOutlet weak var segmentControlClubScreen: UISegmentedControl!
    
    @IBOutlet weak var searchBarFriendsScreen: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark
        
        //segment edits
        segmentControlClubScreen.layer.borderWidth = 0.5
        
        segmentControlClubScreen.layer.borderColor = UIColor.accent.cgColor
        segmentControlClubScreen.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        
        
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
