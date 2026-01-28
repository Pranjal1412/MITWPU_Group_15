import UIKit

class MyActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var labelRunPoints: UILabel!
    @IBOutlet weak var imageCurrency: UIImageView!
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
        selectionStyle = .none
    }
    
    func configure(with activity: UserActivity) {
        labelDate.text = formatDate(with: activity.activityStartTime)
        labelRunTitle.text = activity.runTitle
        imageRun.image = activity.mapImage
        labelNote.text = activity.note
        labelDistance.text = NSLocalizedString("Distance", comment: "")
        labelPace.text = NSLocalizedString("Pace", comment: "")
        labelTime.text = NSLocalizedString("Time", comment: "")
        imageRun.layer.cornerRadius = 10
        imageProfile.layer.cornerRadius = imageProfile.frame.height / 2
        imageCurrency.layer.cornerRadius = imageCurrency.frame.height / 2
        let totalPoints = activity.basePoints + activity.skillPoints
        labelRunPoints.text = String(totalPoints)
        let valueFont = UIFont(name: "SFProText-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium)
        let unitFont = UIFont(name: "SFProText-Light", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: .light)

        let distanceText = NSMutableAttributedString(
            string: String(format: "%.2f", activity.distanceValue),
            attributes: [.font: valueFont, .foregroundColor: UIColor.accent])
        
        distanceText.append(NSAttributedString(string: " " + activity.distanceUnit, attributes: [.font: unitFont, .foregroundColor: UIColor.accent]))
        labelDistanceContent.attributedText = distanceText

        let paceText = NSMutableAttributedString(string: String(format: "%.2f", activity.paceValue),attributes: [.font: valueFont, .foregroundColor: UIColor.accent])
        paceText.append(NSAttributedString(string: " " + activity.paceUnit,attributes: [.font: unitFont, .foregroundColor: UIColor.accent]))
        labelPaceContent.attributedText = paceText

        var timeText = NSMutableAttributedString()
        
        if activity.timeHour != 0 {
            timeText = NSMutableAttributedString(string: String(format: "%02d", activity.timeHour), attributes: [.font: valueFont, .foregroundColor: UIColor.accent])
            timeText.append(NSAttributedString(string: "hr ", attributes: [.font: unitFont, .foregroundColor: UIColor.accent]))
        }
        
        timeText.append(NSAttributedString(string: String(format: "%02d", activity.timeMin), attributes: [.font: valueFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: "min", attributes: [.font: unitFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: " " + String(format: "%02d", activity.timeSec), attributes: [.font: valueFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: "sec", attributes: [.font: unitFont, .foregroundColor: UIColor.accent]))
        
        labelTimeContent.attributedText = timeText
    }

}
