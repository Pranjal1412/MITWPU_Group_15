import UIKit

class GameScreenViewController: UIViewController {

    @IBOutlet weak var segmentedControlGame: UISegmentedControl!
    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var labelTotalPoints: UILabel!
    @IBOutlet weak var buttonUserProfile: UIButton!
    @IBOutlet var buttonTemp: UIButton!
    
    private let sideInset: CGFloat = 15
    private let cellHeight: CGFloat = 166
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
    }

    override func viewWillAppear(_ animated: Bool) {
        self.labelTotalPoints.text = "\(totalPoints)"
    }

    func setupSegmentedControl() {
        segmentedControlGame.layer.borderColor = UIColor.accent.cgColor
        segmentedControlGame.layer.borderWidth = 0.5
        segmentedControlGame.setTitleTextAttributes([.foregroundColor: UIColor.black],for: .selected)
    }
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        
        let destinationVC = UserProfileViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true, completion: nil)
        
    }
    
    @IBAction func segmentControlChange(_ sender: UISegmentedControl) {

    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let destinationVC = MountainClimbViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true, completion: nil)
    }
    @IBAction func buttonToGame(_ sender: UIButton) {
//        let destinationVC = GameSetOneViewController()
//        self.present(destinationVC, animated: true, completion: nil)
    }
}

//MARK: - Collection View Settings

//extension GameScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource,
//                                    UICollectionViewDelegateFlowLayout {
//
//}

