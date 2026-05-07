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
    }

    func configureCell(event: ClubEvents) {
        labelEvent.text = event.eventName
        labelDescriptionOfEvent.text = event.eventDescription
    }
}
