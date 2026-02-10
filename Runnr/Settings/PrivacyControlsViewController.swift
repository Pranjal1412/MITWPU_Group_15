//
//  PrivacyControlsViewController.swift
//  Runnr
//
//  Created by Mrunal Aralkar on 10/02/26.
//

import UIKit

class PrivacyControlsViewController: UIViewController {

    @IBOutlet weak var segmentControlProfileVisibilty: UISegmentedControl!
    @IBOutlet weak var viewSocial: UIView!
    @IBOutlet weak var segmentControlActivityPrivacy: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func configure() {
        viewSocial.layer.cornerRadius = 15
        viewSocial.clipsToBounds = true
        segmentControlProfileVisibilty.layer.borderWidth = 0.5
        segmentControlProfileVisibilty.layer.borderColor = UIColor.accent.cgColor
        segmentControlProfileVisibilty.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        segmentControlActivityPrivacy.layer.borderWidth = 0.5
        segmentControlActivityPrivacy.layer.borderColor = UIColor.accent.cgColor
        segmentControlActivityPrivacy.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
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
