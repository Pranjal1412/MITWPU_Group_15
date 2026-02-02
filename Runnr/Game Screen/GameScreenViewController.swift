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

        // ✅ Header registration (NO new file)
        collectionViewChallenges.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "HeaderView"
        )
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
        let destinationVC = MountainClimbViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true)
    }
}

extension GameScreenViewController: UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return segmentedControlGame.selectedSegmentIndex == 0 ? 1 : 2
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {

        if segmentedControlGame.selectedSegmentIndex == 0 {
            return 10
        } else {
            return section == 0 ? 1 : 10
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if segmentedControlGame.selectedSegmentIndex == 0 {
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: "soloChallengeCell",
                for: indexPath
            )
        }

        if indexPath.section == 0 {
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: "seasonalGameCell",
                for: indexPath
            )
        }

        return collectionView.dequeueReusableCell(
            withReuseIdentifier: "weeklyClashCell",
            for: indexPath
        )
    }

    // Header without custom class
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "HeaderView",
            for: indexPath
        )

        let labelTag = 999
        let titleLabel: UILabel

        if let existing = header.viewWithTag(labelTag) as? UILabel {
            titleLabel = existing
        } else {
            let label = UILabel()
            label.tag = labelTag
            label.font = .systemFont(ofSize: 18, weight: .semibold)
            label.textColor = .label
            label.translatesAutoresizingMaskIntoConstraints = false

            header.addSubview(label)

            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
                label.topAnchor.constraint(equalTo: header.topAnchor, constant: 8),
                label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8)
            ])

            titleLabel = label
        }

        if segmentedControlGame.selectedSegmentIndex == 0 {
            titleLabel.text = "Active Challenges"
        } else if indexPath.section == 1 {
            titleLabel.text = "Active Games"
        } else {
            titleLabel.text = ""
        }

        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {

        if segmentedControlGame.selectedSegmentIndex == 0 {
            return CGSize(width: collectionView.frame.width, height: 40)
        }

        if segmentedControlGame.selectedSegmentIndex == 1 && section == 1 {
            return CGSize(width: collectionView.frame.width, height: 40)
        }

        return .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width

        if segmentedControlGame.selectedSegmentIndex == 0 {
            return CGSize(width: width, height: 151)   // Solo
        }

        if indexPath.section == 0 {
            return CGSize(width: width, height: 335)   // Seasonal
        }

        return CGSize(width: width, height: 262)       // Duel
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

