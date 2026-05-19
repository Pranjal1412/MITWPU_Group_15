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

    func configureCell(with activity: ClubActivityOptions) {
        self.imageActivity.image = activity.image
        self.labelActivityTitle.text = activity.title.rawValue
        self.labelActivityTitle.textColor = .white
    }

}
