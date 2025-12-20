//
//  TableViewCell.swift
//  Runnr
//
//  Created by Archit Kankaria on 18/11/25.
//

import UIKit

class MyActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelRunTitle: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelPace: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDistanceContent: UILabel!
    @IBOutlet weak var labelPaceContent: UILabel!
    @IBOutlet weak var labelTimeContent: UILabel!
    @IBOutlet weak var imageRun: UIImageView!
    @IBOutlet weak var labelNote: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 20
        //contentView.layer.masksToBounds = true
        selectionStyle = .none
    }

    func configure(with activity: MyRunActivity) {
        labelName.text = activity.name
        labelDate.text = activity.date
        labelRunTitle.text = activity.runTitle
        imageRun.image = activity.image
        labelNote.text = activity.note
        labelDistance.text = NSLocalizedString("Distance", comment: "")
        labelPace.text = NSLocalizedString("Pace", comment: "")
        labelTime.text = NSLocalizedString("Time", comment: "")
        imageRun.layer.cornerRadius = 10
        imageProfile.layer.cornerRadius = imageProfile.frame.height / 2
        
        // SF Pro fonts
        let valueFont = UIFont(name: "SFProText-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium)
        let unitFont = UIFont(name: "SFProText-Light", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: .light)
        let highlightColor = UIColor(red: 173/255, green: 248/255, blue: 69/255, alpha: 1)

        // Distance
        let distanceValue = String(format: "%.1f", activity.distanceValue)
        let distanceText = NSMutableAttributedString(
            string: distanceValue,
            attributes: [.font: valueFont, .foregroundColor: highlightColor])
        
        distanceText.append(NSAttributedString(string: " " + activity.distanceUnit, attributes: [.font: unitFont, .foregroundColor: highlightColor]))
        labelDistanceContent.attributedText = distanceText

        // Pace
        let paceText = NSMutableAttributedString(
            string: activity.paceValue,
            attributes: [.font: valueFont, .foregroundColor: highlightColor]
        )
        paceText.append(NSAttributedString(
            string: " " + activity.paceUnit,
            attributes: [.font: unitFont, .foregroundColor: highlightColor]
        ))
        labelPaceContent.attributedText = paceText

        // Time (all units smaller and #ADF845)
        let timeText = NSMutableAttributedString()
        let timeValueComponents = activity.timeValue.components(separatedBy: " ")
        var i = 0
        while i < timeValueComponents.count {
            let part = timeValueComponents[i]
            if let _ = Int(part) {
                timeText.append(NSAttributedString(string: part + " ", attributes: [.font: valueFont, .foregroundColor: highlightColor]))
            } else {
                timeText.append(NSAttributedString(string: part + " ", attributes: [.font: unitFont, .foregroundColor: highlightColor]))
            }
            i += 1
        }
        let timeUnitComponents = activity.timeUnit.components(separatedBy: " ")
        i = 0
        while i < timeUnitComponents.count {
            let part = timeUnitComponents[i]
            if let _ = Int(part) {
                timeText.append(NSAttributedString(string: part + " ", attributes: [.font: valueFont, .foregroundColor: highlightColor]))
            } else {
                timeText.append(NSAttributedString(string: part + " ", attributes: [.font: unitFont, .foregroundColor: highlightColor]))
            }
            i += 1
        }
        labelTimeContent.attributedText = timeText
        labelPaceContent.minimumScaleFactor = 0.5 // Optional for font scaling
    }

}
