//
//  InsightsScreenCollectionViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 18/11/25.
//

import UIKit

class InsightsScreenCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var imageViewChevron: UIImageView!
    @IBOutlet weak var labelCardTitle: UILabel!
    @IBOutlet weak var labelTrend: UILabel!
    @IBOutlet weak var labelUnits: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackground.layer.cornerRadius = 20
    }

}
