//
//  EventCollectionViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 30/03/26.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {

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
    @IBOutlet weak var pollButtonJoining: UIButton!
    @IBOutlet weak var pollButtonMaybe: UIButton!
    @IBOutlet weak var pollButtonNo: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        self.viewMain.layer.cornerRadius = 15
        self.viewDateBackground.layer.cornerRadius = 15
        self.viewTimeBackground.layer.cornerRadius = 15
        self.viewPollBackground.layer.cornerRadius = 15
    }

    func configureCell(event: ClubEvents) {
        self.labelEventName.text = event.eventName
        self.labelEventDescription.text = event.eventDescription
        
        if event.eventDescription == "" {
            self.labelDummyText.text = ""
        }
        else {
            self.labelDummyText.text = " "

        }
        
        self.labelStartAddress.text = (event.startLocation ?? "")
        self.labelEndAddress.text = (event.endLocation ?? "")
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

        self.labelEventDate.text = dateString
        self.labelStartTime.text = startTimeString
    }
}

