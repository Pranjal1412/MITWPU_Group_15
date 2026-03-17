//
//  PostCollectionViewCell.swift
//  Runnr
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var heartImageButton: UIButton!
    
    var isHeartSelected = false
    var onLikeToggled: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
    }
    
    @IBAction func heartTapped(_ sender: UIButton) {
        isHeartSelected.toggle()
        onLikeToggled?(isHeartSelected)
        if isHeartSelected {
            heartImageButton.tintColor = .systemRed
        } else {
            heartImageButton.tintColor = .white
        }
    }
    
    func configureCell(with data: UIImage, isLiked: Bool) {
        imageView.image = data
        isHeartSelected = isLiked
        if isHeartSelected {
            heartImageButton.tintColor = .systemRed
        } else {
            heartImageButton.tintColor = .white
        }
    }

}
