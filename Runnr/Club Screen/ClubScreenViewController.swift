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
    @IBOutlet var buttonCreateClub: UIButton!
    @IBOutlet var labelCreateyourOwnClub: UILabel!
    @IBOutlet var tableViewFriends: UITableView!
    @IBOutlet var collectionViewJoinedClub: UICollectionView!
    @IBOutlet var labelYourClubs: UILabel!
    @IBOutlet var buttonAddMoreClubs: UIButton!
    @IBOutlet weak var labelTotalPoints: UILabel!
    @IBOutlet weak var buttonUserProfile: UIButton!
    
    let systemOS = UIDevice.current.systemVersion
    
    var dataSource = DataSource.shared
    var userProfile = DataSource.shared.getUserProfile()

    var totalPoints: Int {
        dataSource.getTotalRunnrPoints()
    }
    var clubsArray: [Club] {
        DataSource.shared.getclubsArray()
    }
    var myClubArray: [ClubRoleAndData] {
        DataSource.shared.getMyClubs()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingUpClubScreenElements()
        settingCollectionView()
        settingAttributedText()
        
        tableViewFriends.dataSource = self
        tableViewFriends.delegate = self
        tableViewFriends.register(UINib(nibName: "FriendListTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        self.buttonUserProfile.layer.cornerRadius = self.buttonUserProfile.frame.height / 2
        self.buttonUserProfile.setImage(dataSource.getProfileImage(), for: .normal)
        self.buttonUserProfile.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Task{
            let exploreClubs = await fetchExploreClubData(userID: self.userProfile.userID!)
            self.dataSource.setclubsArray(exploreClubs)
            let userClubs = await fetchMyClubsWithRoles(userID: userProfile.userID!)
            self.dataSource.setMyClubs(userClubs)
            
            
            if myClubArray.isEmpty == false {
                collectionViewJoinedClub.isHidden = false
                labelYourClubs.isHidden = false
                buttonAddMoreClubs.isHidden = false
            }
            
            collectionViewJoinedClub.reloadData()
            collectionViewExplore.reloadData()
            buttonAddMoreClubs.isHidden = true

        }
        
        tableViewFriends.reloadData()
        self.labelTotalPoints.text = "\(totalPoints)"
    }
    
    @IBAction func segmentShiftAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
         case 0:
            collectionViewExplore.isHidden = true
            buttonCreateClub.isHidden = true
            searchBarFriendsScreen.isHidden = false
            labelCreateyourOwnClub.isHidden = true
            tableViewFriends.isHidden = false
            searchBarFriendsScreen.placeholder = "Search for others"
            collectionViewJoinedClub.isHidden = true
            labelYourClubs.isHidden = true
            
            buttonAddMoreClubs.isHidden = true
         case 1:
            collectionViewExplore.isHidden = false
            buttonCreateClub.isHidden = true
            searchBarFriendsScreen.isHidden = false
            labelCreateyourOwnClub.isHidden = true
            tableViewFriends.isHidden = true
            searchBarFriendsScreen.placeholder = "Search for clubs"
            collectionViewJoinedClub.isHidden = true
           
            buttonAddMoreClubs.isHidden = true
         case 2:
            if myClubArray.isEmpty {
                buttonCreateClub.isHidden = false
                labelCreateyourOwnClub.isHidden = false
                collectionViewExplore.isHidden = true
                collectionViewJoinedClub.isHidden = true
                labelYourClubs.isHidden = true
                tableViewFriends.isHidden = true
                buttonAddMoreClubs.isHidden = true
            }
            else {
                buttonCreateClub.isHidden = true
                labelCreateyourOwnClub.isHidden = true
                collectionViewExplore.isHidden = true
                tableViewFriends.isHidden = true
                
                collectionViewJoinedClub.isHidden = false
                labelYourClubs.isHidden = false
                buttonAddMoreClubs.isHidden = false
                
                collectionViewJoinedClub.reloadData()
            }
            
         default:
             break
         }
        
    }
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        
        let destinationVC = UserProfileViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true, completion: nil)
        
    }
    
    func settingUpClubScreenElements() {
        
        buttonCreateClub.isHidden = true
        labelCreateyourOwnClub.isHidden = true
        tableViewFriends.isHidden = true
        buttonAddMoreClubs.isHidden = true
        
        searchBarFriendsScreen.placeholder = "Search for clubs"
        buttonCreateClub.layer.cornerRadius = buttonCreateClub.frame.height/2
        buttonCreateClub.clipsToBounds = true
        
        //segment edits
        segmentControlClubScreen.selectedSegmentIndex = 1
        segmentControlClubScreen.layer.borderWidth = 0.5
        segmentControlClubScreen.layer.borderColor = UIColor.accent.cgColor
        segmentControlClubScreen.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        
        //to remove the lines near the search Bar
        searchBarFriendsScreen.backgroundColor = .clear
        searchBarFriendsScreen.barTintColor = .clear
        searchBarFriendsScreen.isTranslucent = true
        
        buttonAddMoreClubs.layer.cornerRadius = buttonAddMoreClubs.frame.height / 2
        buttonAddMoreClubs.clipsToBounds = true
    }

    func settingCollectionView() {
        collectionViewExplore.dataSource = self
        collectionViewExplore.delegate = self
        
        collectionViewExplore.register(UINib(nibName: "ExploreScreenCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        
        view.overrideUserInterfaceStyle = .dark
        collectionViewExplore.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 30, right: 30)
        
        
        collectionViewJoinedClub.dataSource = self
        collectionViewJoinedClub.delegate = self

        collectionViewJoinedClub.register(
            UINib(nibName: "JoinedClubsCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "JoinedClubsCollectionViewCell"
        )
        collectionViewJoinedClub.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 30, right: 30)
        
        
    }
    
    func settingAttributedText() {
        
        labelCreateyourOwnClub.textAlignment = .center
        labelYourClubs.numberOfLines = 1
        
        let thinFont = UIFont(name: "SFProText-UltraThin",size: 33) ?? UIFont.systemFont(ofSize: 33, weight: .ultraLight)
        let boldFont = UIFont(name: "SFProText-Semibold",size: 33) ?? UIFont.systemFont(ofSize: 33, weight: .semibold)

        let attributedText = NSMutableAttributedString(string: "Create your own ", attributes: [
                .font: UIFont.systemFont(ofSize: 30, weight: .ultraLight),
                .foregroundColor: UIColor.white])

        attributedText.append(NSAttributedString(string: "Club", attributes: [
                .font: UIFont.systemFont(ofSize: 30, weight: .semibold),
                .foregroundColor: UIColor.white]))

        labelCreateyourOwnClub.attributedText = attributedText
        labelCreateyourOwnClub.sizeToFit()
        

        let attributedTextYourClub = NSMutableAttributedString(string: "Your", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        
        attributedTextYourClub.append(NSMutableAttributedString(string: " clubs", attributes: [.font: boldFont, .foregroundColor: UIColor.white]))
        
        labelYourClubs.attributedText = attributedTextYourClub
     
    }

    @IBAction func createClubButtonPressed(_ sender: UIButton) {
        let destinationVC = CreateClubViewController()
                
        if self.systemOS >= "26.0" {
            destinationVC.modalPresentationStyle = .overFullScreen
        }
        
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    
}

// MARK: - CollectionView Settings

extension ClubScreenViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewExplore {
                   return clubsArray.count
               } else if collectionView == collectionViewJoinedClub {
                   return myClubArray.count
               }
               return 0
           }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewExplore {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ExploreScreenCollectionViewCell
            cell.configureCell(with: clubsArray[indexPath.row])
            
            return cell
        }
        else {
            let cell =  collectionViewJoinedClub.dequeueReusableCell(withReuseIdentifier: "JoinedClubsCollectionViewCell", for: indexPath) as! JoinedClubsCollectionViewCell
            cell.configureCell(with: myClubArray[indexPath.row])
            
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionViewJoinedClub {
            let width = (collectionViewJoinedClub.frame.width - 80) / 2
            let size = CGSize(width: width, height: 211)
            
            return size
        }
        else {
            let width = (collectionViewExplore.frame.width - 80) / 2
            let size = CGSize(width: width, height: 246)
            
            return size
        }
        
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
        
        if collectionView == collectionViewExplore {
            destinationVC.clubProfileData = clubsArray[indexPath.row]
            destinationVC.isMyClub = false

        } else {
            destinationVC.myClubProfileData = myClubArray[indexPath.row]
            destinationVC.isMyClub = true
        }
       
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
        
}

// MARK: - TableView Settings

extension ClubScreenViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! FriendListTableViewCell

        cell.configureCell(with: friendsDataArray[indexPath.row])
        cell.followAction = {
            friendsDataArray[indexPath.row].isFollowing.toggle()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
