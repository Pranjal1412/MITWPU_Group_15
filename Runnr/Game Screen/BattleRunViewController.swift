//
//  BattleRunViewController.swift
//  Runnr
//
//  Created by Archit Kankaria on 17/12/25.
//

import UIKit

class BattleRunViewController: UIViewController {

    
    @IBOutlet weak var viewFriend: UIView!
    @IBOutlet weak var viewYou: UIView!
    @IBOutlet weak var imageFriends: UIImageView!
    @IBOutlet weak var imageYour: UIImageView!
    @IBOutlet weak var labelFriendsPoints: UILabel!
    @IBOutlet weak var labelYourPoints: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imageGameMap: UIImageView!
    @IBOutlet weak var viewEnds: UIView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
        }

        func setupUI() {

            imageGameMap.image = UIImage(named: "battle_board")
            imageGameMap.contentMode = .scaleAspectFit
            imageGameMap.clipsToBounds = true
            viewEnds.layer.cornerRadius = viewEnds.bounds.height / 2
            viewEnds.layer.borderWidth = 1
            viewEnds.layer.borderColor = UIColor(
                red: 173/255,
                green: 248/255,
                blue: 69/255,
                alpha: 1
            ).cgColor

            labelTime.text = "10 days 3 hrs"
            imageYour.image = UIImage(named: "you_avatar")        // your asset names
            imageFriends.image = UIImage(named: "friend_avatar")

            for img in [imageYour, imageFriends] {
                img?.layer.cornerRadius = (img?.bounds.height ?? 0) / 2
                img?.clipsToBounds = true
            }

            labelYourPoints.text = "Ⓡ 0"
            labelFriendsPoints.text = "Ⓡ 300"
            
            viewYou.backgroundColor = .systemCyan
            viewFriend.backgroundColor = .systemPink
            viewYou.layer.cornerRadius = 10
            viewFriend.layer.cornerRadius = 10
        }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

