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
        viewCellBackground.layer.masksToBounds = false
        viewCellBackground.clipsToBounds = false
        
        
    }
    
    func configureCell(with data: CardData) {
        labelNumber.text = data.number
        labelUnits.text = data.units
        labelCardTitle.text = data.title
        labelTrend.text = data.trend
        imageViewChevron.image = UIImage(systemName: data.trendChevron)
        
        if imageViewChevron.image == UIImage(systemName: "chevron.up.2") {
            imageViewChevron.tintColor = .accent
        }
        else {
            imageViewChevron.tintColor = .red
        }
    }

}
