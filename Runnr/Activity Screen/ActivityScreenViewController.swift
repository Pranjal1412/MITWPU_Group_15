//
//  ActivityScreenViewController.swift
//  Runnr
//

import UIKit
import Kingfisher

class ActivityScreenViewController: UIViewController {

    @IBOutlet weak var viewCurrency: UIView!
    @IBOutlet weak var tableViewMyActivity: UITableView!
    @IBOutlet weak var labelRecentActivities: UILabel!
    @IBOutlet weak var segmentedControlActivityScreen: UISegmentedControl!
    @IBOutlet weak var tableViewFriendsActivity: UITableView!
    @IBOutlet weak var labelScreenTitle: UILabel!
    @IBOutlet weak var stackRecentActivities: UIStackView!
    @IBOutlet weak var labelTotalPoints: UILabel!
    @IBOutlet weak var buttonUserProfile: UIButton!
    @IBOutlet weak var profileImage: UIImageView!

    private let label = UILabel()
    private let loader = UIActivityIndicatorView(style: .large)
    private var dataSource = DataSource.shared

    private var userProfile: UserProfile {
        DataSource.shared.getUserProfile()
    }
    private var myActivity: [ActivityDetails] {
        dataSource.getAllActivities()
    }
    private var friendsActivity: [ActivityDetails] {
        dataSource.getFriendsActivityData()
    }
    var totalPoints: Int {
        dataSource.getUserStats()?.totalPointsEarned ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        settingTableView()
        settingLabelStyle()
        settingSegmentedControl()

        tableViewMyActivity.isHidden = false
        tableViewFriendsActivity.isHidden = true

        label.frame = CGRect(x: 0, y: view.frame.height / 2 + 20.0, width: view.frame.width, height: 50)
        label.textAlignment = .center
        view.addSubview(label)
        label.isHidden = true

        loader.center = view.center
        loader.hidesWhenStopped = true
        view.addSubview(loader)

        self.buttonUserProfile.layer.cornerRadius = self.buttonUserProfile.frame.height / 2
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
        self.profileImage.clipsToBounds = true
        self.viewCurrency.layer.cornerRadius = self.viewCurrency.frame.height / 2
        self.buttonUserProfile.clipsToBounds = true

        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        let profileImageURL = DataSource.shared.getUserProfile().userProfileImageURL

        if let urlString = profileImageURL,
           let url = URL(string: urlString) {
            self.profileImage.kf.setImage(with: url)
            self.profileImage.layer.borderWidth = 0
            self.profileImage.layer.borderColor = UIColor.clear.cgColor
        } else {
            self.profileImage.layer.borderWidth = 1
            self.profileImage.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        }

        loader.startAnimating()

        Task {
            let activities = await fetchAllMyActivities(userProfile: self.userProfile)
            let friendActivity = await fetchFollowedUsersAtivities(currentUserID: userProfile.userID!)

            await MainActor.run {
                self.dataSource.setAllActivities(activities)
                self.dataSource.setFriendsActivityData(friendActivity)
                self.updateScreenElements()
                self.labelTotalPoints.text = "\(self.totalPoints)"
                self.loader.stopAnimating()
            }
        }
    }

    func settingLabelStyle() {
        self.labelScreenTitle.text = String(localized: "Activities")
        self.labelScreenTitle.sizeToFit()

        let thinFont = UIFont(name: "SFProText-Thin", size: 25) ?? UIFont.systemFont(ofSize: 25, weight: .thin)
        let boldFont = UIFont(name: "SFProText-Bold", size: 25) ?? UIFont.boldSystemFont(ofSize: 25)

        let recentText = NSAttributedString(string: "Recent ",
                                            attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        let activitiesText = NSAttributedString(string: "Activities",
                                                attributes: [.font: boldFont, .foregroundColor: UIColor.white])

        let fullText = NSMutableAttributedString()
        fullText.append(recentText)
        fullText.append(activitiesText)

        let thinText = NSAttributedString(string: "No ",
                                          attributes: [.font: thinFont, .foregroundColor: UIColor.lightGray])
        let boldText = NSAttributedString(string: "Activities",
                                          attributes: [.font: boldFont, .foregroundColor: UIColor.lightGray])

        let completeText = NSMutableAttributedString()
        completeText.append(thinText)
        completeText.append(boldText)

        labelRecentActivities.attributedText = fullText
        labelRecentActivities.sizeToFit()
        label.attributedText = completeText
    }

    func settingTableView() {

        tableViewMyActivity.delegate = self
        tableViewMyActivity.dataSource = self
        tableViewMyActivity.showsVerticalScrollIndicator = false
        tableViewMyActivity.separatorStyle = .none
        tableViewMyActivity.backgroundColor = .clear
        tableViewMyActivity.rowHeight = UITableView.automaticDimension
        tableViewMyActivity.estimatedRowHeight = 500

        tableViewFriendsActivity.delegate = self
        tableViewFriendsActivity.dataSource = self
        tableViewFriendsActivity.showsVerticalScrollIndicator = false
        tableViewFriendsActivity.separatorStyle = .none
        tableViewFriendsActivity.backgroundColor = .clear
        tableViewFriendsActivity.rowHeight = UITableView.automaticDimension
        tableViewFriendsActivity.estimatedRowHeight = 500

        tableViewMyActivity.register(UINib(nibName: "MyActivityTableViewCell", bundle: nil),
                                     forCellReuseIdentifier: "cell")
        tableViewFriendsActivity.register(UINib(nibName: "FriendsActivityTableViewCell", bundle: nil),
                                          forCellReuseIdentifier: "cellFriends")
    }

    func settingSegmentedControl() {
        segmentedControlActivityScreen.layer.borderWidth = 0.5
        segmentedControlActivityScreen.layer.borderColor = UIColor.accent.cgColor
        segmentedControlActivityScreen.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }

    func updateScreenElements() {
        let isFriendsSegment = segmentedControlActivityScreen.selectedSegmentIndex == 1
        let isEmpty = isFriendsSegment ? friendsActivity.isEmpty : myActivity.isEmpty
        label.isHidden = !isEmpty

        if isFriendsSegment {
            stackRecentActivities.isHidden = true
            tableViewMyActivity.isHidden = true
            tableViewFriendsActivity.isHidden = isEmpty
        } else {
            stackRecentActivities.isHidden = isEmpty
            tableViewMyActivity.isHidden = isEmpty
            tableViewFriendsActivity.isHidden = true
        }

        tableViewMyActivity.reloadData()
        tableViewFriendsActivity.reloadData()
    }

    private func fetchAndPrepare(activity: ActivityDetails, completion: @escaping () -> Void) {
        Task {
            self.dataSource.setCurrentActivity(activity)

            let routeCoordinates = await fetchActivityRouteCoordinates(activity.activity!.activityID!)
            self.dataSource.setCurrentActivityCoordinates(routeCoordinates)

            let paceData = await fetchActivityPaceGraphData(activity.activity!.activityID!)
            self.dataSource.setCurrentActivityPaceData(paceData)

            let activityImages = await fetchActivityImages(activity.activity!.activityID!)
            self.dataSource.setCurrentActivityImages(activityImages)

            await MainActor.run {
                completion()
            }
        }
    }

    @IBAction func chevronToAllActivities(_ sender: UIButton) {
        let destinationVC = AllActivitiesViewController()
        navigationController?.pushViewController(destinationVC, animated: true)
    }

    @IBAction func segmentChangeToFriends(_ sender: UISegmentedControl) {
        self.updateScreenElements()
    }

    @IBAction func profileButtonPressed(_ sender: UIButton) {
        let destinationVC = UserProfileViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true)
    }
}

// MARK: - TableView

extension ActivityScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableViewMyActivity {
            return min(myActivity.count, 3)
        }

        if tableView == tableViewFriendsActivity {
            return friendsActivity.count
        }

        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewMyActivity {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyActivityTableViewCell else {
                return UITableViewCell()
            }

            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.configure(with: myActivity[indexPath.section].activity!)

            return cell

        } else {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellFriends", for: indexPath) as? FriendsActivityTableViewCell else {
                return UITableViewCell()
            }

            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.configure(with: friendsActivity[indexPath.section])

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView == tableViewMyActivity {

            let activity = myActivity[indexPath.section]

            fetchAndPrepare(activity: activity) {

                let vc = ActivityAnalysisViewController()

                vc.activityData = self.dataSource.getCurrentActivity()
                vc.isNewActivity = false

                vc.onActivityDeleted = {
                    self.updateScreenElements()
                }

                vc.modalPresentationStyle = .overFullScreen

                self.present(vc, animated: true)
            }

        } else {

            let activityDetails = friendsActivity[indexPath.section]

            fetchAndPrepare(activity: activityDetails) {

                let vc = ActivityAnalysisViewController()

                vc.activityData = self.dataSource.getCurrentActivity()
                vc.isNewActivity = false

                vc.onActivityDeleted = {
                    self.updateScreenElements()
                }

                vc.modalPresentationStyle = .overFullScreen

                self.present(vc, animated: true)
            }
        }
    }

    // MARK: Swipe Delete

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        guard tableView == tableViewMyActivity else { return nil }

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: nil
        ) { [weak self] _, _, completion in

            guard let self else { return }

            let activity = self.myActivity[indexPath.section]

            let alert = UIAlertController(
                title: "Delete Activity",
                message: "Are you sure you want to delete this activity?",
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    completion(false)
                }
            )

            alert.addAction(
                UIAlertAction(title: "Delete", style: .destructive) { _ in

                    Task {

                        guard let activityID = activity.activity?.activityID,
                              let mapImageURL = activity.activity?.mapImageURL
                        else { return }

                        await deleteUserActivity(
                            activityID: activityID,
                            mapImageURL: mapImageURL
                        )

                        await MainActor.run {

                            DataSource.shared.deleteActivityFromLocalArray(
                                activityID: activityID
                            )

                            self.updateScreenElements()

                            completion(true)
                        }
                    }
                }
            )

            self.present(alert, animated: true)
        }

        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    // MARK: Swipe Share

    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        guard tableView == tableViewMyActivity else { return nil }

        let shareAction = UIContextualAction(
            style: .normal,
            title: nil
        ) { [weak self] _, _, completion in

            guard let self else {
                return completion(false)
            }

            let activity = self.myActivity[indexPath.section]

            let loadingAlert = UIAlertController(
                title: nil,
                message: "Preparing share...",
                preferredStyle: .alert
            )

            let indicator = UIActivityIndicatorView(style: .medium)

            indicator.startAnimating()
            indicator.translatesAutoresizingMaskIntoConstraints = false

            loadingAlert.view.addSubview(indicator)

            NSLayoutConstraint.activate([
                indicator.centerXAnchor.constraint(
                    equalTo: loadingAlert.view.centerXAnchor
                ),
                indicator.centerYAnchor.constraint(
                    equalTo: loadingAlert.view.centerYAnchor,
                    constant: 16
                )
            ])

            loadingAlert.view.heightAnchor.constraint(
                equalToConstant: 100
            ).isActive = true

            self.present(loadingAlert, animated: true)

            self.fetchAndPrepare(activity: activity) {

                let analysisVC = ActivityAnalysisViewController()

                analysisVC.activityData = self.dataSource.getCurrentActivity()

                _ = analysisVC.view

                if let mapURLStr = activity.activity?.mapImageURL,
                   let mapURL = URL(string: mapURLStr) {

                    KingfisherManager.shared.retrieveImage(with: mapURL) {
                        [weak self] result in

                        guard let self else { return }

                        let mapImage: UIImage? = try? result.get().image

                        let card = analysisVC.buildShareCardPublic(
                            mapImage: mapImage
                        )

                        loadingAlert.dismiss(animated: true) {

                            self.presentShareSheet(
                                image: card,
                                sourceTableView: tableView,
                                indexPath: indexPath
                            )

                            completion(true)
                        }
                    }

                } else {

                    let card = analysisVC.buildShareCardPublic(mapImage: nil)

                    loadingAlert.dismiss(animated: true) {

                        self.presentShareSheet(
                            image: card,
                            sourceTableView: tableView,
                            indexPath: indexPath
                        )

                        completion(true)
                    }
                }
            }
        }

        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        shareAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [shareAction])
    }

    // MARK: Share Sheet

    private func presentShareSheet(
        image: UIImage,
        sourceTableView: UITableView,
        indexPath: IndexPath
    ) {

        let shareVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )

        shareVC.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList,
            .openInIBooks
        ]

        if let popover = shareVC.popoverPresentationController {

            popover.sourceView =
            sourceTableView.cellForRow(at: indexPath) ?? self.view

            popover.sourceRect =
            sourceTableView.cellForRow(at: indexPath)?.bounds
            ?? self.view.bounds
        }

        self.present(shareVC, animated: true)
    }
}
