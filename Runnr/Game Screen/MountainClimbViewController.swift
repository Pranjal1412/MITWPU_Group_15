//
//  MountainClimbViewController.swift
//  Runnr
//
//  Created by SDC-USER on 30/01/26.
//

import UIKit

class MountainClimbViewController: UIViewController {

    
    @IBOutlet var kmField: UITextField!
    @IBOutlet weak var climbButton: UIButton!
    @IBOutlet weak var stickman: UIImageView!   // if you have one

    var totalKm = 0.0
    let climbPerKm: CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        _ = 0.0
        let _: CGFloat = 50

    }
   
    
    @IBAction func climbTapped(_ sender: UIButton) {
        let km = CGFloat(Double(kmField.text ?? "") ?? 0)
           let climb = km * climbPerKm

           totalKm += Double(km)

        UIView.animate(withDuration: 1) {
            self.stickman.center.y -= climb
        }
        print("stickman")
        }

    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


