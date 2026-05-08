import UIKit
import Kingfisher

class AllActivitiesViewController: UIViewController {
    
    @IBOutlet weak var tableViewMyActivity: UITableView!
    @IBOutlet weak var buttonCalendar: UIButton!
    
    let label = UILabel()
    
    var dataSource = DataSource.shared
    var selectedFilterDate: Date? = nil
    
    var myActivity: [ActivityDetails] {
        guard let date = selectedFilterDate else {
            return dataSource.getAllActivities()
        }
        
        return dataSource.getAllActivities().filter {
            guard let activityDate = $0.activity?.activityStartTime else {
                return false
            }
            
            return Calendar.current.isDate(activityDate, inSameDayAs: date)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingLabel()
        settingTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateScreenElements()
    }
    
    func settingTableView() {
        
        tableViewMyActivity.delegate = self
        tableViewMyActivity.dataSource = self
        
        tableViewMyActivity.register(
            UINib(
                nibName: "MyActivityTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: "cell"
        )
        
        tableViewMyActivity.showsVerticalScrollIndicator = false
        tableViewMyActivity.separatorStyle = .none
        tableViewMyActivity.backgroundColor = .clear
        
        tableViewMyActivity.rowHeight = UITableView.automaticDimension
        tableViewMyActivity.estimatedRowHeight = 500
    }
    
    func settingLabel() {
        
        let thinFont = UIFont(
            name: "SFProText-Thin",
            size: 25
        ) ?? UIFont.systemFont(ofSize: 25, weight: .thin)
        
        let boldFont = UIFont(
            name: "SFProText-Bold",
            size: 25
        ) ?? UIFont.boldSystemFont(ofSize: 25)
        
        let thinText = NSAttributedString(
            string: "No ",
            attributes: [
                .font: thinFont,
                .foregroundColor: UIColor.lightGray
            ]
        )
        
        let boldText = NSAttributedString(
            string: "Activities",
            attributes: [
                .font: boldFont,
                .foregroundColor: UIColor.lightGray
            ]
        )
        
        let completeText = NSMutableAttributedString()
        
        completeText.append(thinText)
        completeText.append(boldText)
        
        label.attributedText = completeText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @IBAction func buttonCalendarTapped(_ sender: UIButton) {
        
        let calendarVC = CalendarViewController()
        
        calendarVC.modalPresentationStyle = .overFullScreen
        calendarVC.modalTransitionStyle = .crossDissolve
        calendarVC.delegate = self
        
        present(calendarVC, animated: false)
    }
}

// MARK: - TableView Settings

extension AllActivitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myActivity.count
    }
    
    // MARK: Rows
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }
    
    // MARK: Footer Spacing
    
    func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        return 25
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }

    // MARK: Cell
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as! MyActivityTableViewCell
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        let activityDetails = myActivity[indexPath.section]
        
        cell.configure(with: activityDetails.activity!)
        
        return cell
    }
    
    // MARK: Select
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        
        let activity = myActivity[indexPath.section]

        Task {
            
            self.dataSource.setCurrentActivity(activity)

            let routeCoordinates = await fetchActivityRouteCoordinates(
                activity.activity!.activityID!
            )
            
            self.dataSource.setCurrentActivityCoordinates(routeCoordinates)
            
            let paceData = await fetchActivityPaceGraphData(
                activity.activity!.activityID!
            )
            
            self.dataSource.setCurrentActivityPaceData(paceData)
            
            let activityImages = await fetchActivityImages(
                activity.activity!.activityID!
            )
            
            self.dataSource.setCurrentActivityImages(activityImages)
            
            await MainActor.run {
                
                let destinationVC = ActivityAnalysisViewController()
                
                destinationVC.activityData =
                self.dataSource.getCurrentActivity()
                
                destinationVC.isNewActivity = false
                
                destinationVC.onActivityDeleted = {
                    self.updateScreenElements()
                }
                
                destinationVC.modalPresentationStyle = .overFullScreen
                
                self.present(destinationVC, animated: true)
            }
        }
    }
    
    // MARK: - Swipe Left → Delete

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

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

    // MARK: - Swipe Right → Share

    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

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

            Task {

                self.dataSource.setCurrentActivity(activity)

                let routeCoordinates = await fetchActivityRouteCoordinates(
                    activity.activity!.activityID!
                )

                self.dataSource.setCurrentActivityCoordinates(routeCoordinates)

                let paceData = await fetchActivityPaceGraphData(
                    activity.activity!.activityID!
                )

                self.dataSource.setCurrentActivityPaceData(paceData)

                let activityImages = await fetchActivityImages(
                    activity.activity!.activityID!
                )

                self.dataSource.setCurrentActivityImages(activityImages)

                await MainActor.run {

                    let analysisVC = ActivityAnalysisViewController()

                    analysisVC.activityData =
                    self.dataSource.getCurrentActivity()

                    let _ = analysisVC.view

                    if let mapURLStr = activity.activity?.mapImageURL,
                       let mapURL = URL(string: mapURLStr) {

                        KingfisherManager.shared.retrieveImage(
                            with: mapURL
                        ) { [weak self] result in

                            guard let self else { return }

                            let mapImage: UIImage? =
                            try? result.get().image

                            let card =
                            analysisVC.buildShareCardPublic(
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

                        let card =
                        analysisVC.buildShareCardPublic(mapImage: nil)

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

    // MARK: More Options
    
    @objc func didTapOnMoreOptions(_ sender: UIButton) {
        
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let shareAction = UIAlertAction(
            title: String(localized: "Share Activity"),
            style: .default
        )
        
        let deleteAction = UIAlertAction(
            title: String(localized: "Delete Activity"),
            style: .default
        ) { _ in
            self.updateScreenElements()
        }
        
        let cancelAction = UIAlertAction(
            title: String(localized: "Cancel"),
            style: .cancel
        )
        
        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // MARK: Update UI
    
    func updateScreenElements() {
        
        tableViewMyActivity.reloadData()
        
        if myActivity.isEmpty {
            
            label.isHidden = false
            
            let thinFont = UIFont(
                name: "SFProText-Thin",
                size: 22
            ) ?? UIFont.systemFont(ofSize: 22, weight: .thin)
            
            let boldFont = UIFont(
                name: "SFProText-Bold",
                size: 22
            ) ?? UIFont.boldSystemFont(ofSize: 22)
            
            if selectedFilterDate != nil {
                
                let line1 = NSMutableAttributedString(
                    string: "No activities recorded\n",
                    attributes: [
                        .font: thinFont,
                        .foregroundColor: UIColor.lightGray
                    ]
                )
                
                let line2thin = NSAttributedString(
                    string: "on ",
                    attributes: [
                        .font: thinFont,
                        .foregroundColor: UIColor.lightGray
                    ]
                )
                
                let line2bold = NSAttributedString(
                    string: "selected date",
                    attributes: [
                        .font: thinFont,
                        .foregroundColor: UIColor.lightGray
                    ]
                )
                
                line1.append(line2thin)
                line1.append(line2bold)
                
                label.attributedText = line1
                
            } else {
                
                let thinText = NSAttributedString(
                    string: "No ",
                    attributes: [
                        .font: thinFont,
                        .foregroundColor: UIColor.lightGray
                    ]
                )
                
                let boldText = NSAttributedString(
                    string: "Activities",
                    attributes: [
                        .font: boldFont,
                        .foregroundColor: UIColor.lightGray
                    ]
                )
                
                let completeText = NSMutableAttributedString()
                
                completeText.append(thinText)
                completeText.append(boldText)
                
                label.attributedText = completeText
            }
            
        } else {
            label.isHidden = true
        }
    }
}

// MARK: - Calendar Delegate

extension AllActivitiesViewController: CalendarViewControllerDelegate {
    
    func didSelectDate(_ date: Date) {
        selectedFilterDate = date
        updateScreenElements()
    }
    
    func didClearFilter() {
        selectedFilterDate = nil
        updateScreenElements()
    }
}
