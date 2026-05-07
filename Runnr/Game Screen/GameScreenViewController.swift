import UIKit
import Kingfisher

class GameScreenViewController: UIViewController {
    
    //@IBOutlet weak var segmentedControlGame: UISegmentedControl!
    @IBOutlet weak var viewCurrency: UIView!
    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var labelTotalPoints: UILabel!
    @IBOutlet weak var buttonUserProfile: UIButton!
    @IBOutlet weak var buttonInfo: UIButton!
    @IBOutlet weak var collectionViewChallenges: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    
    private let sideInset: CGFloat = 9
    var dataSource = DataSource.shared
    var totalPoints: Int {
        dataSource.getTotalRunnrPoints()
    }
    
    private var userProfile = DataSource.shared.getUserProfile()
    //private var expandedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setupSegmentedControl()
        labelScreenTitle.sizeToFit()
        
        self.viewCurrency.layer.cornerRadius = self.viewCurrency.frame.height / 2
        self.buttonUserProfile.layer.cornerRadius = self.buttonUserProfile.frame.height / 2
        self.buttonUserProfile.clipsToBounds = true
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
        self.profileImage.clipsToBounds = true
        
        collectionViewChallenges.delegate = self
        collectionViewChallenges.dataSource = self
        
        collectionViewChallenges.register(
            UINib(nibName: "SoloChallengeCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "soloChallengeCell"
        )
        
        collectionViewChallenges.register(
            UINib(nibName: "SeasonalGameCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "seasonalGameCell"
        )
        
        //        collectionViewChallenges.register(
        //            UINib(nibName: "DuelChallengeCollectionViewCell", bundle: nil),
        //            forCellWithReuseIdentifier: "weeklyClashCell"
        //        )
        
        self.collectionViewChallenges.register(
            UINib(nibName: "GameSectionHeaderView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "GameHeaderView"
        )
        
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:)))
        //        tapGesture.cancelsTouchesInView = false
        //        view.addGestureRecognizer(tapGesture)
        //
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let profileImageURL = DataSource.shared.getUserProfile().userProfileImageURL
        
        if let urlString = profileImageURL, let url = URL(string: urlString) {
            self.profileImage.kf.setImage(with: url)
        }
        
        Task {
            let challenges = await getWeeklySoloChallenges(userProfile: userProfile)
            dataSource.setSoloChallenges(challenges ?? [])
            collectionViewChallenges.reloadData()
        }
        
        self.labelTotalPoints.text = "\(totalPoints)"
    }
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        let destinationVC = UserProfileViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true)
    }
    
}

extension GameScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Section 0: Seasonal, Section 1: Solo
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // The Seasonal Challenge
        } else {
            return dataSource.getSoloChallenges().count // Dynamic list of Solo Challenges
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seasonalGameCell", for: indexPath) as! SeasonalGameCollectionViewCell
            cell.refreshData()
            
            cell.onInviteFriendTapped = { [weak self] in
                guard let self = self else { return }
                let inviteVC = InviteFriendViewController()
                
                inviteVC.modalPresentationStyle = .pageSheet
                if let sheet = inviteVC.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                    sheet.prefersGrabberVisible = true
                }
                
                inviteVC.onInviteSent = { _ in
                    cell.buttonInviteFriend.isEnabled = false
                    cell.buttonInviteFriend.backgroundColor = .systemGray2
                }
                
                self.present(inviteVC, animated: true)
            }
            
            cell.onGameEnded = { [weak self] isWinner in
                guard let self = self, isWinner else { return }
                
                let winnerVC = WinnerViewController()
                winnerVC.modalPresentationStyle = .overFullScreen
                winnerVC.modalTransitionStyle = .crossDissolve
                self.present(winnerVC, animated: true)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "soloChallengeCell", for: indexPath) as! SoloChallengeCollectionViewCell
            let soloChallenges = dataSource.getSoloChallenges()
            
            if !soloChallenges.isEmpty {
                cell.configureCell(challenge: soloChallenges[indexPath.row])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? SeasonalGameCollectionViewCell else { return }

            if !cell.buttonInviteFriend.isEnabled {
                Task {
                    guard let userID = DataSource.shared.getUserProfile().userID else { return }
                    if let game = await fetchActiveGameForUser(userID: userID), game.playerTwoID != nil {
                        await MainActor.run {
                            let destinationVC = BattleRunViewController()
                            destinationVC.modalPresentationStyle = .fullScreen
                            self.present(destinationVC, animated: true)
                        }
                    }
                }
            }
        }
        
        // Battle Run is only accessible after the invited player accepts — no tap-to-open here
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GameHeaderView", for: indexPath) as! GameSectionHeaderView
        
        // Assuming 0 = Seasonal/Battle and 1 = Solo for your header titles
        header.configureHeader(for: 1, tableSection: indexPath.section)
        header.buttonTapHandler = {
            let destinationVC = GameDescriptionViewController(nibName: "GameDescriptionViewController", bundle: nil)
//            destinationVC.modalPresentationStyle = .overFullScreen
//            destinationVC.modalTransitionStyle = .crossDissolve
            self.present(destinationVC, animated: true)
        }
        
        return header
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        else {
            return CGSize(width: collectionView.frame.width, height: 70)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        
        if indexPath.section == 0 {
            return CGSize(width: width, height: 335) // Height for Seasonal
        } else {
            return CGSize(width: width, height: 140) // Height for Solo
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}






//    func setupSegmentedControl() {
//        segmentedControlGame.layer.borderColor = UIColor.accent.cgColor
//        segmentedControlGame.layer.borderWidth = 0.5
//        segmentedControlGame.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
//    }

//    @IBAction func profileButtonPressed(_ sender: UIButton) {
//        let destinationVC = UserProfileViewController()
//        destinationVC.modalPresentationStyle = .fullScreen
//        self.present(destinationVC, animated: true)
//    }
//
//    @IBAction func segmentControlChange(_ sender: UISegmentedControl) {
//        collapseExpandedCell()
//        collectionViewChallenges.reloadData()
//    }
//
//    @objc private func handleBackgroundTap(_ gesture: UITapGestureRecognizer) {
//        let location = gesture.location(in: collectionViewChallenges)
//        if collectionViewChallenges.indexPathForItem(at: location) == nil {
//            collapseExpandedCell()
//        }
//    }
//
//    private func collapseExpandedCell() {
//        guard let indexPath = expandedIndexPath else { return }
//
//        if let cell = collectionViewChallenges.cellForItem(at: indexPath) as? DuelChallengeCollectionViewCell {
//        }
//
//        expandedIndexPath = nil
//
//        UIView.animate(withDuration: 0.3) {
//            self.collectionViewChallenges.performBatchUpdates(nil)
//        }
//    }
//}
//
//extension GameScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return segmentedControlGame.selectedSegmentIndex == 0 ? 1 : 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if segmentedControlGame.selectedSegmentIndex == 0 {
//            return 3
//        } else {
//            return section == 0 ? 1 : 3
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        if segmentedControlGame.selectedSegmentIndex == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "soloChallengeCell", for: indexPath) as! SoloChallengeCollectionViewCell
//            let soloChallenges = dataSource.getSoloChallenges()
//
//            if soloChallenges.isEmpty == false {
//                cell.configureCell(challenge: soloChallenges[indexPath.row])
//            }
//
//            return cell
//        }
//
//        if indexPath.section == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seasonalGameCell", for: indexPath) as! SeasonalGameCollectionViewCell
//            cell.refreshData()
//            return cell
//        }
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weeklyClashCell", for: indexPath) as! DuelChallengeCollectionViewCell
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if segmentedControlGame.selectedSegmentIndex == 1 {
//            if indexPath.section == 0 {
//                let battleVC = BattleRunViewController()
//                battleVC.modalPresentationStyle = .fullScreen
//                self.present(battleVC, animated: true)
//            }
//
//            else if indexPath.section == 1 {
//                if let cell = collectionView.cellForItem(at: indexPath) as? DuelChallengeCollectionViewCell {
//                    if let previousIndexPath = expandedIndexPath, previousIndexPath != indexPath {
//                        if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? DuelChallengeCollectionViewCell {
//                            previousCell.setExpanded()
//                        }
//                    }
//
//                    let newExpandedState = !(indexPath == expandedIndexPath)
//                    cell.setExpanded()
//                    expandedIndexPath = newExpandedState ? indexPath : nil
//                }
//            }
//        }
//
//        UIView.animate(withDuration: 0.3) {
//            collectionView.performBatchUpdates(nil)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GameHeaderView", for: indexPath) as! GameSectionHeaderView
//
//        if segmentedControlGame.selectedSegmentIndex == 0 {
//            header.configureHeader(for: segmentedControlGame.selectedSegmentIndex)
//        } else {
//            header.configureHeader(for: segmentedControlGame.selectedSegmentIndex,tableSection: indexPath.section)
//        }
//
//        return header
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 50)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let width = collectionView.frame.width
//
//        if segmentedControlGame.selectedSegmentIndex == 0 {
//            return CGSize(width: width, height: 140)
//        }
//
//        if indexPath.section == 0 {
//            return CGSize(width: width, height: 335)
//        }
//
//        if indexPath == expandedIndexPath {
//            return CGSize(width: width, height: 240)
//        } else {
//            return CGSize(width: width, height: 130)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 15
//    }
//}

