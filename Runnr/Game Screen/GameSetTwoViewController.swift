//
//  GameSetTwoViewController.swift
//  Runnr
//
//  Created by Archit Kankaria on 08/01/26.
//

import UIKit

class GameSetTwoViewController: UIViewController {

    private var selectedColor: UIColor = .systemGreen
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
    
    @IBAction func buttonMint(_ sender: UIButton) {
        selectedColor = UIColor(red: 0.68, green: 1.0, blue: 0.0, alpha: 1.0) // Mint/Lime
                print("Mint selected")
    }
    
    @IBAction func buttonCyan(_ sender: UIButton) {
        selectedColor = .cyan
                print("Cyan selected")
    }
    
    @IBAction func buttonRed(_ sender: Any) {
        selectedColor = .systemRed
                print("Red selected")
    }
    
}
