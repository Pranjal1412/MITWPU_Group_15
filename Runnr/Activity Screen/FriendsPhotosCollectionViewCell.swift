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
        // Initialization code
    }
    func configure(with image: String) {
        print("inside cell function \(image)")
            imageCellFriends.image = UIImage(named: image)
            imageCellFriends.clipsToBounds = true
            imageCellFriends.layer.cornerRadius = 10
    }

}
