//
//  UserProfileViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 26/12/25.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var imageCategoryBadge: UIImageView!
    @IBOutlet weak var buttonEditProfile: UIButton!
    
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
    @IBOutlet weak var labelFollower: UILabel!
    @IBOutlet weak var labelFollowerCount: UILabel!
    @IBOutlet weak var labelFollowing: UILabel!
    @IBOutlet weak var labelFollowingCount: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var stackProgress: UIStackView!
    @IBOutlet weak var collectionViewBestActivity: UICollectionView!
    
    var totalRunnrPoints : Int {
        DataSource.shared.getTotalRunnrPoints()
    }
    
    var totalActivities : Int {
        DataSource.shared.getTotalActivities()
    }
    
    var totalDistance : Int {
        Int(DataSource.shared.getTotalKms())
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionViewBestActivity.dataSource = self
        
        self.collectionViewBestActivity.register(UINib(nibName: "SectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderView")
        
        self.collectionViewBestActivity.register(UINib(nibName: "BestActivitiesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BestActivitiesCollectionViewCell")
        self.collectionViewBestActivity.register(UINib(nibName: "BadgeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BadgeCollectionViewCell")
        
        self.collectionViewBestActivity.setCollectionViewLayout(generateLayout(), animated: true)
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.collectionViewBestActivity.frame.height + self.collectionViewBestActivity.frame.origin.y + 30)
        settingsElements()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.loadAllData()
    }

    @IBAction func editProfilePressed(_ sender: UIButton) {
        let destinationVC = EditProfileViewController()
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
    
    
    func settingsElements() {
        
        self.labelScreenTitle.text = String(localized: "Profile")
        self.labelFollower.text = String(localized: "Followers")
        self.labelFollowing.text = String(localized: "Following")
        self.buttonEditProfile.setTitle(String(localized: "Edit Profile"), for: .normal)
        
        self.labelTotalPoints.text = String(localized: "Total Points")
        self.labelTotalDistance.text = String(localized: "Total Distance")
        self.labelTotalActivities.text = String(localized: "Total Activities")
        
        imageProfile.layer.cornerRadius = imageProfile.frame.size.width / 2
        buttonEditProfile.layer.cornerRadius = 10.0
    }
    
    func loadAllData() {
        self.labelTotalPointsCount.text = "\(self.totalRunnrPoints)"
        self.labelTotalActivitiesCount.text = "\(self.totalActivities)"
        self.labelTotalDistanceCount.text = "\(self.totalDistance)"
        
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
            
            self.progressView.progress = Float((self.totalDistance/runnrCategories[self.labelCategory.tag].goal) * 100)
            
            let thinFont = UIFont(name: "SFProText-Light", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .light)
            let boldFont = UIFont(name: "SFProText-Bold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .medium)
            
            let text = NSMutableAttributedString(string: "\(runnrCategories[self.labelCategory.tag].goal - self.totalDistance) km to ", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestActivitiesCollectionViewCell", for: indexPath) as! BestActivitiesCollectionViewCell
            
            cell.configureCell()
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCollectionViewCell", for: indexPath) as! BadgeCollectionViewCell
            
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
        
        if indexPath.section == 0 {
            sectionHeader.imageSection.image = UIImage(systemName: "trophy.fill")
            sectionHeader.labelSectionHeading.text = "Best Activities"
        }
        else if indexPath.section == 1 {
            sectionHeader.imageSection.image = UIImage(systemName: "medal.fill")
            sectionHeader.labelSectionHeading.text = "Badges Earned"
        }
        
        return sectionHeader
    }
    
    
    func generateLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { section, env in
        
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25))
            
            // parameter elementKind should match with forSupplementaryViewOfKind in register
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            if section == 0 {
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
                
            }
            
            else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10)
                section.boundarySupplementaryItems = [headerItem]
                
                return section
                
            }

        }
    
        return layout
    }
    
}
