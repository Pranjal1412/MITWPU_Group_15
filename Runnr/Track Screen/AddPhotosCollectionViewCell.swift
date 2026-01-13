//
//  AddPhotosCollectionViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 06/01/26.
//

import UIKit

class AddPhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imagePhotos: UIImageView!
    @IBOutlet weak var buttonDeletePhoto: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with image: UIImage, hideCancel value: Bool) {
        
        if value == false {
            self.buttonDeletePhoto.isHidden = value
            
            if #available(iOS 26.0, *) {
                buttonDeletePhoto.configuration = .glass()
                buttonDeletePhoto.tintColor = .accent
                buttonDeletePhoto.setImage(UIImage(systemName: "multiply"), for: .normal)
            }
            else {
                buttonDeletePhoto.tintColor = .accent
                buttonDeletePhoto.setImage(UIImage(systemName: "multiply.circle"), for: .normal)
            }
        }
        else {
            self.buttonDeletePhoto.isHidden = value
        }
                
        imagePhotos.image = image
        imagePhotos.layer.cornerRadius = 10
        imagePhotos.clipsToBounds = true
    }
}
