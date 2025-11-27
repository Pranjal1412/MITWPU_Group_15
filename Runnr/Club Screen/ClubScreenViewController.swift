//
//  ClubScreenViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 26/10/25.
//
import Foundation
import UIKit

class ClubScreenViewController: UIViewController {

    @IBOutlet weak var segmentControlClubScreen: UISegmentedControl!
    @IBOutlet weak var searchBarFriendsScreen: UISearchBar!
    @IBOutlet weak var collectionViewExplore: UICollectionView!
    
    @IBOutlet var ButtonCreateClub: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ButtonCreateClub.isHidden = true
        settingCollectionView()
        settingElements()
        
        ButtonCreateClub.layer.cornerRadius = 75
        ButtonCreateClub.clipsToBounds = true
        
    }
    
    @IBAction func segmentShiftAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
         case 0:
            collectionViewExplore.isHidden = true
            ButtonCreateClub.isHidden = true
         case 1:
             collectionViewExplore.isHidden = false
             ButtonCreateClub.isHidden = true
             searchBarFriendsScreen.isHidden = false
             
         case 2:
            collectionViewExplore.isHidden = true
            ButtonCreateClub.isHidden = false
            searchBarFriendsScreen.isHidden = true
            
         default:
             break
         }
}
    func settingElements() {
        //segment edits
        segmentControlClubScreen.selectedSegmentIndex = 1
        segmentControlClubScreen.layer.borderWidth = 0.5
        segmentControlClubScreen.layer.borderColor = UIColor.accent.cgColor
        segmentControlClubScreen.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        
        //to remove the lines near the search Bar
        searchBarFriendsScreen.backgroundColor = .clear
        searchBarFriendsScreen.barTintColor = .clear
        searchBarFriendsScreen.isTranslucent = true
    }
    
   
    
    func settingCollectionView() {
        collectionViewExplore.dataSource = self
        collectionViewExplore.delegate = self
        
        collectionViewExplore.register(UINib(nibName: "ExploreScreenCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        view.overrideUserInterfaceStyle = .dark
        collectionViewExplore.contentInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }

}

extension ClubScreenViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ExploreScreenCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionViewExplore.frame.width - 80) / 2
        
        let size = CGSize(width: width, height: 246)
        return size
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
