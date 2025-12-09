//
//  ClubProfileViewController.swift
//  Runnr
//
//  Created by SDC-USER on 09/12/25.
//

import UIKit

class ClubProfileViewController: UIViewController {

    @IBOutlet var viewLine: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        
        viewLine.backgroundColor = .white
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
