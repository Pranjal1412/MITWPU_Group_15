//
//  CreateClubChooseSportViewController.swift
//  Runnr
//
//  Created by SDC-USER on 08/12/25.
//

import UIKit

class CreateClubChooseSportViewController: UIViewController {

    @IBOutlet var labelCreateClub: UILabel!
    
    @IBOutlet var viewMainBackground: UIView!
    
    @IBOutlet var modalView: UIView!
    
    @IBOutlet var labelSubtitleCreateClub: UILabel!
    
    @IBOutlet var page1: UIView!
    
    @IBOutlet var page2: UIView!
    
    @IBOutlet var page3: UIView!
    
    @IBOutlet var buttonNext: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        
        modalView.layer.cornerRadius = 10
        modalView.clipsToBounds = true
        
        buttonNext.layer.cornerRadius = 10
        buttonNext.titleLabel?.textColor = UIColor.black
        
        settingAttributedTextCreateClub()
        settingSubtitleCreateClub()
        settingPageProgress()
        
        
        
        // Do any additional setup after loading the view.
       
    }

    func settingAttributedTextCreateClub() {

       
        labelCreateClub.numberOfLines = 1
        labelCreateClub.textAlignment = .center
        
        let thinFont = UIFont(name: "SFProText-UltraThin",size: 33) ?? UIFont.systemFont(ofSize: 33, weight: .ultraLight)
        let boldFont = UIFont(name: "SFProText-Semibold",size: 33) ?? UIFont.systemFont(ofSize: 33, weight: .semibold)
        
        let firstPart = NSAttributedString(string: "Choose your",attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        let secondPart = NSAttributedString(string: " Sport",attributes: [.font: boldFont, .foregroundColor: UIColor.white])

        let attributedText = NSMutableAttributedString()
        attributedText.append(firstPart)
        attributedText.append(secondPart)
        
        labelCreateClub.attributedText = attributedText
    
    }
    
    func settingSubtitleCreateClub() {
        labelSubtitleCreateClub.text = "Launch your club with your favourite sport!"
        
        labelSubtitleCreateClub.textAlignment = .center
        labelSubtitleCreateClub.textColor = .white
        labelSubtitleCreateClub.numberOfLines = 2
    }
    
    func settingPageProgress() {
        page1.layer.cornerRadius = 5
        page2.layer.cornerRadius = 5
        page3.layer.cornerRadius = 5
        
        page1.backgroundColor = .accent
        page2.backgroundColor = .gray
        page3.backgroundColor = .gray
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
