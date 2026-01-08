//
//  GameSetTwoViewController.swift
//  Runnr
//
//  Created by Archit Kankaria on 08/01/26.
//

import UIKit

class GameSetTwoViewController: UIViewController {

    
    @IBOutlet weak var viewMint: UIView!
    
    @IBOutlet weak var viewCyan: UIView!
    
    @IBOutlet weak var viewRed: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        let destinationVC = BattleRunViewController()
        self.present(destinationVC, animated: true, completion: nil)
    }
    
}
