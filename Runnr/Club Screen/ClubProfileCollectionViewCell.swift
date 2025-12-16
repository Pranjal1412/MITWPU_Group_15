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
        
        
        //imageView.layer.cornerRadius = 8
        //imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        
    }
    func configureCell(with data: posts) {
        imageView.image = UIImage(named: data.images)
    }
    
    
    
}
