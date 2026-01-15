import UIKit

class InsightsScreenViewController: UIViewController {

    @IBOutlet weak var labelStreak: UILabel!
    @IBOutlet weak var labelTotalPoints: UILabel!
    @IBOutlet weak var collectionViewInsightsCards: UICollectionView!
    @IBOutlet weak var scrollViewInsights: UIScrollView!
    @IBOutlet weak var buttonUserProfile: UIButton!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    private var calendarView: UICalendarView!

    var myActivities: [MyRunActivity] {
        DataSource.shared.getMyActivityData()
    }

    private var latestActivity: MyRunActivity?
    private var previousActivity: MyRunActivity?

    var dataSource = DataSource.shared
    var totalPoints: Int {
        dataSource.getTotalRunnrPoints()
    }

    // green dates derived from my activities
    private var greenDates: Set<Date> = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark

        setupScrollView()
        setupCollectionView()
        setupCalendar()
        
        self.buttonUserProfile.layer.cornerRadius = self.buttonUserProfile.layer.frame.height / 2
        self.buttonUserProfile.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        prepareActivities()
        prepareGreenDates()

        labelTotalPoints.text = "\(totalPoints)"

        collectionViewInsightsCards.reloadData()
        collectionViewInsightsCards.layoutIfNeeded()
        collectionViewHeightConstraint.constant =
            collectionViewInsightsCards.collectionViewLayout.collectionViewContentSize.height
    }

    // MARK: - Profile
    @IBAction func profileButtonPressed(_ sender: Any) {
        let destinationVC = UserProfileViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true)
    }

    // MARK: - Activity Preparation
    private func prepareActivities() {
        let sorted = myActivities.sorted { $0.timeStamp > $1.timeStamp }
        latestActivity = sorted.first
        previousActivity = sorted.count > 1 ? sorted[1] : nil
    }

    // MARK: - green dates from activity data
    private func prepareGreenDates() {
        let calendar = Calendar.current
        greenDates.removeAll()

        for activity in myActivities {
            let day = calendar.startOfDay(for: activity.timeStamp)
            greenDates.insert(day)
        }

        //refresh because sf symbol wasnt showing up instantly, needed to scroll to another month then back for it to show up.
        calendarView.reloadDecorations(
            forDateComponents: greenDates.map {
                calendar.dateComponents([.year, .month, .day], from: $0)
            },
            animated: false
        )
    }


    private func setupScrollView() {
        scrollViewInsights.alwaysBounceHorizontal = false
        scrollViewInsights.showsHorizontalScrollIndicator = false
        scrollViewInsights.isDirectionalLockEnabled = true
    }

    private func setupCollectionView() {
        collectionViewInsightsCards.dataSource = self
        collectionViewInsightsCards.delegate = self
        collectionViewInsightsCards.isScrollEnabled = false

        if let layout = collectionViewInsightsCards.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }

        let nib = UINib(nibName: "InsightsScreenCollectionViewCell", bundle: nil)
        collectionViewInsightsCards.register(nib, forCellWithReuseIdentifier: "cell")
    }

    // MARK: - Setup Calendar
    private func setupCalendar() {
        calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        scrollViewInsights.addSubview(calendarView)

        let selection = UICalendarSelectionSingleDate(delegate: self)
        selection.selectedDate =
            Calendar.current.dateComponents([.year, .month, .day], from: Date())

        calendarView.selectionBehavior = selection
        calendarView.delegate = self

        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: labelStreak.bottomAnchor, constant: 10),
            calendarView.leadingAnchor.constraint(equalTo: scrollViewInsights.contentLayoutGuide.leadingAnchor, constant: 25),
            calendarView.trailingAnchor.constraint(equalTo: scrollViewInsights.contentLayoutGuide.trailingAnchor, constant: -25),
            calendarView.widthAnchor.constraint(equalTo: scrollViewInsights.frameLayoutGuide.widthAnchor, constant: -50),
            calendarView.heightAnchor.constraint(equalToConstant: 450),
            calendarView.bottomAnchor.constraint(equalTo: scrollViewInsights.contentLayoutGuide.bottomAnchor, constant: -40)
        ])
    }

    // MARK: - Trend Text
    private func trendText(current: Double, previous: Double, unit: String) -> String {
        let diff = current - previous

        if diff > 0 {
            return "\(Int(diff)) \(unit) more than last run"
        } else if diff < 0 {
            return "\(Int(abs(diff))) \(unit) less than last run"
        } else {
            return "Same as last run"
        }
    }

    // MARK: - Update Chevron
    private func updateChevron(cell: InsightsScreenCollectionViewCell,
                               current: Double,
                               previous: Double) {

        if current > previous {
            cell.imageViewChevron.image =
                UIImage(systemName: "chevron.up.2")?
                .withTintColor(UIColor(red: 0.68, green: 0.97, blue: 0.27, alpha: 1),
                               renderingMode: .alwaysOriginal)
        } else if current < previous {
            cell.imageViewChevron.image =
                UIImage(systemName: "chevron.down.2")?
                .withTintColor(.red, renderingMode: .alwaysOriginal)
        } else {
            cell.imageViewChevron.image =
                UIImage(systemName: "minus")?
                .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        }
    }
}

// MARK: - Calendar Decorations
extension InsightsScreenViewController: UICalendarViewDelegate {

    func calendarView(_ calendarView: UICalendarView,
                      decorationFor dateComponents: DateComponents)
    -> UICalendarView.Decoration? {

        let calendar = Calendar.current
        guard let date = calendar.date(from: dateComponents) else { return nil }
        let normalized = calendar.startOfDay(for: date)

        if greenDates.contains(normalized) {
            let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
            let flame = UIImage(systemName: "flame.fill", withConfiguration: config)?
                .withTintColor(.orange, renderingMode: .alwaysOriginal)
            return flame.map { .image($0) }
        }
        return nil
    }
}

// MARK: - Calendar Selection
extension InsightsScreenViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate,
                       didSelectDate dateComponents: DateComponents?) { }
}

// MARK: - CollectionView
extension InsightsScreenViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        cardDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as! InsightsScreenCollectionViewCell
        
        let hasPrevious = previousActivity != nil
        
        switch indexPath.row {
            
        case 0: // Distance
            cell.labelCardTitle.text = "Distance"
            let current = latestActivity?.distanceValue ?? 0
            cell.settingLabelStyle(withValue: String(format: "%.2f", current), withUnit: "km")
            
            if hasPrevious {
                let previous = previousActivity!.distanceValue
                cell.labelTrend.text = trendText(current: current, previous: previous, unit: "km")
                updateChevron(cell: cell, current: current, previous: previous)
            } else {
                cell.labelTrend.text = "No recorded distance"
                cell.imageViewChevron.image = UIImage(systemName: "minus")
            }
            
        case 1: // Calories
            cell.labelCardTitle.text = "Calories"
            let current = Double(latestActivity?.caloriesValue ?? 0)
            cell.settingLabelStyle(withValue: "\(Int(current))", withUnit: "kcal")
            
            if hasPrevious {
                let previous = Double(previousActivity!.caloriesValue)
                cell.labelTrend.text = trendText(current: current, previous: previous, unit: "kcal")
                updateChevron(cell: cell, current: current, previous: previous)
            } else {
                cell.labelTrend.text = "No recorded calories"
                cell.imageViewChevron.image = UIImage(systemName: "minus")
            }
            
        case 2: // Steps
            cell.labelCardTitle.text = "Steps"
            let current = Double(latestActivity?.stepsValue ?? 0)
            cell.settingLabelStyle(withValue: "\(Int(current))", withUnit: "steps")
            
            if hasPrevious {
                let previous = Double(previousActivity!.stepsValue)
                cell.labelTrend.text = trendText(current: current, previous: previous, unit: "steps")
                updateChevron(cell: cell, current: current, previous: previous)
            } else {
                cell.labelTrend.text = "No recorded steps"
                cell.imageViewChevron.image = UIImage(systemName: "minus")
            }
            
        case 3: // Average Pace
            cell.labelCardTitle.text = "Average Pace"
            
            let curMin = latestActivity?.timeMin ?? 0
            let curSec = latestActivity?.timeSec ?? 0
            let currentTotal = curMin * 60 + curSec
            
            cell.settingLabelStyle(
                withValue: String(format: "%d:%02d", curMin, curSec),
                withUnit: "min/km"
            )
            
            if hasPrevious {
                let prevTotal = previousActivity!.timeMin * 60 + previousActivity!.timeSec
                let diff = prevTotal - currentTotal
                
                if diff > 0 {
                    cell.labelTrend.text = "\(diff)s faster than last run"
                    cell.imageViewChevron.image = UIImage(systemName: "chevron.up.2")
                } else if diff < 0 {
                    cell.labelTrend.text = "\(abs(diff))s slower than last run"
                    cell.imageViewChevron.image = UIImage(systemName: "chevron.down.2")
                } else {
                    cell.labelTrend.text = "Same as last run"
                    cell.imageViewChevron.image = UIImage(systemName: "minus")
                }
            } else {
                cell.labelTrend.text = "No recorded pace"
                cell.imageViewChevron.image = UIImage(systemName: "minus")
            }
            
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing: CGFloat = 10
        let width = (collectionView.bounds.width - spacing) / 2
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0: navigationController?.pushViewController(DistanceViewController(), animated: true)
            case 1: navigationController?.pushViewController(CaloriesViewController(), animated: true)
            case 2: navigationController?.pushViewController(StepsViewController(), animated: true)
            case 3: navigationController?.pushViewController(AveragePaceViewController(), animated: true)
            default: break }
    }
}
