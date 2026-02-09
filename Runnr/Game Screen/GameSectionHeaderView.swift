//
//  GameSectionHeaderView.swift
//  Runnr
//
//  Created by SDC-USER on 08/01/26.
//

import UIKit

class GameSectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var labelSectionHeading: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureHeader(for selectedSegment: Int, tableSection: Int = 0) {
        let thinFont = UIFont(name: "SFProText-Thin", size: 25) ?? UIFont.systemFont(ofSize: 25, weight: .thin)
        let boldFont = UIFont(name: "SFProText-Bold", size: 25) ?? UIFont.boldSystemFont(ofSize: 25)
        
        let activeText = NSAttributedString(string: "Active ", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        let challengesText = NSAttributedString(string: "Challenges", attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        let duelText = NSAttributedString(string: "Duel ", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        
        let monthlyText = NSAttributedString(string: "Monthly ", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        
        let challengeText = NSAttributedString(string: "Challenge", attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        let monthText = NSMutableAttributedString()
        monthText.append(monthlyText)
        monthText.append(challengeText)
        
        let fullText = NSMutableAttributedString()
        fullText.append(activeText)
        fullText.append(challengesText)
        
        let newText = NSMutableAttributedString()
        newText.append(duelText)
        newText.append(challengesText)
        
        if selectedSegment == 0 {
            labelSectionHeading.attributedText = fullText
        }
        else if selectedSegment == 1 && tableSection == 0 {
            labelSectionHeading.attributedText = monthText
        }
        else if selectedSegment == 1 && tableSection == 1 {
            labelSectionHeading.attributedText = newText
        }
    }
    
}
