//
//  CaloriesViewController.swift
//  Runnr
//
//  Created by SDC-USER on 28/11/25.
//

import UIKit

class CaloriesViewController: UIViewController {

    @IBOutlet weak var labelCaloriesBurnt: UILabel!
    @IBOutlet weak var segmentControlCalories: UISegmentedControl!
    @IBOutlet weak var labelNumberCaloriesBurnt: UILabel!
    @IBOutlet weak var viewCalories: CaloriesGraph!
    @IBOutlet weak var labelCaloriesTrends: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControlCalories.layer.borderWidth = 0.5
                
        segmentControlCalories.layer.borderColor = UIColor.accent.cgColor
        segmentControlCalories.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        labelNumberCaloriesBurnt.text = "230"
            
            // Set graph data
        viewCalories.values = [185, 200, 500, 300, 450, 150]
        viewCalories.labels = ["T","W","T","F","S","S"]
        viewCalories.setNeedsDisplay()

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
