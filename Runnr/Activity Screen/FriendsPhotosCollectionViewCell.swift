//
//  CollectionViewCell.swift
//  Runnr
//
//  Created by Archit Kankaria on 16/12/25.
//

import UIKit

class FriendsPhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageCellFriends: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with image: String) {
        imageCellFriends.image = UIImage(named: image)
        imageCellFriends.clipsToBounds = true
        imageCellFriends.layer.cornerRadius = 10
    }

}
