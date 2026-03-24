//
//  UserProfileViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 26/12/25.
//

import UIKit
import Kingfisher

class UserProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var imageCategoryBadge: UIImageView!
    @IBOutlet weak var buttonEditProfile: UIButton!
    @IBOutlet weak var buttonSettings: UIButton!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelBiography: UILabel!
    @IBOutlet weak var labelSpacing: UILabel!
    
    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var labelTotalPoints: UILabel!
    @IBOutlet weak var labelTotalPointsCount: UILabel!
    @IBOutlet weak var labelTotalActivities: UILabel!
    @IBOutlet weak var labelTotalActivitiesCount: UILabel!
    @IBOutlet weak var labelTotalDistance: UILabel!
    @IBOutlet weak var labelTotalDistanceCount: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelCategoryGoal: UILabel!
    @IBOutlet weak var labelCategoryGoalLeft: UILabel!
    @IBOutlet weak var buttonNotification: UIButton!
    
    @IBOutlet var labelFollowingCount: UIButton!
    @IBOutlet var labelFollowing: UIButton!
    @IBOutlet var labelFollowerCount: UIButton!
    @IBOutlet var labelFollower: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var stackProgress: UIStackView!
//    @IBOutlet weak var collectionViewBestActivity: UICollectionView!

    private var userProfile = DataSource.shared.getUserProfile()
    private let userStats = DataSource.shared.getUserStats()
    private var dataSource = DataSource.shared
    
    var isFromFriendsScreen: Bool = false
    var friendData: UserProfile?
        
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.collectionViewBestActivity.dataSource = self
//        
//        self.collectionViewBestActivity.register(UINib(nibName: "SectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderView")
//        
//        self.collectionViewBestActivity.register(UINib(nibName: "BestActivitiesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BestActivitiesCollectionViewCell")
//        self.collectionViewBestActivity.register(UINib(nibName: "BadgeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BadgeCollectionViewCell")
//        
//        self.collectionViewBestActivity.setCollectionViewLayout(generateLayout(), animated: true)
//        
//        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.collectionViewBestActivity.frame.height + self.collectionViewBestActivity.frame.origin.y + 30)
        settingsElements()
        self.buttonNotification.isHidden = isFromFriendsScreen
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.loadAllData()
    }

    @IBAction func editProfilePressed(_ sender: UIButton) {
        if isFromFriendsScreen {
            UIView.performWithoutAnimation {
                if self.buttonEditProfile.title(for: .normal) == "Follow" {
                    self.buttonEditProfile.setTitle("Following", for: .normal)
                    self.buttonEditProfile.backgroundColor = .lightGray
                    self.buttonEditProfile.setTitleColor(.label, for: .normal)
                } else {
                    self.buttonEditProfile.setTitle("Follow", for: .normal)
                    self.buttonEditProfile.backgroundColor = .accent
                    self.buttonEditProfile.setTitleColor(.black, for: .normal)
                }
                self.buttonEditProfile.layoutIfNeeded()
            }
            return
        }
        let destinationVC = EditProfileViewController()
        destinationVC.delegate = self
        self.present(destinationVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func navigateToSettings(_ sender: UIButton) {
        
        if let presenter = self.presentingViewController {
            self.dismiss(animated: true) {
                let rootVC = SettingsViewController()
                let navigationController = UINavigationController(rootViewController: rootVC)
                navigationController.modalPresentationStyle = .fullScreen
                presenter.present(navigationController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func navigateToNotification(_ sender: UIButton) {
        let notificationVC = NotificationViewController(nibName: "NotificationViewController", bundle: nil)
        if let presenter = self.presentingViewController {
            self.dismiss(animated: true) {
                notificationVC.modalPresentationStyle = .fullScreen
                presenter.present(notificationVC, animated: true, completion: nil)
            }
        } else {
            notificationVC.modalPresentationStyle = .fullScreen
            self.present(notificationVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func followersTapped(_ sender: UIButton) {
        let currentUserId = friendData?.userID ?? userProfile.userID!
        
        Task {
            let followersList = await fetchFollowersList(userID: currentUserId)
            self.dataSource.setFollowedUser(followersList)
            
            let friendListVC = FriendListViewController()
            friendListVC.usersList = followersList
            friendListVC.pageTitle = "Followers"
            friendListVC.showFollowButton = true
            
            self.present(friendListVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func followingTapped(_ sender: UIButton) {
        let currentUserId = friendData?.userID ?? userProfile.userID!
        
        Task {
            let followingList = await fetchFollowingList(userID: currentUserId)
            self.dataSource.setFollowingUser(followingList)
            
            let friendListVC = FriendListViewController()
            friendListVC.usersList = followingList
            friendListVC.pageTitle = "Following"
            friendListVC.showFollowButton = false
//            friendListVC.modalPresentationStyle = .overFullScreen
            self.present(friendListVC, animated: true, completion: nil)
        }
    }
    
    func settingsElements() {
        
        if userProfile.userBio != nil || userProfile.userBio != "" {
            self.labelBiography.text = userProfile.userBio
            self.labelSpacing.text = "Spacing"
        }
        
        self.labelScreenTitle.text = String(localized: "Profile")
        
        self.labelFollower.setTitle(String(localized: "Followers"), for: .normal)
        self.labelFollowing.setTitle(String(localized: "Following"), for: .normal)
        
        if isFromFriendsScreen {
            self.buttonSettings.isHidden = true
            self.buttonEditProfile.setTitle(String(localized: "Follow"), for: .normal)
            self.buttonEditProfile.backgroundColor = .accent
            self.buttonEditProfile.setTitleColor(.black, for: .normal)

        } else {
            self.buttonSettings.isHidden = false
            self.buttonEditProfile.setTitle(String(localized: "Edit Profile"), for: .normal)
            self.buttonEditProfile.setTitleColor(.label, for: .normal)
        }
        
        self.labelTotalPoints.text = String(localized: "Total Points")
        self.labelTotalDistance.text = String(localized: "Total Distance")
        self.labelTotalActivities.text = String(localized: "Total Activities")
        
        imageProfile.layer.cornerRadius = imageProfile.frame.size.width / 2

        buttonEditProfile.layer.cornerRadius = 10.0
    }
    
    func loadAllData() {
        if let friend = friendData {
            self.labelUsername.text = friend.userName
            if let url = URL(string: friend.userProfileImageURL!) {
                self.imageProfile.kf.setImage(with: url)
            }

        } else {
            self.labelUsername.text = userProfile.userName
            if let url = URL(string: self.userProfile.userProfileImageURL!) {
                self.imageProfile.kf.setImage(with: url)
            }
        }
        
        self.labelFollowingCount.setTitle(String(userStats!.numberOfFollowing), for: .normal)
        self.labelFollowerCount.setTitle(String(userStats!.numberOfFollowers), for: .normal)
        self.labelTotalPointsCount.text = String(self.userStats?.totalPointsEarned ?? 0)
        self.labelTotalActivitiesCount.text = String(self.userStats?.totalActivities ?? 0)
        self.labelTotalDistanceCount.text = String(format: "%.1f", (self.userStats?.totalDistanceCovered ?? 0.0))
        
        let totalDistance = Int(self.userStats?.totalDistanceCovered ?? 0.0)
        
        if totalDistance <= 600 {
            if totalDistance == 0 && totalDistance < 50 {
                self.imageCategoryBadge.image = UIImage(named: runnrCategories[0].badge)
                self.labelCategory.text = runnrCategories[0].name.rawValue
                self.labelCategoryGoal.text = "\(runnrCategories[0].goal) Km"
                self.labelCategory.tag = 0
            }
            else if totalDistance >= 50 && totalDistance < 250 {
                self.imageCategoryBadge.image = UIImage(named: runnrCategories[1].badge)
                self.labelCategory.text = runnrCategories[1].name.rawValue
                self.labelCategory.tag = 1
                self.labelCategoryGoal.text = "\(runnrCategories[1].goal) Km"
            }
            else if totalDistance >= 250 && totalDistance < 600 {
                self.imageCategoryBadge.image = UIImage(named: runnrCategories[2].badge)
                self.labelCategory.text = runnrCategories[2].name.rawValue
                self.labelCategoryGoal.text = "\(runnrCategories[2].goal) Km"
                self.labelCategory.tag = 2
            }
            
            self.progressView.progress = Float(totalDistance) / Float(runnrCategories[self.labelCategory.tag].goal)
            
            let thinFont = UIFont(name: "SFProText-Light", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .light)
            let boldFont = UIFont(name: "SFProText-Bold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .medium)
            
            let text = NSMutableAttributedString(string: "\(runnrCategories[self.labelCategory.tag].goal - totalDistance) km to ", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
            text.append(NSAttributedString(string: "\(runnrCategories[self.labelCategory.tag+1].name)", attributes: [.font: boldFont, .foregroundColor: UIColor.white]))
            self.labelCategoryGoalLeft.attributedText = text

        }
        
        else {
            self.imageCategoryBadge.image = UIImage(named: runnrCategories[3].badge)
            self.labelCategory.text = runnrCategories[3].name.rawValue
            
            self.progressView.progress = 1
            self.labelCategoryGoalLeft.text = String(localized: "Goal Completed!")
            self.labelCategoryGoalLeft.sizeToFit()
            self.labelCategoryGoal.text = String(localized: "More to Come!!")
            self.labelCategoryGoal.sizeToFit()
        }
        
    }

}

//MARK: - Collection View Settings

extension UserProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return 2
//        }
//        else {
            return 2
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestActivitiesCollectionViewCell", for: indexPath) as! BestActivitiesCollectionViewCell
            
            cell.configureCell()
            return cell
//        }
//        else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCollectionViewCell", for: indexPath) as! BadgeCollectionViewCell
//            
//            return cell
//        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
        
//        if indexPath.section == 0 {
            sectionHeader.imageSection.image = UIImage(systemName: "trophy.fill")
            sectionHeader.labelSectionHeading.text = "Best Activities"
//        }
//        else if indexPath.section == 1 {
//            sectionHeader.imageSection.image = UIImage(systemName: "medal.fill")
//            sectionHeader.labelSectionHeading.text = "Badges Earned"
//        }
        
        return sectionHeader
    }
    
    
    func generateLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { section, env in
        
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25))
            
            // parameter elementKind should match with forSupplementaryViewOfKind in register
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
//            if section == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(self.view.frame.width - 60), heightDimension: .estimated(140))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
                                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10)
                section.boundarySupplementaryItems = [headerItem]
                
                return section
                
//            }
//            
//            else {
//                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                
//                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
//                
//                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(100))
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
//                
//                let section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .continuous
//                
//                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10)
//                section.boundarySupplementaryItems = [headerItem]
//                
//                return section
//                
//            }

        }
    
        return layout
    }
    
}


extension UserProfileViewController: EditProfileDelegate {
    
    func didUpdateProfile() {
        
        self.userProfile = DataSource.shared.getUserProfile()
        self.labelUsername.text = userProfile.userName
        self.labelBiography.text = userProfile.userBio
        
        if let url = URL(string: self.userProfile.userProfileImageURL!) {
            self.imageProfile.kf.setImage(with: url)
        }
        
    }
    
}
