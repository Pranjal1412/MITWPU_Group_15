//
//  EventCollectionViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 30/03/26.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelEventName: UILabel!
    @IBOutlet weak var labelEventDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(event: ClubEvents) {
        labelEventName.text = event.eventName
        labelEventDescription.text = event.eventDescription
    }
}
