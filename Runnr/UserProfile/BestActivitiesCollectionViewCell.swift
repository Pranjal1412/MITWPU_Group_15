//
//  BestActivitiesCollectionViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 07/01/26.
//

import UIKit

class BestActivitiesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewCellBackground: UIView!

    func configureCell() {
        self.viewCellBackground.layer.cornerRadius = 10

    }
}
