//
//  TableViewCell.swift
//  Runnr
//
//  Created by Archit Kankaria on 18/11/25.
//

import UIKit

class MyActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelProfileImage: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelRunTitle: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelPace: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDistanceContent: UILabel!
    @IBOutlet weak var labelPaceContent: UILabel!
    @IBOutlet weak var labelTimeContent: UILabel!
    @IBOutlet weak var labelRunImage: UIImageView!
    @IBOutlet weak var labelNote: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

func configure(with activity: RunActivity) {
    labelName.text = activity.name
    labelDate.text = activity.date
    labelRunTitle.text = activity.runTitle
    labelDistanceContent.text = activity.distance
    labelPaceContent.text = activity.pace
    labelTimeContent.text = activity.time
    labelRunImage.image = activity.image
    labelNote.text = activity.note
//    labelDistance.text = "Distance"
//    labelPace.text = "Pace"
//    labelTime.text = "Time"
    }
    
}
