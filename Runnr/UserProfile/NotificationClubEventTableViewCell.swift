//
//  NotificationClubEventTableViewCell.swift
//  Runnr
//

import UIKit

class NotificationClubEventTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelEventHeading: UILabel!
    @IBOutlet weak var labelEventDescription: UILabel!
    @IBOutlet weak var labelTimestamp: UILabel!
    @IBOutlet weak var imageClubProfile: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func setupUI() {

        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        self.selectionStyle = .none
        self.isUserInteractionEnabled = false

        self.viewBackground.layer.cornerRadius = 15
        self.viewBackground.layer.borderWidth = 1
        self.viewBackground.layer.borderColor = UIColor(named: "outlineColor")?.cgColor
        self.viewBackground.clipsToBounds = true

        // IMAGE VIEW
        self.imageClubProfile.layer.cornerRadius = self.imageClubProfile.frame.height / 2
        self.imageClubProfile.clipsToBounds = true

        let accentColor = UIColor(
            red: 173/255,
            green: 248/255,
            blue: 69/255,
            alpha: 1
        )

        // LOW OPACITY BACKGROUND
        self.imageClubProfile.backgroundColor = accentColor.withAlphaComponent(0.18)

        // BORDER
        self.imageClubProfile.layer.borderWidth = 1
        self.imageClubProfile.layer.borderColor = accentColor.cgColor

        // FULL OPACITY SYMBOL
        self.imageClubProfile.tintColor = accentColor

        self.imageClubProfile.contentMode = .center

        // TITLE LABEL
        self.labelEventHeading.numberOfLines = 0
        self.labelEventHeading.lineBreakMode = .byWordWrapping

        self.labelEventHeading.setContentCompressionResistancePriority(
            .required,
            for: .vertical
        )

        self.labelEventHeading.setContentHuggingPriority(
            .required,
            for: .vertical
        )

        // DESCRIPTION LABEL
        self.labelEventDescription.numberOfLines = 0
        self.labelEventDescription.lineBreakMode = .byWordWrapping
        self.labelEventDescription.adjustsFontSizeToFitWidth = false
    }

    func configure(with notification: RunnrNotification) {

        var cleanedBody = notification.body ?? ""

        cleanedBody = cleanedBody.replacingOccurrences(
            of: "Tap to claim your reward!",
            with: ""
        )

        cleanedBody = cleanedBody.replacingOccurrences(
            of: "Tap to claim your rewards!",
            with: ""
        )

        cleanedBody = cleanedBody.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        self.labelTimestamp.text = formatDate(with: notification.createdAt)

        let config = UIImage.SymbolConfiguration(
            pointSize: 14,
            weight: .semibold
        )

        var symbolName = "calendar"

        // CLUB EVENT
        if notification.title.lowercased().contains("new club event:") {

            let eventTitle = notification.title
                .replacingOccurrences(
                    of: "New Club Event:",
                    with: ""
                )
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )

            let clubName = cleanedBody

            self.labelEventHeading.text = "\(clubName)\n\(eventTitle)"
            self.labelEventDescription.text = ""

            symbolName = "calendar"

        } else {

            self.labelEventHeading.text = notification.title
            self.labelEventDescription.text = cleanedBody

            // SOLO CHALLENGE
            if notification.title.lowercased().contains("challenge") {
                symbolName = "flag.checkered"
            }

            // FOLLOW
            if notification.type == "friend_joined" {
                symbolName = "person.fill"
            }
        }

        self.imageClubProfile.image = UIImage(
            systemName: symbolName,
            withConfiguration: config
        )?.withRenderingMode(.alwaysTemplate)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: 6,
                left: 0,
                bottom: 6,
                right: 0
            )
        )
    }
}
