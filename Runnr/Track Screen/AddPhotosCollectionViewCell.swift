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
                self.buttonDeletePhoto.configuration = .glass()
                self.buttonDeletePhoto.tintColor = .accent
                self.buttonDeletePhoto.setImage(UIImage(systemName: "multiply"), for: .normal)
            }
            else {
                self.buttonDeletePhoto.tintColor = .accent
                self.buttonDeletePhoto.setImage(UIImage(systemName: "multiply.circle"), for: .normal)
            }
        }
        else {
            self.buttonDeletePhoto.isHidden = value
        }
                
        self.imagePhotos.image = image
        self.imagePhotos.layer.cornerRadius = 10
        self.imagePhotos.clipsToBounds = true
    }
}
