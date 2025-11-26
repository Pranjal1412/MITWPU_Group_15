//
//  InsightsCollectionViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 19/11/25.
//

import UIKit

class InsightsScreenCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelUnits: UILabel!
    @IBOutlet weak var labelCardTitle: UILabel!
    @IBOutlet weak var labelTrend: UILabel!
    @IBOutlet weak var imageViewChevron: UIImageView!
    @IBOutlet weak var viewCellBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewCellBackground.layer.cornerRadius = 20
        
    }

}
