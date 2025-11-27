//
//  CollectionViewCellClubExploreScreen.swift
//  Runnr
//
//  Created by SDC-USER on 18/11/25.
//

import UIKit

class ExploreScreenCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewExploreClub: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewExploreClub.layer.cornerRadius = 10
        
        viewExploreClub.clipsToBounds = true
        
    }

}
