import UIKit

class ClubProfileViewController: UIViewController,
                                 UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var clubDescription: UILabel!
    @IBOutlet weak var clubProfileImage: UIImageView!
    @IBOutlet weak var joinNowButton: UIButton!

    @IBOutlet var tableViewLeaderBoard: UITableView!
    @IBOutlet var viewPosts: UIView!
    @IBOutlet var viewLeaderBoard: UIView!
    @IBOutlet var viewTagged: UIView!
    
    var buttonTitle : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()

        view.overrideUserInterfaceStyle = .dark

        clubDescription.numberOfLines = 2
        clubDescription.lineBreakMode = .byWordWrapping

        clubProfileImage.layer.cornerRadius = 12
        clubProfileImage.clipsToBounds = true

        joinNowButton.setTitle(buttonTitle, for: .normal)
        joinNowButton.layer.cornerRadius = joinNowButton.frame.height / 2.0
        
        tableViewLeaderBoard.dataSource = self
        tableViewLeaderBoard.delegate = self
        tableViewLeaderBoard.register(UINib(nibName: "ClubProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        collectionView.isHidden = false
        tableViewLeaderBoard.isHidden = true
        viewPosts.backgroundColor = .accent

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 4
            layout.minimumLineSpacing = 4
            layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        }

    }

   
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        let nib = UINib(
            nibName: "ClubProfileCollectionViewCell",
            bundle: nil
        )
        collectionView.register(nib,forCellWithReuseIdentifier: "cell")
    }
    
    @IBAction func taggedButtonPressed(_ sender: UIButton) {
        showTagged()
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
    }
    
    @IBAction func leaderboardButtonPressed(_ sender: UIButton) {
        showLeaderBoard()
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
    }
    
    @IBAction func postsButtonPressed(_ sender: UIButton) {
        showPosts()
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    func showPosts() {
        collectionView.isHidden = false
        tableViewLeaderBoard.isHidden = true
        viewPosts.backgroundColor = .accent
        viewTagged.backgroundColor = .white
        viewLeaderBoard.backgroundColor = .white
    }

    func showLeaderBoard() {
        collectionView.isHidden = true
        tableViewLeaderBoard.isHidden = false
        viewLeaderBoard.backgroundColor = .accent
        viewPosts.backgroundColor = .white
        viewTagged.backgroundColor = .white
    }

    func showTagged() {
        collectionView.isHidden = false
        tableViewLeaderBoard.isHidden = true
        viewTagged.backgroundColor = .accent
        viewPosts.backgroundColor = .white
        viewLeaderBoard.backgroundColor = .white
    }
}


// MARK: - Table View

extension ClubProfileViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ClubProfileTableViewCell
        
        cell.configureCell(with: leaderBoardArray[indexPath.row])
//        cell.configureCell(with: friendsDataArray[indexPath.row])
        return cell
    }
}

// MARK: - Collection View

extension ClubProfileViewController {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as! ClubProfileCollectionViewCell

        cell.configureCell(with: postImagesArray[indexPath.row])
       

        return cell
    }


    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (collectionView.frame.width - 20) / 3
        return CGSize(width: width, height: width)
    }
}
