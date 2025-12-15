//
//  InsightsCollectionViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 19/11/25.
//

import UIKit

class InsightsScreenCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelCardTitle: UILabel!
    @IBOutlet weak var labelTrend: UILabel!
    @IBOutlet weak var imageViewChevron: UIImageView!
    @IBOutlet weak var viewCellBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewCellBackground.layer.cornerRadius = 20
        viewCellBackground.layer.masksToBounds = false
        viewCellBackground.clipsToBounds = false
        
    }
    
    func settingLabelStyle(withValue value: String, withUnit unit: String) {
        
        let boldFont = UIFont(name: "SFProText-Bold", size: 32) ?? UIFont.systemFont(ofSize: 32, weight: .bold)
        let thinFont = UIFont(name: "SFProText-Thin", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let numberText = NSAttributedString(string: value + " ", attributes: [.font: boldFont, .foregroundColor: UIColor(named: "AccentColor") ?? UIColor.white])
        let unitsText = NSAttributedString(string: unit, attributes: [.font: thinFont, .foregroundColor:UIColor(named: "AccentColor") ?? UIColor.white])

        let fullText = NSMutableAttributedString()
        fullText.append(numberText)
        fullText.append(unitsText)

        labelNumber.attributedText = fullText
    }
    
    func configureCell(with data: CardData) {
//        labelNumber.text = data.number
        
        settingLabelStyle(withValue: data.number, withUnit: data.unit)
        labelCardTitle.text = data.title
        labelTrend.text = data.trend
        imageViewChevron.image = UIImage(systemName: data.trendChevron)
        
        if imageViewChevron.image == UIImage(systemName: "chevron.up.2") {
            imageViewChevron.tintColor = .accent
        }
        else {
            imageViewChevron.tintColor = .red
        }
    }

}
