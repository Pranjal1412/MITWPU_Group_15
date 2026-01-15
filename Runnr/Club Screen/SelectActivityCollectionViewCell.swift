//
//  SelectActivityCollectionViewCell.swift
//  Runnr
//
//  Created by Aditi Bhange on 16/12/25.
//

import UIKit

class SelectActivityCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageActivity: UIImageView!
    @IBOutlet weak var labelActivityTitle: UILabel!
    @IBOutlet weak var viewCellBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(with activity: ClubActivity) {
        self.imageActivity.image = activity.image
        self.labelActivityTitle.text = activity.title
        self.labelActivityTitle.textColor = .white
    }
    
}
