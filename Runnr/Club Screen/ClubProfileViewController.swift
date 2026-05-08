
import UIKit
import Kingfisher

class ClubProfileViewController: UIViewController, UpdateClubProfile {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionViewClubEvents: UICollectionView!
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
    //@IBOutlet var viewTagged: UIButton!
    @IBOutlet var buttonBack: UIButton!
    @IBOutlet weak var imageClubBanner: UIImageView!
    @IBOutlet weak var viewPostLine: UIView!
    @IBOutlet weak var viewLeaderboardLine: UIView!
    //@IBOutlet weak var viewTaggedLine: UIView!
    @IBOutlet var leaveClubButton: UIButton!
    @IBOutlet var createNewEventButton: UIButton!
    @IBOutlet weak var viewBackgroundOwner: UIView!
    @IBOutlet weak var imageOwnerProfile: UIImageView!
    @IBOutlet weak var labelClubOwnerName: UILabel!
    
    var isMyClub: Bool = false
    var clubProfileData: Club?
    var myClubProfileData : ClubRoleAndData?
    
    private var clubOwnerDetails: UserProfile?
    private var clubEvents: [ClubEvents] = []
    private var userProfileData = DataSource.shared.getUserProfile()
    
    //    var likedPosts: [Bool] = [false, false, false]
    //    private var allPosts: [ClubPostDetail] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        settingUpProfileScreenElements()
        settingCollectionAndTableView()
                
        collectionViewClubEvents.isHidden = false
        tableViewLeaderBoard.isHidden = true
        
        setGlassEffect(for: self.buttonBack, withImage: "chevron.backward")
        buttonBack.layer.cornerRadius = 20
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        
        showPosts()
        
        self.leaveClubButton.layer.cornerRadius = self.leaveClubButton.frame.height / 2
        
        // Setup Create New Post Button
        createNewEventButton.layer.cornerRadius = createNewEventButton.frame.height / 2
        createNewEventButton.addTarget(self, action: #selector(presentCreateEvent), for: .touchUpInside)
        
        viewPosts.addTarget(self, action: #selector(postsButtonPressed(_:)), for: .touchUpInside)
        viewLeaderBoard.addTarget(self, action: #selector(leaderboardButtonPressed(_:)), for: .touchUpInside)
        
        viewPostLine.backgroundColor = .accent
        viewLeaderboardLine.backgroundColor = .white
        
        if isMyClub && myClubProfileData?.role == .owner {
            self.createNewEventButton.isHidden = false
        }
        else {
            self.createNewEventButton.isHidden = true

        }
    }

    @objc func presentCreateEvent() {
        let vc = CreateRunEventViewController()
        vc.clubDetails = myClubProfileData?.club
//        vc.modalPresentationStyle = .pageSheet
//        if let sheet = vc.sheetPresentationController {
//            sheet.detents = [.large()]
//            sheet.prefersGrabberVisible = true
//        }
        self.present(vc, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        Task {
            if isMyClub {
//                allPosts = await fetchAllClubPosts(for: self.myClubProfileData!.club.clubID!) ?? []
                self.clubEvents = await fetchClubEvents(clubID: self.myClubProfileData!.club.clubID!) ?? []
            }
            else {
//                allPosts = await fetchAllClubPosts(for: self.clubProfileData!.clubID!) ?? []
                self.clubEvents = await fetchClubEvents(clubID: self.clubProfileData!.clubID!) ?? []
            }
            
            collectionViewClubEvents.isHidden = false
            collectionViewClubEvents.reloadData()
            
        }

    }
    
    func updatedClubData(club: Club) {
        self.myClubProfileData?.club = club
        
        labelClubName.text = myClubProfileData?.club.clubName
        labelSportType.text = myClubProfileData?.club.clubSport.rawValue
        clubDescription.text = myClubProfileData?.club.clubDescription
        clubMotive.text = myClubProfileData?.club.clubMotive
        
        if let url = URL(string: (myClubProfileData!.club.clubProfileImageURL!)) {
            self.clubProfileImage.kf.setImage(with: url)
        }

        if let url = URL(string: (myClubProfileData!.club.clubBannerImageURL!)) {
            self.imageClubBanner.kf.setImage(with: url)
        }

    }
    
    func settingCollectionAndTableView() {
        collectionViewClubEvents.delegate = self
        collectionViewClubEvents.dataSource = self

        let nib = UINib(nibName: "EventCollectionViewCell", bundle: nil)
        collectionViewClubEvents.register(nib, forCellWithReuseIdentifier: "cell")
        
        if let layout = collectionViewClubEvents.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        }
        
        tableViewLeaderBoard.dataSource = self
        tableViewLeaderBoard.delegate = self
        tableViewLeaderBoard.register(UINib(nibName: "ClubLeaderboardTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

    }
    
    func settingUpProfileScreenElements() {
        if isMyClub {
            labelClubName.text = myClubProfileData?.club.clubName
            labelSportType.text = myClubProfileData?.club.clubSport.rawValue
            labelNumberOfMembers.text = String(myClubProfileData!.club.memberCount) + " Members"
            clubDescription.text = myClubProfileData?.club.clubDescription
            clubMotive.text = myClubProfileData?.club.clubMotive
            
            if let url = URL(string: (myClubProfileData!.club.clubProfileImageURL!)) {
                self.clubProfileImage.kf.setImage(with: url)
            }
            
            if let url = URL(string: (myClubProfileData!.club.clubBannerImageURL!)) {
                self.imageClubBanner.kf.setImage(with: url)
            }
            
            if myClubProfileData?.role == .owner {
                joinNowButton.setTitle("Edit Club Profile", for: .normal)
                leaveClubButton.setTitle("Delete", for: .normal)
            }
            else {
                joinNowButton.setTitle("Joined", for: .normal)
                leaveClubButton.setTitle("Leave", for: .normal)
            }
            
            joinNowButton.setTitleColor(.accent, for: .normal)
            joinNowButton.backgroundColor = .black
            joinNowButton.layer.borderColor = UIColor.accent.cgColor
            joinNowButton.layer.borderWidth = 1

            leaveClubButton.isHidden = false
            
            Task {
                self.clubOwnerDetails = await fetchUserProfile(userId: myClubProfileData?.club.clubOwnerID ?? UUID())
                if let clubOwner = clubOwnerDetails {
                    self.labelClubOwnerName.text = clubOwner.userName
                    if let url = URL(string: (clubOwner.userProfileImageURL ?? "")) {
                        self.imageOwnerProfile.kf.setImage(with: url)
                    }
                    
                }
            }
        }
        else {
            
            if let url = URL(string: (clubProfileData!.clubProfileImageURL!)) {
                self.clubProfileImage.kf.setImage(with: url)
            }
            
            if let url = URL(string: (clubProfileData!.clubBannerImageURL!)) {
                self.imageClubBanner.kf.setImage(with: url)
            }
            
            Task {
                self.clubOwnerDetails = await fetchUserProfile(userId: clubProfileData?.clubOwnerID ?? UUID())
                if let clubOwner = clubOwnerDetails {
                    self.labelClubOwnerName.text = clubOwner.userName
                    if let url = URL(string: (clubOwner.userProfileImageURL ?? "")) {
                        self.imageOwnerProfile.kf.setImage(with: url)
                    }
                    
                }
            }

            labelClubName.text = clubProfileData?.clubName
            labelSportType.text = clubProfileData?.clubSport.rawValue
            labelNumberOfMembers.text = String(clubProfileData!.memberCount) + " Members"
            clubDescription.text = clubProfileData?.clubDescription
            clubMotive.text = clubProfileData?.clubMotive
            
            joinNowButton.setTitle("Join Now", for: .normal)
            
            joinNowButton.setTitleColor(.black, for: .normal)
            joinNowButton.backgroundColor = .accent
            
            leaveClubButton.isHidden = true
        }
        
        clubProfileImage.layer.cornerRadius = 15
        clubProfileImage.clipsToBounds = true
        
        joinNowButton.layer.cornerRadius = joinNowButton.frame.height / 2.0
        self.viewBackgroundOwner.layer.cornerRadius = 15
        self.imageOwnerProfile.layer.cornerRadius = imageOwnerProfile.frame.height / 2.0
    }
    
    @IBAction func taggedButtonPressed(_ sender: UIButton) {
        showTagged()
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        viewPostLine.backgroundColor = .white
        //viewTaggedLine.backgroundColor = .accent
        viewLeaderboardLine.backgroundColor = .white
    }
    
    @IBAction func leaderboardButtonPressed(_ sender: UIButton) {
        showLeaderBoard()
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        viewPostLine.backgroundColor = .white
        //viewTaggedLine.backgroundColor = .white
        viewLeaderboardLine.backgroundColor = .accent

    }
    
    @IBAction func postsButtonPressed(_ sender: UIButton) {
        showPosts()
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        viewPostLine.backgroundColor = .accent
        //viewTaggedLine.backgroundColor = .white
        viewLeaderboardLine.backgroundColor = .white

    }
    
    @IBAction func editClubProfilePressed(_ sender: UIButton) {
       
        Task {
            
            if joinNowButton.titleLabel?.text == "Edit Club Profile" {
                let destinationVC = ClubSettingsViewController()
//                destinationVC.modalPresentationStyle = .fullScreen
                destinationVC.delegate = self
                destinationVC.clubProfileData = myClubProfileData?.club
                self.present(destinationVC, animated: true)
            }
            
            else if joinNowButton.titleLabel?.text == "Join Now" {
                if let clubID = self.clubProfileData?.clubID {
                    await insertNewClubMember(newMember: ClubMemberRole(userID: self.userProfileData.userID, clubID: clubID, role: .member))
                    
                    var updatedClub = self.clubProfileData!
                    updatedClub.memberCount += 1
                    await updateClubInfo(clubID: clubID, updatedData: updatedClub)
                    
                    joinNowButton.setTitle("Joined", for: .normal)
                    joinNowButton.setTitleColor(.accent, for: .normal)
                    joinNowButton.backgroundColor = .black
                    joinNowButton.layer.borderColor = UIColor.accent.cgColor
                    joinNowButton.layer.borderWidth = 1
                }
            }
        }
        
    }
    
    
    @IBAction func leaveClubPressed(_ sender: UIButton) {
        let isOwner = myClubProfileData?.role == .owner
        let title = isOwner ? "Delete Club" : "Leave Club"
        let message = isOwner ? "Do you really want to delete this club?" : "Do you really want to leave this club?"
        let actionTitle = isOwner ? "Delete" : "Leave"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { _ in
            Task {
                if isOwner {
                    // Delete Club
                    if let clubID = self.myClubProfileData?.club.clubID {
                        await deleteClub(clubID: clubID)
                    }
                } else {
                    // Leave Club
                    if let userID = self.userProfileData.userID,
                       let clubID = self.myClubProfileData?.club.clubID {
                        
                        await removeClubMember(userID: userID, clubID: clubID)
                        
                        var updatedClub = self.myClubProfileData!.club
                        updatedClub.memberCount = max(0, updatedClub.memberCount - 1)
                        await updateClubInfo(clubID: clubID, updatedData: updatedClub)
                    }
                }
                
                await MainActor.run {
                    self.navigationController?.dismiss(animated: true)
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func viewOwnerProfile(_ sender: UIButton) {
        let destinationVC = UserProfileViewController(nibName: "UserProfileViewController", bundle: nil)
        destinationVC.friendData = clubOwnerDetails
        destinationVC.isFromFriendsScreen = true
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true)
    }
    
    func showPosts() {
        collectionViewClubEvents.isHidden = false
        tableViewLeaderBoard.isHidden = true
        createNewEventButton.isHidden = false
        
        collectionViewClubEvents.isScrollEnabled = false
        collectionViewClubEvents.reloadData()
        
        let targetHeight: CGFloat = 580
        collectionViewClubEvents.constraints.forEach { if $0.firstAttribute == .height { collectionViewClubEvents.removeConstraint($0) } }
        collectionViewClubEvents.heightAnchor.constraint(equalToConstant: targetHeight).isActive = true
        
        scrollView.contentSize.height = self.collectionViewClubEvents.frame.origin.y + targetHeight + 50
    }

    func showLeaderBoard() {
        collectionViewClubEvents.isHidden = true
        tableViewLeaderBoard.isHidden = false
        createNewEventButton.isHidden = true
        
        // Ensure table view doesn't scroll inside the main scroll view
        tableViewLeaderBoard.isScrollEnabled = false
        tableViewLeaderBoard.reloadData()
        
        tableViewLeaderBoard.layoutIfNeeded()
        let tableHeight = max(tableViewLeaderBoard.contentSize.height, 350)
        
        // Set dynamic height constraint to match contents
        tableViewLeaderBoard.constraints.forEach { if $0.firstAttribute == .height { tableViewLeaderBoard.removeConstraint($0) } }
        tableViewLeaderBoard.heightAnchor.constraint(equalToConstant: tableHeight).isActive = true
        
        scrollView.contentSize.height = self.collectionViewClubEvents.frame.origin.y + tableHeight + 50
    }

    func showTagged() {
        collectionViewClubEvents.isHidden = false
        tableViewLeaderBoard.isHidden = true
        createNewEventButton.isHidden = false
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

extension ClubProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.clubEvents.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EventCollectionViewCell
        cell.configureCell(event: clubEvents[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 370)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
