//
//  AddPhotosCollectionViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 06/01/26.
//

import UIKit

protocol AddPhotosCollectionViewCellDelegate: AnyObject {
    func deletePhoto(at index: Int)
}

class AddPhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imagePhotos: UIImageView!
    @IBOutlet weak var buttonDeletePhoto: UIButton!
    
    var delegate: AddPhotosCollectionViewCellDelegate?
    var cellIndex: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func deletePhotoButtonTapped(_ sender: UIButton) {
        delegate?.deletePhoto(at: self.cellIndex)
    }
    
    func configureCell(with image: UIImage, hideCancel value: Bool, index: Int) {
        
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
        
        self.cellIndex = index
        
        imagePhotos.image = image
        imagePhotos.layer.cornerRadius = 10
        imagePhotos.clipsToBounds = true
    }
}
