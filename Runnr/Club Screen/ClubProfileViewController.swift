import UIKit
import Kingfisher

class ClubProfileViewController: UIViewController, UpdateClubProfile, CreateRunEventDelegate {
    
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
    @IBOutlet var buttonBack: UIButton!
    @IBOutlet weak var imageClubBanner: UIImageView!
    @IBOutlet weak var viewPostLine: UIView!
    @IBOutlet weak var viewLeaderboardLine: UIView!
    @IBOutlet var leaveClubButton: UIButton!
    @IBOutlet var createNewEventButton: UIButton!
    @IBOutlet weak var viewBackgroundOwner: UIView!
    @IBOutlet weak var imageOwnerProfile: UIImageView!
    @IBOutlet weak var labelClubOwnerName: UILabel!
    @IBOutlet weak var collectionviewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelDummyText: UILabel!
    
    private let noEventsLabel = UILabel()
    private let noEventsIconView = UIImageView()
    private let noEventsStack = UIStackView()
    
    var isMyClub: Bool = false
    var clubProfileData: Club?
    var myClubProfileData : ClubRoleAndData?
    
    private var clubOwnerDetails: UserProfile?
    private var clubEvents: [ClubEvents] = []
    private var pollSummaries: [UUID: EventPollSummary] = [:]
    private var userProfileData = DataSource.shared.getUserProfile()
    private var dataSource = DataSource.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        buildEmptyStateView()
        settingUpProfileScreenElements()
        settingCollectionAndTableView()
                
        collectionViewClubEvents.isHidden = false
        tableViewLeaderBoard.isHidden = true
        
        setGlassEffect(for: self.buttonBack, withImage: "chevron.backward")
        buttonBack.layer.cornerRadius = 20
        
//        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        
        
//        self.leaveClubButton.layer.cornerRadius = self.leaveClubButton.frame.height / 2

        createNewEventButton.layer.cornerRadius = createNewEventButton.frame.height / 2
        createNewEventButton.addTarget(self, action: #selector(presentCreateEvent), for: .touchUpInside)
        
        viewPosts.addTarget(self, action: #selector(createEventButtonPressed(_:)), for: .touchUpInside)
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
        vc.delegate = self
        vc.clubDetails = myClubProfileData?.club
        self.present(vc, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task {
            if isMyClub {
                self.clubEvents = await fetchClubEvents(clubID: self.myClubProfileData!.club.clubID!) ?? []
            }
            else {
                self.clubEvents = await fetchClubEvents(clubID: self.clubProfileData!.clubID!) ?? []
            }

            dataSource.setClubEvents(self.clubEvents)

            // Fetch poll summaries for all events in parallel
            let currentUserID = userProfileData.userID ?? UUID()
            var summaries: [UUID: EventPollSummary] = [:]

            await withTaskGroup(of: (UUID, EventPollSummary)?.self) { group in
                for event in self.clubEvents {
                    if let eventID = event.eventID {
                        group.addTask {
                            let summary = await fetchPollSummary(eventID: eventID, userID: currentUserID)
                            return (eventID, summary)
                        }
                    }
                }
                for await result in group {
                    if let (id, summary) = result {
                        summaries[id] = summary
                    }
                }
            }

            self.pollSummaries = summaries

            DispatchQueue.main.async {
                self.collectionViewClubEvents.reloadData()
                self.collectionViewClubEvents.layoutIfNeeded()
                self.updateCollectionViewHeight()
                self.noEventsStack.isHidden = !self.clubEvents.isEmpty
            }
        }
    }
    
    func updatedClubData(club: Club) {
        self.myClubProfileData?.club = club
        
        labelClubName.text = myClubProfileData?.club.clubName
        labelSportType.text = myClubProfileData?.club.clubSport?.rawValue
        clubDescription.text = myClubProfileData?.club.clubDescription
        clubMotive.text = myClubProfileData?.club.clubMotive
        
        if let url = URL(string: (myClubProfileData!.club.clubProfileImageURL ?? "")) {
            self.clubProfileImage.kf.setImage(with: url)
        }
        else {
            self.clubProfileImage.image = UIImage(named: "Club")
        }

        if let url = URL(string: (myClubProfileData!.club.clubBannerImageURL ?? "")) {
            self.imageClubBanner.kf.setImage(with: url)
        }
        else {
            self.imageClubBanner.image = UIImage(named: "ClubBanner")
        }
    }
    
    func buildEmptyStateView() {
        // Setup empty state (icon + label)
        noEventsIconView.image = UIImage(systemName: "calendar.badge.exclamationmark")
        noEventsIconView.tintColor = .tertiaryLabel
        noEventsIconView.contentMode = .scaleAspectFit
        noEventsIconView.setContentHuggingPriority(.required, for: .vertical)
        noEventsIconView.setContentCompressionResistancePriority(.required, for: .vertical)

        noEventsLabel.text = "No events yet"
        noEventsLabel.textColor = .secondaryLabel
        noEventsLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        noEventsLabel.textAlignment = .center
        noEventsLabel.numberOfLines = 0

        noEventsStack.axis = .vertical
        noEventsStack.alignment = .center
        noEventsStack.spacing = 8
        noEventsStack.translatesAutoresizingMaskIntoConstraints = false
        noEventsStack.isHidden = true

        noEventsStack.addArrangedSubview(noEventsIconView)
        noEventsStack.addArrangedSubview(noEventsLabel)

        noEventsIconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noEventsIconView.widthAnchor.constraint(equalToConstant: 36),
            noEventsIconView.heightAnchor.constraint(equalToConstant: 36)
        ])

        scrollView.addSubview(noEventsStack)
        NSLayoutConstraint.activate([
            noEventsStack.centerXAnchor.constraint(equalTo: collectionViewClubEvents.centerXAnchor),
            noEventsStack.topAnchor.constraint(equalTo: collectionViewClubEvents.topAnchor, constant: 40),
            noEventsStack.widthAnchor.constraint(lessThanOrEqualTo: scrollView.widthAnchor, constant: -40)
        ])

    }
    
    func settingCollectionAndTableView() {
        collectionViewClubEvents.delegate = self
        collectionViewClubEvents.dataSource = self
        collectionViewClubEvents.isScrollEnabled = false
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
    
    func updateCollectionViewHeight() {

        collectionViewClubEvents.collectionViewLayout.invalidateLayout()
        collectionViewClubEvents.layoutIfNeeded()
        
        let height = collectionViewClubEvents.collectionViewLayout.collectionViewContentSize.height
        collectionviewHeightConstraint.constant = height
        view.layoutIfNeeded()
    }

    func settingUpProfileScreenElements() {
        if isMyClub {
            labelClubName.text = myClubProfileData?.club.clubName
            labelSportType.text = myClubProfileData?.club.clubSport?.rawValue
            labelNumberOfMembers.text = String(myClubProfileData!.club.memberCount ?? 0) + " Members"
            clubDescription.text = myClubProfileData?.club.clubDescription
            clubMotive.text = myClubProfileData?.club.clubMotive
            
            if clubDescription.text == "" {
                self.labelDummyText.text = ""
            }
            else {
                self.labelDummyText.text = "  "
            }
            
            if let url = URL(string: (myClubProfileData!.club.clubProfileImageURL ?? "")) {
                self.clubProfileImage.kf.setImage(with: url)
            }
            else {
                self.clubProfileImage.image = UIImage(named: "Club")
            }
            
            if let url = URL(string: (myClubProfileData!.club.clubBannerImageURL ?? "")) {
                self.imageClubBanner.kf.setImage(with: url)
            }
            else {
                self.imageClubBanner.image = UIImage(named: "ClubBanner")
            }

            
            if myClubProfileData?.role == .owner {
                joinNowButton.setTitle("Edit Club Profile", for: .normal)
                
                setGlassEffect(for: self.leaveClubButton, withImage: "trash")
            }
            else {
                joinNowButton.setTitle("Joined", for: .normal)
                setGlassEffect(for: self.leaveClubButton, withImage: "door.left.hand.open")
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
            
            if let url = URL(string: (clubProfileData!.clubProfileImageURL ?? "")) {
                self.clubProfileImage.kf.setImage(with: url)
            }
            else {
                self.clubProfileImage.image = UIImage(named: "Club")
            }
            
            if let url = URL(string: (clubProfileData!.clubBannerImageURL ?? "")) {
                self.imageClubBanner.kf.setImage(with: url)
            }
            else {
                self.imageClubBanner.image = UIImage(named: "ClubBanner")
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
            labelSportType.text = clubProfileData?.clubSport?.rawValue
            labelNumberOfMembers.text = String(clubProfileData!.memberCount ?? 0) + " Members"
            clubDescription.text = clubProfileData?.clubDescription
            clubMotive.text = clubProfileData?.clubMotive
            
            if clubDescription.text == "" {
                self.labelDummyText.text = ""
            }
            else {
                self.labelDummyText.text = "  "
            }
            
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
    
    @IBAction func createEventButtonPressed(_ sender: UIButton) {
        showEvents()
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
                    updatedClub.memberCount! += 1
                    await updateClubInfo(updatedData: updatedClub)
                    
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
                    if let club = self.myClubProfileData?.club {
                        await deleteClub(clubDetails: club)
                    }
                } else {
                    // Leave Club
                    if let userID = self.userProfileData.userID,
                       let clubID = self.myClubProfileData?.club.clubID {
                        
                        await removeClubMember(userID: userID, clubID: clubID)
                        
                        var updatedClub = self.myClubProfileData!.club
                        updatedClub.memberCount = max(0, updatedClub.memberCount ?? 0 - 1)
                        await updateClubInfo(updatedData: updatedClub)
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
            nav.dismiss(animated: true)
        } else if self.presentingViewController != nil {
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
    
    func showEvents() {
        collectionViewClubEvents.isHidden = false
        tableViewLeaderBoard.isHidden = true
        createNewEventButton.isHidden = false

        collectionViewClubEvents.reloadData()
        updateCollectionViewHeight()
        noEventsStack.isHidden = !clubEvents.isEmpty
    }
    
    func showLeaderBoard() {
        collectionViewClubEvents.isHidden = true
        tableViewLeaderBoard.isHidden = false
        createNewEventButton.isHidden = true
        
        // Ensure table view doesn't scroll inside the main scroll view
        tableViewLeaderBoard.isScrollEnabled = false
        tableViewLeaderBoard.reloadData()
        
        noEventsStack.isHidden = true
        
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
        noEventsStack.isHidden = !clubEvents.isEmpty
    }
    
    func didCreateEvent() {
        self.clubEvents = dataSource.getClubEvents()
        DispatchQueue.main.async {
            self.collectionViewClubEvents.reloadData()
            self.updateCollectionViewHeight()
            self.noEventsStack.isHidden = !self.clubEvents.isEmpty
        }
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
        let event = clubEvents[indexPath.row]
        let summary = event.eventID.flatMap { pollSummaries[$0] }
        cell.configureCell(event: event, pollSummary: summary)
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 570)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - Poll Delegate

extension ClubProfileViewController: EventPollCellDelegate {

    func pollCell(_ cell: EventCollectionViewCell,
                  didVote voteType: PollVoteType,
                  for eventID: UUID) {

        let userID = userProfileData.userID ?? UUID()

        // --- Optimistic local update ---
        var summary = pollSummaries[eventID] ??
            EventPollSummary(joiningCount: 0, maybeCount: 0, notGoingCount: 0, myVote: nil)

        if summary.myVote == voteType {
            // Toggle off: user tapped their current choice again
            switch voteType {
            case .joining:  summary.joiningCount  = max(0, summary.joiningCount  - 1)
            case .maybe:    summary.maybeCount    = max(0, summary.maybeCount    - 1)
            case .notGoing: summary.notGoingCount = max(0, summary.notGoingCount - 1)
            }
            summary.myVote = nil
        } else {
            // Switch or new vote: decrement old count first
            if let old = summary.myVote {
                switch old {
                case .joining:  summary.joiningCount  = max(0, summary.joiningCount  - 1)
                case .maybe:    summary.maybeCount    = max(0, summary.maybeCount    - 1)
                case .notGoing: summary.notGoingCount = max(0, summary.notGoingCount - 1)
                }
            }
            switch voteType {
            case .joining:  summary.joiningCount  += 1
            case .maybe:    summary.maybeCount    += 1
            case .notGoing: summary.notGoingCount += 1
            }
            summary.myVote = voteType
        }

        pollSummaries[eventID] = summary

        // Reload just that cell immediately so counts and highlight refresh
        if let indexPath = collectionViewClubEvents.indexPath(for: cell) {
            collectionViewClubEvents.reloadItems(at: [indexPath])
        }

        // --- Persist to Supabase in background ---
        let wasToggleOff = (summary.myVote == nil)
        Task {
            if wasToggleOff {
                await deletePollVote(eventID: eventID, userID: userID)
            } else {
                await upsertPollVote(eventID: eventID, userID: userID, voteType: voteType)
            }
        }
    }
}
