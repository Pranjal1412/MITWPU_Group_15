//
//  CreateClubChooseSportViewController.swift
//  Runnr
//
//  Created by SDC-USER on 08/12/25.
//

import UIKit

class CreateClubViewController: UIViewController {

    @IBOutlet var labelCreateClub: UILabel!
    @IBOutlet var modalView: UIView!
    @IBOutlet var labelSubtitleCreateClub: UILabel!
    @IBOutlet var page1: UIView!
    @IBOutlet var page2: UIView!
    @IBOutlet var page3: UIView!
    @IBOutlet var buttonNext: UIButton!
    
    
    
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        
        modalView.layer.cornerRadius = 20
        modalView.clipsToBounds = true
        
        buttonNext.layer.cornerRadius = buttonNext.frame.height / 2.0
        buttonNext.titleLabel?.textColor = UIColor.black
        
        settingAttributedTextCreateClub()
        settingSubtitleCreateClub()
        settingPageProgress()
        
        
        
        // Do any additional setup after loading the view.
       
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        if currentPage < 3 {
            currentPage += 1
            updateUI()
        }
        else {
            if let presenter = self.presentingViewController {
                self.dismiss(animated: true) {
                    let rootVC = ClubProfileViewController(nibName: "ClubProfileViewController", bundle: nil)
                    let destinationVC = UINavigationController(rootViewController: rootVC)
                    destinationVC.modalPresentationStyle = .fullScreen
                    presenter.present(destinationVC, animated: true)
                    
                }
            }
                    
        }
    }

    @IBAction func dismissModalPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func updateUI() {
        switch currentPage {
        case 1:
            settingAttributedTextCreateClub()
            settingSubtitleCreateClub()
            pageIndicator(p1: .accent, p2: .gray, p3: .gray)
            buttonNext.setTitle("Next", for: .normal)
            
        case 2:
            setSecondPageText()
            pageIndicator(p1: .gray, p2: .accent, p3: .gray)
            buttonNext.setTitle("Next", for: .normal)
            
        case 3:
            setThirdPageText()
            pageIndicator(p1: .gray, p2: .gray, p3: .accent)
            buttonNext.setTitle("Complete", for: .normal)
            
        default: break
        }
    }

    func pageIndicator(p1: UIColor, p2: UIColor, p3: UIColor) {
        page1.backgroundColor = p1
        page2.backgroundColor = p2
        page3.backgroundColor = p3
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
        
        labelSubtitleCreateClub.sizeToFit()
    }
    
    
    func setSecondPageText() {
            
            let thinFont = UIFont(name: "SFProText-UltraThin",size: 33)
                ?? UIFont.systemFont(ofSize: 33, weight: .ultraLight)
            let boldFont = UIFont(name: "SFProText-Semibold",size: 33)
                ?? UIFont.systemFont(ofSize: 33, weight: .semibold)

            let firstPart = NSAttributedString(string: "Describe your", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
            let secondPart = NSAttributedString(string: " Club", attributes: [.font: boldFont, .foregroundColor: UIColor.white])

            let final = NSMutableAttributedString()
            final.append(firstPart)
            final.append(secondPart)
            labelCreateClub.attributedText = final
            
            labelSubtitleCreateClub.text = "Unlock your club’s identity, pick any one"
        }
    
    
    func setThirdPageText() {
           
           let thinFont = UIFont(name: "SFProText-UltraThin",size: 33)
               ?? UIFont.systemFont(ofSize: 33, weight: .ultraLight)
           let boldFont = UIFont(name: "SFProText-Semibold",size: 33)
               ?? UIFont.systemFont(ofSize: 33, weight: .semibold)

           let firstPart = NSAttributedString(string: "Name your", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
           let secondPart = NSAttributedString(string: " Club", attributes: [.font: boldFont, .foregroundColor: UIColor.white])

           let final = NSMutableAttributedString()
           final.append(firstPart)
           final.append(secondPart)
           labelCreateClub.attributedText = final
           
           labelSubtitleCreateClub.text = "Shape your club and bring it to life!"
       }
       
    
    func settingPageProgress() {
        page1.layer.cornerRadius = page1.frame.height / 2.0
        page2.layer.cornerRadius = page2.frame.height / 2.0
        page3.layer.cornerRadius = page3.frame.height / 2.0
        
        pageIndicator(p1: .accent, p2: .gray, p3: .gray)

    }
   
}
