
import UIKit

class ClubProfileViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
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
    @IBOutlet var viewPosts: UIButton!
    @IBOutlet var viewLeaderBoard: UIButton!
    @IBOutlet var viewTagged: UIButton!
    @IBOutlet var buttonBack: UIButton!
    @IBOutlet weak var imageClubBanner: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var viewPostLine: UIView!
    @IBOutlet weak var viewLeaderboardLine: UIView!
    @IBOutlet weak var viewTaggedLine: UIView!
    
    var isMyClub: Bool = false
    var clubProfileData: Club?
    var myClubProfileData : ClubRoleAndData?
    
    private var userProfileData = DataSource.shared.getUserProfile()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingUpProfileScreenElements()
        settingCollectionAndTableView()
                
        collectionViewPostImages.isHidden = false
        tableViewLeaderBoard.isHidden = true
        
        setGlassEffect(for: self.buttonBack, withImage: "chevron.backward")
        buttonBack.layer.cornerRadius = 20
        
        scrollView.contentInsetAdjustmentBehavior = .never

        scrollView.contentSize.height = self.collectionViewPostImages.frame.height + self.collectionViewPostImages.frame.origin.y + 50
        scrollView.showsVerticalScrollIndicator = false
        
        clubProfileTopGradient(to: self.gradientView)
    }

    override func viewWillAppear(_ animated: Bool) {
//        if clubProfileData?.postImages.count == nil {
//            collectionViewPostImages.isHidden = true
//        }
//        else {
//            collectionViewPostImages.isHidden = false
//            collectionViewPostImages.reloadData()
//        }
    }
    
    func settingCollectionAndTableView() {
        //collectionViewPostImages.delegate = self
        //collectionViewPostImages.dataSource = self

//        let nib = UINib(nibName: "ClubProfileCollectionViewCell", bundle: nil)
//        collectionViewPostImages.register(nib, forCellWithReuseIdentifier: "cell")
//        
//        if let layout = collectionViewPostImages.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.minimumInteritemSpacing = 4
//            layout.minimumLineSpacing = 4
//            layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
//        }
        
        tableViewLeaderBoard.dataSource = self
        tableViewLeaderBoard.delegate = self
        tableViewLeaderBoard.register(UINib(nibName: "ClubLeaderboardTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

    }
    
    func settingUpProfileScreenElements() {
        if isMyClub {
            labelClubName.text = myClubProfileData?.club.clubName
            labelSportType.text = myClubProfileData?.club.clubSport.rawValue
            labelNumberOfMembers.text = String(myClubProfileData!.club.memberCount) + "Members"
            clubDescription.text = myClubProfileData?.club.clubDescription
            //clubProfileImage.image = myClubProfileData?.clubProfileImg
            clubMotive.text = myClubProfileData?.club.clubMotive
            
            if myClubProfileData?.role == .owner {
                joinNowButton.setTitle("Edit Club Profile", for: .normal)
            }
            else {
                joinNowButton.setTitle("Joined", for: .normal)
            }
            
            joinNowButton.setTitleColor(.accent, for: .normal)
            joinNowButton.backgroundColor = .black
            joinNowButton.layer.borderColor = UIColor.accent.cgColor
            joinNowButton.layer.borderWidth = 1

        }
        else {
            labelClubName.text = clubProfileData?.clubName
            labelSportType.text = clubProfileData?.clubSport.rawValue
            labelNumberOfMembers.text = String(clubProfileData!.memberCount) + " Members"
            clubDescription.text = clubProfileData?.clubDescription
            //clubProfileImage.image = clubProfileData?.clubProfileImg
            clubMotive.text = clubProfileData?.clubMotive
            
            joinNowButton.setTitle("Join Now", for: .normal)
            
            joinNowButton.setTitleColor(.black, for: .normal)
            joinNowButton.backgroundColor = .accent
        }
        
        clubProfileImage.layer.cornerRadius = 15
        clubProfileImage.clipsToBounds = true
        
        joinNowButton.layer.cornerRadius = joinNowButton.frame.height / 2.0
                
    }
    
    @IBAction func taggedButtonPressed(_ sender: UIButton) {
        showTagged()
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        viewPostLine.backgroundColor = .white
        viewTaggedLine.backgroundColor = .accent
        viewLeaderboardLine.backgroundColor = .white
    }
    
    @IBAction func leaderboardButtonPressed(_ sender: UIButton) {
        showLeaderBoard()
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        viewPostLine.backgroundColor = .white
        viewTaggedLine.backgroundColor = .white
        viewLeaderboardLine.backgroundColor = .accent

    }
    
    @IBAction func postsButtonPressed(_ sender: UIButton) {
        showPosts()
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        viewPostLine.backgroundColor = .accent
        viewTaggedLine.backgroundColor = .white
        viewLeaderboardLine.backgroundColor = .white

    }
    
    @IBAction func editClubProfilePressed(_ sender: UIButton) {
       
        Task {
            
            if joinNowButton.titleLabel?.text == "Edit Club Profile" {
                let destinationVC = ClubSettingsViewController()
                destinationVC.modalPresentationStyle = .fullScreen
                self.present(destinationVC, animated: true)
            }
            
            else if joinNowButton.titleLabel?.text == "Join Now" {
                await insertNewClubMember(newMember: ClubMemberRole(userID: self.userProfileData.userID, clubID: self.clubProfileData?.clubID, role: .member))
                joinNowButton.setTitle("Joined", for: .normal)
                joinNowButton.setTitleColor(.accent, for: .normal)
                joinNowButton.backgroundColor = .black
                joinNowButton.layer.borderColor = UIColor.accent.cgColor
                joinNowButton.layer.borderWidth = 1
            }
        }
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func showPosts() {
        collectionViewPostImages.isHidden = false
        tableViewLeaderBoard.isHidden = true
    }

    func showLeaderBoard() {
        collectionViewPostImages.isHidden = true
        tableViewLeaderBoard.isHidden = false
    }

    func showTagged() {
        collectionViewPostImages.isHidden = false
        tableViewLeaderBoard.isHidden = true
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

//extension ClubProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource,
//                                     UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return clubProfileData?.postImages.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ClubProfileCollectionViewCell
//
//        cell.configureCell(with: clubProfileData!.postImages[indexPath.row]!)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let width = (collectionView.frame.width - 20) / 3
//        return CGSize(width: width, height: width)
//    }
//}
