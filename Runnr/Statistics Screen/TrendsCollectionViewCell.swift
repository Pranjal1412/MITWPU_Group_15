//
//  DistanceCollectionViewCell.swift
//  Runnr
//
//  Created by Nidhi Aralkar on 10/12/25.
//

import UIKit

class TrendsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelDistanceTrends: UILabel!
    @IBOutlet weak var viewDistanceCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewDistanceCell.layer.cornerRadius = 20
        viewDistanceCell.layer.masksToBounds = false
        viewDistanceCell.clipsToBounds = false
        
        // Initialization code
    }
    func configureCell(with data: DistanceCardData) {
        labelDistanceTrends.text = data.trends
    }

}

