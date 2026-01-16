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
