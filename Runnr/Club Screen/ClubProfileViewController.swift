
import UIKit

class ClubProfileViewController: UIViewController {
    
    @IBOutlet weak var collectionViewPostImages: UICollectionView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var clubDescription: UILabel!
    @IBOutlet var clubMotive: UILabel!
    @IBOutlet weak var clubProfileImage: UIImageView!
    @IBOutlet weak var joinNowButton: UIButton!
    @IBOutlet weak var labelSportType: UILabel!
    @IBOutlet weak var labelNumberOfMembers: UILabel!
    @IBOutlet weak var labelClubName: UILabel!
    @IBOutlet var tableViewLeaderBoard: UITableView!
    @IBOutlet var viewPosts: UIView!
    @IBOutlet var viewLeaderBoard: UIView!
    @IBOutlet var viewTagged: UIView!
    @IBOutlet var buttonBack: UIButton!
    @IBOutlet var NoPostLabel: UILabel!
    
    var buttonTitle : String?
    var isMyClub: Bool = false
    var myClubProfileData: MyClubData?
    var clubProfileData: ExploreClubData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingUpProfileScreenElements()
        settingCollectionAndTableView()
                
        collectionViewPostImages.isHidden = false
        tableViewLeaderBoard.isHidden = true
        
        if #available(iOS 26.0, *) {
            buttonBack.configuration = .glass()
            buttonBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            buttonBack.tintColor = .white
        } else {
            buttonBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            buttonBack.frame.origin.x = 100.0
            buttonBack.tintColor = .white
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if clubProfileData?.postImages.count == nil {
            collectionViewPostImages.isHidden = true
        }
        else {
            collectionViewPostImages.isHidden = false
            collectionViewPostImages.reloadData()
        }
    }
    
    func settingCollectionAndTableView() {
        collectionViewPostImages.delegate = self
        collectionViewPostImages.dataSource = self

        let nib = UINib(nibName: "ClubProfileCollectionViewCell", bundle: nil)
        collectionViewPostImages.register(nib, forCellWithReuseIdentifier: "cell")
        
        if let layout = collectionViewPostImages.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 4
            layout.minimumLineSpacing = 4
            layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        }
        
        tableViewLeaderBoard.dataSource = self
        tableViewLeaderBoard.delegate = self
        tableViewLeaderBoard.register(UINib(nibName: "ClubLeaderboardTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

    }
    
    func settingUpProfileScreenElements() {
        if isMyClub {
            labelClubName.text = myClubProfileData?.clubName
            labelSportType.text = myClubProfileData?.sport
            labelNumberOfMembers.text = myClubProfileData?.numberOfMembers ?? "No" + " Members"
            clubDescription.text = myClubProfileData?.clubDescription
            clubProfileImage.image = myClubProfileData?.clubProfileImg
            clubMotive.text = myClubProfileData?.clubMotive
        }
        else {
            labelClubName.text = clubProfileData?.clubName
            labelSportType.text = clubProfileData?.sport
            labelNumberOfMembers.text = clubProfileData?.numberOfMembers ?? "No" + " Members"
            clubDescription.text = clubProfileData?.clubDescription
            clubProfileImage.image = clubProfileData?.clubProfileImg
            clubMotive.text = clubProfileData?.clubMotive
        }
        
        clubProfileImage.layer.cornerRadius = 15
        clubProfileImage.clipsToBounds = true

        joinNowButton.setTitle(buttonTitle, for: .normal)
        joinNowButton.layer.cornerRadius = joinNowButton.frame.height / 2.0
        
        if joinNowButton.titleLabel?.text == "Edit Club Profile" {
            joinNowButton.setTitleColor(.accent, for: .normal)
            joinNowButton.backgroundColor = .black
            joinNowButton.layer.borderColor = UIColor.accent.cgColor
            joinNowButton.layer.borderWidth = 1
        }
        
        viewPosts.backgroundColor = .accent
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
        collectionViewPostImages.isHidden = false
        tableViewLeaderBoard.isHidden = true
        viewPosts.backgroundColor = .accent
        viewTagged.backgroundColor = .white
        viewLeaderBoard.backgroundColor = .white
    }

    func showLeaderBoard() {
        collectionViewPostImages.isHidden = true
        tableViewLeaderBoard.isHidden = false
        viewLeaderBoard.backgroundColor = .accent
        viewPosts.backgroundColor = .white
        viewTagged.backgroundColor = .white
    }

    func showTagged() {
        collectionViewPostImages.isHidden = false
        tableViewLeaderBoard.isHidden = true
        viewTagged.backgroundColor = .accent
        viewPosts.backgroundColor = .white
        viewLeaderBoard.backgroundColor = .white
    }
}


// MARK: - TableView Settings

extension ClubProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ClubLeaderboardTableViewCell
        
        cell.configureCell(with: leaderBoardArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = LeaderBoardViewController()
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: - CollectionView Settings

extension ClubProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource,
                                     UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clubProfileData?.postImages.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ClubProfileCollectionViewCell

        cell.configureCell(with: clubProfileData!.postImages[indexPath.row]!)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (collectionView.frame.width - 20) / 3
        return CGSize(width: width, height: width)
    }
}
