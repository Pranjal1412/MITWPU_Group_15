//
//  IntroductionViewController.swift
//  Runnr
//
//  Created by SDC-USER on 23/01/26.
//

import UIKit

class IntroductionViewController: UIViewController {

    @IBOutlet weak var viewMainBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewMainBackground.layer.cornerRadius = 20
        self.viewMainBackground.layer.shadowColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        self.viewMainBackground.layer.shadowOpacity = 0.5
        self.viewMainBackground.layer.shadowRadius = 40
    }

}
