import UIKit

class FriendsPhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageCellFriends: UIImageView!

    func configure(with image: UIImage) {
        imageCellFriends.image = image
        imageCellFriends.clipsToBounds = true
        imageCellFriends.layer.cornerRadius = 10
    }

}
