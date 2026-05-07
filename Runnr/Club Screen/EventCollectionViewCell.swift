//
//  EventCollectionViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 30/03/26.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var buttonDate: UIButton!
    @IBOutlet weak var buttonTime: UIButton!
    @IBOutlet weak var labelDescriptionOfEvent: UILabel!
    @IBOutlet weak var viewEventStartEnd: UIView!
    @IBOutlet weak var labelStartFrom: UILabel!
    @IBOutlet weak var labelDateAndTime: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var buttonMaybe: UIButton!
    @IBOutlet weak var buttonNo: UIButton!
    @IBOutlet weak var buttonYes: UIButton!
    @IBOutlet weak var labelAreYouComing: UILabel!
    @IBOutlet weak var labelEndAt: UILabel!
    @IBOutlet weak var labelEvent: UILabel!
    @IBOutlet weak var viewMain: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        // Initialization code
    }
    func setup() {
        viewMain.layer.cornerRadius = 15
        viewEventStartEnd.layer.cornerRadius = 15
    }

    func configureCell(event: ClubEvents) {
        labelEvent.text = event.eventName
        labelDescriptionOfEvent.text = event.eventDescription
        labelStartFrom.text = "Start: " + (event.startLocation ?? "")
        labelEndAt.text = "Finish: " + (event.endLocation ?? "")
        // Format date (e.g., May 7, 2026)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMM d, yyyy"

        var dateString = ""
        if let date = event.eventDate {
            dateString = dateFormatter.string(from: date)
        } else if let date = (event.eventDate as? NSDate) as Date? {
            dateString = dateFormatter.string(from: date)
        }

        let startTimeString = (event.startTime) ?? ""
        let endTimeString = (event.endTime) ?? ""

        // labelDateAndTime: date + startTime
        if !dateString.isEmpty && !startTimeString.isEmpty {
            labelDateAndTime.text = "\(dateString)  \(startTimeString)"
        } else if !dateString.isEmpty {
            labelDateAndTime.text = dateString
        } else {
            labelDateAndTime.text = startTimeString
        }

        // labelDateTime: date + endTime
        if !dateString.isEmpty && !endTimeString.isEmpty {
            labelDateTime.text = "\(dateString)  \(endTimeString)"
        } else if !dateString.isEmpty {
            labelDateTime.text = dateString
        } else {
            labelDateTime.text = endTimeString
        }
    }
}

