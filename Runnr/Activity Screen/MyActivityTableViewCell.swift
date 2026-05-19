import UIKit
import Kingfisher

class MyActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var labelRunPoints: UILabel!
    @IBOutlet weak var viewCurrency: UIView!
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
    @IBOutlet weak var labelDummy: UILabel!
    @IBOutlet weak var viewMainBackground: UIView!

    private var profileImageURL = DataSource.shared.getUserProfile().userProfileImageURL

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.viewMainBackground.layer.cornerRadius = 20

        if let url = URL(string: profileImageURL!) {
            self.imageProfile.kf.setImage(with: url)
        }
    }

    func configure(with activity: UserActivity) {

        labelDate.text = formatDate(with: activity.activityStartTime!)
        labelRunTitle.text = activity.activityTitle

        if let url = URL(string: activity.mapImageURL!) {
            self.imageRun.kf.setImage(with: url)
        }

        self.labelDummy.text = ""
        if activity.activityRemark != "" {
            self.labelDummy.text = "Dummy Text"
        }
        labelNote.text = activity.activityRemark
        labelDistance.text = NSLocalizedString("Distance", comment: "")
        labelPace.text = NSLocalizedString("Pace", comment: "")
        labelTime.text = NSLocalizedString("Time", comment: "")
        imageRun.layer.cornerRadius = 10
        imageProfile.layer.cornerRadius = imageProfile.frame.height / 2
        viewCurrency.layer.cornerRadius = viewCurrency.frame.height / 2
        let totalPoints = activity.basePoints! + activity.skillPoints!
        labelRunPoints.text = String(totalPoints)
        let valueFont = UIFont(name: "SFProText-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium)
        let unitFont = UIFont(name: "SFProText-Light", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: .light)

        let distanceText = NSMutableAttributedString(
            string: String(format: "%.2f", activity.distanceCovered!),
            attributes: [.font: valueFont, .foregroundColor: UIColor.accent])

        distanceText.append(NSAttributedString(string: " " + activity.distanceUnit!.rawValue, attributes: [.font: unitFont, .foregroundColor: UIColor.accent]))
        labelDistanceContent.attributedText = distanceText

        let paceText = NSMutableAttributedString(string: String(format: "%.2f", activity.avgPace!), attributes: [.font: valueFont, .foregroundColor: UIColor.accent])
        paceText.append(NSAttributedString(string: " " + activity.paceUnit!.rawValue, attributes: [.font: unitFont, .foregroundColor: UIColor.accent]))
        labelPaceContent.attributedText = paceText

        var timeText = NSMutableAttributedString()

        let formattedTime = formatTime(activity.timeTakenSeconds!)

        if formattedTime.hour != 0 {
            timeText = NSMutableAttributedString(string: String(format: "%02d", formattedTime.hour), attributes: [.font: valueFont, .foregroundColor: UIColor.accent])
            timeText.append(NSAttributedString(string: "hr ", attributes: [.font: unitFont, .foregroundColor: UIColor.accent]))
        }

        timeText.append(NSAttributedString(string: String(format: "%02d", formattedTime.minute), attributes: [.font: valueFont, .foregroundColor: UIColor.accent]))

        timeText.append(NSAttributedString(string: "min", attributes: [.font: unitFont, .foregroundColor: UIColor.accent]))

        timeText.append(NSAttributedString(string: " " + String(format: "%02d", formattedTime.second), attributes: [.font: valueFont, .foregroundColor: UIColor.accent]))

        timeText.append(NSAttributedString(string: "sec", attributes: [.font: unitFont, .foregroundColor: UIColor.accent]))

        labelTimeContent.attributedText = timeText
    }

}
