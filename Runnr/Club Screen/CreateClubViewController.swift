//
//  CreateClubChooseSportViewController.swift
//  Runnr
//
//  Created by SDC-USER on 08/12/25.
//

import UIKit

class CreateClubViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var labelCreateClub: UILabel!
    @IBOutlet var modalView: UIView!
    @IBOutlet var labelSubtitleCreateClub: UILabel!
    @IBOutlet var page1: UIView!
    @IBOutlet var page2: UIView!
    @IBOutlet var page3: UIView!
    @IBOutlet var buttonNext: UIButton!
    @IBOutlet weak var collectionViewClubActivity: UICollectionView!
    @IBOutlet var lastpageView: UIView!
    @IBOutlet var clubNameView: UIView!
    @IBOutlet var clubDescriptionView: UIView!
    
    
    @IBOutlet var clubNameTextField: UITextField!
    @IBOutlet var clubDescriptionTextField: UITextView!
    
    
    var currentPage = 1
    var clubDraft = CreateClubDraft()
    
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
        
        self.collectionViewClubActivity.dataSource = self
        self.collectionViewClubActivity.delegate = self
        
        self.collectionViewClubActivity.register(UINib(nibName: "SelectActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectActivityCollectionViewCell")
        self.collectionViewClubActivity.register(UINib(nibName: "ClubDescriptionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ClubDescriptionCollectionViewCell")
               
        clubNameView.layer.cornerRadius = 10
        clubNameView.clipsToBounds = true
        clubNameView.layer.borderColor = UIColor.gray.cgColor
        clubNameView.layer.borderWidth = 1.0
        
        clubDescriptionView.layer.cornerRadius = 10
        clubDescriptionView.clipsToBounds = true
        clubDescriptionView.layer.borderColor = UIColor.gray.cgColor
        clubDescriptionView.layer.borderWidth = 1.0
        
        lastpageView.isHidden = true
        
        
        clubNameTextField.delegate = self
        clubDescriptionTextField.delegate = self
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
                   
                    let nextClub = MyClubData(
                        clubProfileImg: UIImage(named: "club1")!,
                        clubName: self.clubDraft.clubName ?? "",
                        numberOfMembers: "0",
                        sport: self.clubDraft.activity ?? "",
                        isPublic: true,
                        clubMotive: self.clubDraft.motive ?? "",
                        clubDescription: self.clubDraft.clubDescription ?? ""
                    )
                    
                    myClubs.append(nextClub)
                    
                    rootVC.isMyClub = true
                    rootVC.myClubProfileData = nextClub
                    
                    rootVC.buttonTitle = "Edit Club Profile"
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
            collectionViewClubActivity.isHidden = false
            self.collectionViewClubActivity.reloadData()
            lastpageView.isHidden = true
            
            
        case 2:
            setSecondPageText()
            pageIndicator(p1: .gray, p2: .accent, p3: .gray)
            buttonNext.setTitle("Next", for: .normal)
            collectionViewClubActivity.isHidden = false
            self.collectionViewClubActivity.reloadData()
            lastpageView.isHidden = true
            
        case 3:
            setThirdPageText()
            pageIndicator(p1: .gray, p2: .gray, p3: .accent)
            buttonNext.setTitle("Complete", for: .normal)
            collectionViewClubActivity.isHidden = true
            lastpageView.isHidden = false
            
            registerNotifications()
            hideKeyboardWhenTappedAround()
            
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

extension CreateClubViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.currentPage == 1 {
            return clubActivityOptions.count
        }
        else {
            return clubDescriptions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.currentPage == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectActivityCollectionViewCell", for: indexPath) as! SelectActivityCollectionViewCell
            
            cell.configureCell(with: clubActivityOptions[indexPath.row])
            cell.viewCellBackground.layer.borderColor = UIColor.lightGray.cgColor
            cell.viewCellBackground.layer.borderWidth = 1
            cell.viewCellBackground.layer.cornerRadius = 10.0
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClubDescriptionCollectionViewCell", for: indexPath) as! ClubDescriptionCollectionViewCell
            
            cell.labelDescription.text = clubDescriptions[indexPath.row]
            cell.viewCellBackground.layer.borderColor = UIColor.lightGray.cgColor
            cell.viewCellBackground.layer.borderWidth = 1
            cell.viewCellBackground.layer.cornerRadius = 10.0
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.currentPage == 1 {
            let width = (self.collectionViewClubActivity.frame.width - 60) / 2
            let height = (self.collectionViewClubActivity.frame.height - 60) / 2
            
            return CGSize(width: width, height: height)
        }
        else {
            
            return CGSize(width: collectionView.frame.width, height: CGFloat(Int(collectionView.frame.height - 60) / clubDescriptions.count))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.currentPage == 1 {
            clubDraft.activity = clubActivityOptions[indexPath.row].title
            let cell = collectionView.cellForItem(at: indexPath) as! SelectActivityCollectionViewCell
            
            if cell.viewCellBackground.layer.borderColor == UIColor.accent.cgColor {
                cell.viewCellBackground.layer.borderColor = UIColor.lightGray.cgColor
                cell.imageActivity.tintColor = .white
                cell.labelActivityTitle.textColor = .white
                cell.viewCellBackground.layer.borderWidth = 1
            }
            else {
               
                cell.viewCellBackground.layer.borderColor = UIColor.accent.cgColor
                cell.imageActivity.tintColor = .accent
                cell.labelActivityTitle.textColor = .accent
                cell.viewCellBackground.layer.borderWidth = 3
            }
        }
        
        else {
            clubDraft.motive = clubDescriptions[indexPath.row]
            let cell = collectionView.cellForItem(at: indexPath) as! ClubDescriptionCollectionViewCell
            
            if cell.imageSelected.isHidden {
                cell.imageSelected.isHidden = false
                cell.viewCellBackground.layer.borderColor = UIColor.accent.cgColor
                cell.viewCellBackground.layer.borderWidth = 3
                cell.labelDescription.textColor = .accent
            }
            else {
                cell.imageSelected.isHidden = true
                cell.viewCellBackground.layer.borderColor = UIColor.lightGray.cgColor
                cell.viewCellBackground.layer.borderWidth = 1
                cell.labelDescription.textColor = .lightGray
            }
        }
        
    }
}

extension CreateClubViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification){}
    
    @objc private func keyboardWillHide(notification: NSNotification){}
}

extension CreateClubViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        clubDraft.clubDescription = textView.text
    }
}


