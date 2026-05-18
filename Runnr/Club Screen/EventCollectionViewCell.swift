//
//  EventCollectionViewCell.swift
//  Runnr
//

import UIKit

// MARK: - Poll Delegate

protocol EventPollCellDelegate: AnyObject {
    func pollCell(_ cell: EventCollectionViewCell,
                  didVote voteType: PollVoteType,
                  for eventID: UUID)
}

// MARK: - Cell

class EventCollectionViewCell: UICollectionViewCell {

    // MARK: - Existing IBOutlets
    @IBOutlet weak var labelEventDescription: UILabel!
    @IBOutlet weak var labelEventDate: UILabel!
    @IBOutlet weak var labelStartTime: UILabel!
    @IBOutlet weak var labelEventName: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var labelStartAddress: UILabel!
    @IBOutlet weak var labelEndAddress: UILabel!
    @IBOutlet weak var viewDateBackground: UIView!
    @IBOutlet weak var viewTimeBackground: UIView!
    @IBOutlet weak var labelDummyText: UILabel!
    @IBOutlet weak var viewPollBackground: UIView!

    // Vote circle buttons (small 45pt circles in the XIB)
    @IBOutlet weak var pollButtonJoining: UIButton!
    @IBOutlet weak var pollButtonMaybe: UIButton!
    @IBOutlet weak var pollButtonNo: UIButton!

    // Progress bars already in the XIB — connect via IBOutlet
    @IBOutlet weak var progressBarJoining: UIProgressView!
    @IBOutlet weak var progressBarMaybe: UIProgressView!
    @IBOutlet weak var progressBarNo: UIProgressView!

    // Percentage labels already in the XIB — connect via IBOutlet
    @IBOutlet weak var labelPctJoining: UILabel!
    @IBOutlet weak var labelPctMaybe: UILabel!
    @IBOutlet weak var labelPctNo: UILabel!

    // MARK: - State
    weak var delegate: EventPollCellDelegate?
    private var eventID: UUID?
    private var pollSummary: EventPollSummary?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        viewMain.layer.cornerRadius           = 15
        viewDateBackground.layer.cornerRadius = 15
        viewTimeBackground.layer.cornerRadius = 15
        viewPollBackground.layer.cornerRadius = 15

        let accentColor = UIColor(named: "AccentColor") ?? .systemGreen

        // Progress bar colours
        progressBarJoining.progressTintColor = accentColor
        progressBarJoining.trackTintColor    = UIColor(white: 0.25, alpha: 1)

        progressBarMaybe.progressTintColor   = .systemOrange
        progressBarMaybe.trackTintColor      = UIColor(white: 0.25, alpha: 1)

        progressBarNo.progressTintColor      = .systemRed
        progressBarNo.trackTintColor         = UIColor(white: 0.25, alpha: 1)

        // Round progress bar tracks
        for bar in [progressBarJoining, progressBarMaybe, progressBarNo] {
            bar?.layer.cornerRadius = 2
            bar?.clipsToBounds = true
            bar?.layer.sublayers?.forEach { $0.cornerRadius = 2 }
        }

        // Wire tap actions
        pollButtonJoining.addTarget(self, action: #selector(joiningTapped),  for: .touchUpInside)
        pollButtonMaybe.addTarget(self,   action: #selector(maybeTapped),    for: .touchUpInside)
        pollButtonNo.addTarget(self,      action: #selector(notGoingTapped), for: .touchUpInside)
    }

    // MARK: - Configure

    func configureCell(event: ClubEvents, pollSummary: EventPollSummary? = nil) {
        self.eventID     = event.eventID
        self.pollSummary = pollSummary

        labelEventName.text        = event.eventName
        labelEventDescription.text = event.eventDescription
        labelDummyText.text        = (event.eventDescription == "") ? "" : " "
        labelStartAddress.text     = event.startLocation ?? ""
        labelEndAddress.text       = event.endLocation   ?? ""

        let df        = DateFormatter()
        df.locale     = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "MMM d, yyyy"
        labelEventDate.text = event.eventDate.map { df.string(from: $0) } ?? ""
        labelStartTime.text = event.startTime ?? ""

        updatePollUI()
    }

    // MARK: - Poll UI

    private func updatePollUI() {
        let joining  = pollSummary?.joiningCount  ?? 0
        let maybe    = pollSummary?.maybeCount    ?? 0
        let notGoing = pollSummary?.notGoingCount ?? 0
        let myVote   = pollSummary?.myVote
        let total    = joining + maybe + notGoing

        // Fractions for progress bars
        let joiningFrac  = total > 0 ? Float(joining)  / Float(total) : 0
        let maybeFrac    = total > 0 ? Float(maybe)    / Float(total) : 0
        let notGoingFrac = total > 0 ? Float(notGoing) / Float(total) : 0

        // Rounded percentages for labels
        let joiningPct  = total > 0 ? Int(round(Double(joining)  / Double(total) * 100)) : 0
        let maybePct    = total > 0 ? Int(round(Double(maybe)    / Double(total) * 100)) : 0
        let notGoingPct = total > 0 ? Int(round(Double(notGoing) / Double(total) * 100)) : 0

        // Animate progress bars
        progressBarJoining.setProgress(joiningFrac,  animated: true)
        progressBarMaybe.setProgress(maybeFrac,      animated: true)
        progressBarNo.setProgress(notGoingFrac,      animated: true)

        // Update percentage labels
        labelPctJoining.text = "\(joiningPct)%"
        labelPctMaybe.text   = "\(maybePct)%"
        labelPctNo.text      = "\(notGoingPct)%"

        // Style circle vote buttons
        let accentColor = UIColor(named: "AccentColor") ?? .systemGreen
        styleVoteButton(pollButtonJoining, isSelected: myVote == .joining,  color: accentColor)
        styleVoteButton(pollButtonMaybe,   isSelected: myVote == .maybe,    color: .systemOrange)
        styleVoteButton(pollButtonNo,      isSelected: myVote == .notGoing, color: .systemRed)
    }

    /// Swaps the circle icon between filled (selected) and outline (unselected).
    private func styleVoteButton(_ button: UIButton, isSelected: Bool, color: UIColor) {
        let iconName = isSelected ? "checkmark.circle.fill" : "circle"
        var config   = UIButton.Configuration.plain()
        config.image = UIImage(systemName: iconName,
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .medium))
        config.baseForegroundColor = isSelected ? color : UIColor.systemGray
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        button.configuration = config
    }

    // MARK: - Actions

    @objc private func joiningTapped()  { handleVote(.joining)  }
    @objc private func maybeTapped()    { handleVote(.maybe)    }
    @objc private func notGoingTapped() { handleVote(.notGoing) }

    private func handleVote(_ voteType: PollVoteType) {
        guard let eventID = eventID else { return }
        delegate?.pollCell(self, didVote: voteType, for: eventID)
    }
}
