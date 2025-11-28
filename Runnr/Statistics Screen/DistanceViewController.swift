//
//  DistanceViewController.swift
//  Runnr
//
//  Created by SDC-USER on 28/11/25.
//

import UIKit

class DistanceViewController: UIViewController {

    @IBOutlet weak var labelDistanceCovered: UILabel!
    @IBOutlet weak var labelNumberDistanceCovered: UILabel!
    @IBOutlet weak var segmentControlDistanceScreen: UISegmentedControl!
    @IBOutlet weak var viewDistanceGraph: LineGraphView!
    @IBOutlet weak var labelDistanceTrends: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControlDistanceScreen.layer.borderWidth = 0.5
                
        segmentControlDistanceScreen.layer.borderColor = UIColor.accent.cgColor
        segmentControlDistanceScreen.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        labelNumberDistanceCovered.text = "20.3"
            
            // Set graph data
        viewDistanceGraph.values = [12, 3, 13, 8, 15, 20, 7]
        viewDistanceGraph.labels = ["S","M","T","W","T","F","S"]
        viewDistanceGraph.setNeedsDisplay()

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
