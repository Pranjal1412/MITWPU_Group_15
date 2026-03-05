import UIKit
import Kingfisher

class GameScreenViewController: UIViewController {

    @IBOutlet weak var segmentedControlGame: UISegmentedControl!
    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var labelTotalPoints: UILabel!
    @IBOutlet weak var buttonUserProfile: UIButton!
    @IBOutlet weak var collectionViewChallenges: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    
    private let sideInset: CGFloat = 9
    var dataSource = DataSource.shared
    var totalPoints: Int {
        dataSource.getTotalRunnrPoints()
    }
    
    private var userProfile = DataSource.shared.getUserProfile()
    private var expandedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentedControl()
        labelScreenTitle.sizeToFit()
        
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

        collectionViewChallenges.register(
            UINib(nibName: "DuelChallengeCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "weeklyClashCell"
        )

        self.collectionViewChallenges.register(
            UINib(nibName: "GameSectionHeaderView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "GameHeaderView"
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let profileImageURL = DataSource.shared.getUserProfile().userProfileImageURL

        if let url = URL(string: profileImageURL!) {
            self.profileImage.kf.setImage(with: url)
        }

        Task {
            let challenges = await getWeeklySoloChallenges(userProfile: userProfile)
            dataSource.setSoloChallenges(challenges ?? [])
            collectionViewChallenges.reloadData()
        }
        
        self.labelTotalPoints.text = "\(totalPoints)"
    }

    func setupSegmentedControl() {
        segmentedControlGame.layer.borderColor = UIColor.accent.cgColor
        segmentedControlGame.layer.borderWidth = 0.5
        segmentedControlGame.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        let destinationVC = UserProfileViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true)
    }
    
    @IBAction func segmentControlChange(_ sender: UISegmentedControl) {
        collapseExpandedCell()
        collectionViewChallenges.reloadData()
    }
    
    @objc private func handleBackgroundTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: collectionViewChallenges)
        if collectionViewChallenges.indexPathForItem(at: location) == nil {
            collapseExpandedCell()
        }
    }
    
    private func collapseExpandedCell() {
        guard let indexPath = expandedIndexPath else { return }
        
        if let cell = collectionViewChallenges.cellForItem(at: indexPath) as? DuelChallengeCollectionViewCell {
        }
        
        expandedIndexPath = nil
        
        UIView.animate(withDuration: 0.3) {
            self.collectionViewChallenges.performBatchUpdates(nil)
        }
    }
}

extension GameScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return segmentedControlGame.selectedSegmentIndex == 0 ? 1 : 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControlGame.selectedSegmentIndex == 0 {
            return 3
        } else {
            return section == 0 ? 1 : 3
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if segmentedControlGame.selectedSegmentIndex == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "soloChallengeCell", for: indexPath) as! SoloChallengeCollectionViewCell
            let soloChallenges = dataSource.getSoloChallenges()

            if soloChallenges.isEmpty == false {
                cell.configureCell(challenge: soloChallenges[indexPath.row])
            }

            return cell
        }

        if indexPath.section == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "seasonalGameCell", for: indexPath)
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weeklyClashCell", for: indexPath) as! DuelChallengeCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if segmentedControlGame.selectedSegmentIndex == 1 {
            if indexPath.section == 0 {
                let battleVC = BattleRunViewController()
                battleVC.modalPresentationStyle = .fullScreen
                self.present(battleVC, animated: true)
            }
            
            else if indexPath.section == 1 {
                if let cell = collectionView.cellForItem(at: indexPath) as? DuelChallengeCollectionViewCell {
                    if let previousIndexPath = expandedIndexPath, previousIndexPath != indexPath {
                        if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? DuelChallengeCollectionViewCell {
                            previousCell.setExpanded()
                        }
                    }
                    
                    let newExpandedState = !(indexPath == expandedIndexPath)
                    cell.setExpanded()
                    expandedIndexPath = newExpandedState ? indexPath : nil
                }
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            collectionView.performBatchUpdates(nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GameHeaderView", for: indexPath) as! GameSectionHeaderView
        
        if segmentedControlGame.selectedSegmentIndex == 0 {
            header.configureHeader(for: segmentedControlGame.selectedSegmentIndex)
        } else {
            header.configureHeader(for: segmentedControlGame.selectedSegmentIndex,tableSection: indexPath.section)
        }
        
        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width

        if segmentedControlGame.selectedSegmentIndex == 0 {
            return CGSize(width: width, height: 140)
        }

        if indexPath.section == 0 {
            return CGSize(width: width, height: 335)
        }

        if indexPath == expandedIndexPath {
            return CGSize(width: width, height: 240)
        } else {
            return CGSize(width: width, height: 130)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
