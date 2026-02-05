import UIKit

class GameScreenViewController: UIViewController {

    @IBOutlet weak var segmentedControlGame: UISegmentedControl!
    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var labelTotalPoints: UILabel!
    @IBOutlet weak var buttonUserProfile: UIButton!
    @IBOutlet weak var collectionViewChallenges: UICollectionView!
    @IBOutlet var buttonTemp: UIButton!
    
    private let sideInset: CGFloat = 9
    var dataSource = DataSource.shared
    var totalPoints: Int {
        dataSource.getTotalRunnrPoints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentedControl()
        labelScreenTitle.sizeToFit()
        
        self.buttonUserProfile.layer.cornerRadius = self.buttonUserProfile.frame.height / 2
        self.buttonUserProfile.clipsToBounds = true
        
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

        self.collectionViewChallenges.register(UINib(nibName: "GameSectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GameHeaderView")
    }

    override func viewWillAppear(_ animated: Bool) {
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
        collectionViewChallenges.reloadData()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
//        let destinationVC = MountainClimbViewController()
//        destinationVC.modalPresentationStyle = .fullScreen
//        self.present(destinationVC, animated: true)
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
            return collectionView.dequeueReusableCell(withReuseIdentifier: "soloChallengeCell", for: indexPath)
        }

        if indexPath.section == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "seasonalGameCell",for: indexPath)
        }

        return collectionView.dequeueReusableCell(withReuseIdentifier: "weeklyClashCell",for: indexPath)
    }

    // Header without custom class
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GameHeaderView", for: indexPath) as! GameSectionHeaderView
        
        if segmentedControlGame.selectedSegmentIndex == 0 {
            header.configureHeader(for: segmentedControlGame.selectedSegmentIndex)
        } else {
            header.configureHeader(for: segmentedControlGame.selectedSegmentIndex, tableSection: indexPath.section)
        }
        
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        if segmentedControlGame.selectedSegmentIndex == 0 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }

        if segmentedControlGame.selectedSegmentIndex == 1 && section == 1 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }

        return .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width - 10

        if segmentedControlGame.selectedSegmentIndex == 0 {
            return CGSize(width: width, height: 140)   // Solo
        }

        if indexPath.section == 0 {
            return CGSize(width: width, height: 335)   // Seasonal
        }

        return CGSize(width: width, height: 262)       // Duel
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

