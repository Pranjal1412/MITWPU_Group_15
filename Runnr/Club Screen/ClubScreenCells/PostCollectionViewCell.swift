//
//  PostCollectionViewCell.swift
//  Runnr
//

import UIKit
import Kingfisher

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
    
    func configureCell(with data: ClubPostDetail, isLiked: Bool) {
        
        if let url = URL(string: data.post.postImageURL!) {
            imageView.kf.setImage(with: url)
        }
        
        isHeartSelected = isLiked
        if isHeartSelected {
            heartImageButton.tintColor = .systemRed
        } else {
            heartImageButton.tintColor = .white
        }
    }

}
