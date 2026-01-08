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
    @IBOutlet var labelCreateyourOwnClub: UILabel!
    @IBOutlet var tableViewFriends: UITableView!
    @IBOutlet var joinedClubCollectionView: UICollectionView!
    @IBOutlet var yourClubLabel: UILabel!
    
    let systemOS = UIDevice.current.systemVersion
    
    var friendsDataArray: [friendsData] = [
        friendsData(profilePhoto: "user1", name: "Dave Johnson", isFollowing: false),
        friendsData(profilePhoto: "user2", name: "Mark Brown", isFollowing: true),
        friendsData(profilePhoto: "user3", name: "Sophia Lee", isFollowing: false),
        friendsData(profilePhoto: "user4", name: "Liam Carter", isFollowing: false)
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ButtonCreateClub.isHidden = true
        labelCreateyourOwnClub.isHidden = true
        tableViewFriends.isHidden = true
        
        settingCollectionView()
        settingElements()
        settingAttributedText()
        
        tableViewFriends.dataSource = self
        tableViewFriends.delegate = self
        tableViewFriends.register(UINib(nibName: "FriendListTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if myClubs.isEmpty == false {
            joinedClubCollectionView.isHidden = false
            yourClubLabel.isHidden = false
        }
        
        joinedClubCollectionView.reloadData()
        tableViewFriends.reloadData()
        collectionViewExplore.reloadData()
    }
    
    @IBAction func segmentShiftAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
         case 0:
            collectionViewExplore.isHidden = true
            ButtonCreateClub.isHidden = true
            searchBarFriendsScreen.isHidden = false
            labelCreateyourOwnClub.isHidden = true
            tableViewFriends.isHidden = false
            searchBarFriendsScreen.placeholder = "Search for others"
            joinedClubCollectionView.isHidden = true
            yourClubLabel.isHidden = true
         case 1:
            collectionViewExplore.isHidden = false
            ButtonCreateClub.isHidden = true
            searchBarFriendsScreen.isHidden = false
            labelCreateyourOwnClub.isHidden = true
            tableViewFriends.isHidden = true
            searchBarFriendsScreen.placeholder = "Search for clubs"
            joinedClubCollectionView.isHidden = true
         case 2:
            if myClubs.isEmpty {
                ButtonCreateClub.isHidden = false
                labelCreateyourOwnClub.isHidden = false
                collectionViewExplore.isHidden = true
                joinedClubCollectionView.isHidden = true
                yourClubLabel.isHidden = true
                tableViewFriends.isHidden = true
                print(myClubs.count)
            }
            else {
                ButtonCreateClub.isHidden = true
                labelCreateyourOwnClub.isHidden = true
                collectionViewExplore.isHidden = true
                tableViewFriends.isHidden = true
                joinedClubCollectionView.isHidden = false
                yourClubLabel.isHidden = false
                joinedClubCollectionView.reloadData()
            }
            
         default:
             break
         }
        
    }
    
    func settingElements() {
        searchBarFriendsScreen.placeholder = "Search for clubs"
        ButtonCreateClub.layer.cornerRadius = ButtonCreateClub.frame.height/2
        ButtonCreateClub.clipsToBounds = true
        
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
        collectionViewExplore.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 30, right: 30)
        
        
        joinedClubCollectionView.dataSource = self
        joinedClubCollectionView.delegate = self

        joinedClubCollectionView.register(
            UINib(nibName: "JoinedClubsCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "JoinedClubsCollectionViewCell"
        )
    }
    
    func settingAttributedText() {
        
        labelCreateyourOwnClub.textAlignment = .center

        let firstPart = "Create your own "
        let secondPart = "Club"

        let attributedText = NSMutableAttributedString(string: firstPart,
            attributes: [
                .font: UIFont.systemFont(ofSize: 30, weight: .ultraLight),
                .foregroundColor: UIColor.white
            ]
        )

        attributedText.append(NSAttributedString(string: secondPart,
            attributes: [
                .font: UIFont.systemFont(ofSize: 30, weight: .semibold),
                .foregroundColor: UIColor.white
            ]
        ))

        labelCreateyourOwnClub.attributedText = attributedText
        labelCreateyourOwnClub.sizeToFit()
    
    }

    @IBAction func createClubButtonPressed(_ sender: UIButton) {
        let destinationVC = CreateClubViewController()
                
        if self.systemOS >= "26.0" {
            destinationVC.modalPresentationStyle = .overFullScreen
        }
        
        self.present(destinationVC, animated: true, completion: nil)
    }
}

// MARK: - Collection View

extension ClubScreenViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewExplore {
                   return clubDataArray.count
               } else if collectionView == joinedClubCollectionView {
                   return myClubs.count
               }
               return 0
           }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewExplore {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ExploreScreenCollectionViewCell
            cell.configureCell(with: clubDataArray[indexPath.row])
            return cell
        }
        else {
            let cell =  joinedClubCollectionView.dequeueReusableCell(withReuseIdentifier: "JoinedClubsCollectionViewCell", for: indexPath) as! JoinedClubsCollectionViewCell
            cell.configureCell(with: myClubs[indexPath.row])
            return cell
        }

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = ClubProfileViewController()
        let navigationController = UINavigationController(rootViewController: destinationVC)
        
        destinationVC.buttonTitle = "Join Now"
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    
   

    
    
    
}

// MARK: - Table View

extension ClubScreenViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CustomCell",
            for: indexPath
        ) as! FriendListTableViewCell

        cell.configureCell(with: friendsDataArray[indexPath.row])

       
        cell.followAction = {
            self.friendsDataArray[indexPath.row].isFollowing.toggle()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell
    }
}
