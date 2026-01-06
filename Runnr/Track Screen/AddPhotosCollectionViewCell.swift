//
//  AddPhotosCollectionViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 06/01/26.
//

import UIKit

class AddPhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imagePhotos: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(with image: UIImage) {
        imagePhotos.layer.cornerRadius = 10
        imagePhotos.image = image
    }
}
