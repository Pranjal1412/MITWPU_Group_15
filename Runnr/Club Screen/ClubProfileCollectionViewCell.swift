//
//  ClubProfileCollectionViewCell.swift
//  Runnr
//
//  Created by Aditi Bhange on 15/12/25.
//

import UIKit

class ClubProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        
        
    }
    func configureCell(with data: UIImage) {
        imageView.image = data
    }
    
    
    
}
