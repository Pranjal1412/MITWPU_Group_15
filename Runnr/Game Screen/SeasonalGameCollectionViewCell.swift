//
//  SeasonalGameCollectionViewCell.swift
//  Runnr
//
//  Created by Pranjal Shinde on 27/01/26.
//

import UIKit

class SeasonalGameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewCellBackground: UIView!
    @IBOutlet weak var labelMonthlyEvent: UILabel!
    @IBOutlet weak var labelSeason1Month: UILabel!
    @IBOutlet weak var viewGreyLine: UIView!
    @IBOutlet weak var viewMonthlyEvent: UIView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var buttonInviteFriend: UIButton!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var progressViewCapturedTiles: UIProgressView!
    @IBOutlet weak var labelGoal: UILabel!
    @IBOutlet weak var labelNowLive: UILabel!
    @IBOutlet weak var imageViewGameBackground: UIImageView!
    @IBOutlet weak var labelBattleRun: UILabel!
    @IBOutlet weak var viewCountDown: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        // Initialization code
    }
    func configure() {
        viewCellBackground.layer.cornerRadius = 15
        viewCountDown.layer.cornerRadius = 15
        viewCellBackground.clipsToBounds = true
        
        viewMonthlyEvent.layer.cornerRadius = viewMonthlyEvent.frame.height / 2
        viewMonthlyEvent.clipsToBounds = true
        
        buttonInviteFriend.layer.cornerRadius = buttonInviteFriend.frame.size.height / 2
        buttonInviteFriend.clipsToBounds = true
        imageView1.layer.cornerRadius = imageView1.frame.size.height / 2
        imageView1.clipsToBounds = true
        imageView2.layer.cornerRadius = imageView1.frame.size.height / 2
        imageView2.clipsToBounds = true
        imageView3.layer.cornerRadius = imageView1.frame.size.height / 2
        imageView3.clipsToBounds = true
    }

}
