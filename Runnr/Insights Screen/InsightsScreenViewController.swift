import UIKit
import JTAppleCalendar
import Kingfisher

class InsightsScreenViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelStreak: UILabel!
    @IBOutlet weak var labelTotalPoints: UILabel!
    @IBOutlet weak var collectionViewInsightsCards: UICollectionView!
    @IBOutlet weak var scrollViewInsights: UIScrollView!
    @IBOutlet weak var buttonUserProfile: UIButton!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    private let calendarHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var myActivities: [UserActivity] {
        dataSource.getAllActivities()
    }
    
    private var calendarView: JTACMonthView!
    private var dataSource = DataSource.shared
    private var userProfile = DataSource.shared.getUserProfile()
    private var latestActivity: UserActivity?
    private var previousActivity: UserActivity?
    private var greenDates: Set<Date> = []
    
    private var graphStore = GraphDataStore()

    var totalPoints: Int {
        dataSource.getTotalRunnrPoints()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark

        setupScrollView()
        setupCollectionView()
        setupCalendar()
        
        buttonUserProfile.layer.cornerRadius = buttonUserProfile.frame.height / 2
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
        self.profileImage.clipsToBounds = true
        buttonUserProfile.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let profileImageURL = DataSource.shared.getUserProfile().userProfileImageURL

        if let url = URL(string: profileImageURL!) {
            self.profileImage.kf.setImage(with: url)
        }

        labelTotalPoints.text = "\(totalPoints)"

        if myActivities.isEmpty {
            Task {
                let activities = await fetchAllMyActivities(userID: userProfile.userID!)
                self.dataSource.setAllActivities(activities)
            }
        }
        
        Task {
            await graphStore.loadData(userID: userProfile.userID!)
        }

        prepareActivities()
        prepareGreenDates()
        collectionViewInsightsCards.reloadData()
        collectionViewInsightsCards.layoutIfNeeded()
        collectionViewHeightConstraint.constant = collectionViewInsightsCards.collectionViewLayout.collectionViewContentSize.height
    }

    // MARK: - Setup Methods
    private func setupScrollView() {
        scrollViewInsights.alwaysBounceHorizontal = false
        scrollViewInsights.showsHorizontalScrollIndicator = false
        scrollViewInsights.isDirectionalLockEnabled = true
    }

    private func setupCollectionView() {
        collectionViewInsightsCards.dataSource = self
        collectionViewInsightsCards.delegate = self
        collectionViewInsightsCards.isScrollEnabled = false

//        if let layout = collectionViewInsightsCards.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .vertical
//        }

        let nib = UINib(nibName: "InsightsScreenCollectionViewCell", bundle: nil)
        collectionViewInsightsCards.register(nib, forCellWithReuseIdentifier: "cell")
    }

    @IBAction func profileButtonPressed(_ sender: Any) {
        let destinationVC = UserProfileViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true)
    }

    private func trendText(current: Double, previous: Double, unit: String) -> String {
        let diff = current - previous
        if diff > 0 { return "\(Int(diff)) \(unit) more than last run" }
        else if diff < 0 { return "\(Int(abs(diff))) \(unit) less than last run" }
        else { return "Same as last run" }
    }

    private func updateChevron(cell: InsightsScreenCollectionViewCell, current: Double?, previous: Double?) {
        guard let current = current, let previous = previous else {
            cell.imageViewChevron.image = UIImage(systemName: "minus")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            return
        }
        
        if current > previous {
            cell.imageViewChevron.image = UIImage(systemName: "chevron.up.2")?
                .withTintColor(UIColor(red: 0.68, green: 0.97, blue: 0.27, alpha: 1), renderingMode: .alwaysOriginal)
        } else if current < previous {
            cell.imageViewChevron.image = UIImage(systemName: "chevron.down.2")?
                .withTintColor(.red, renderingMode: .alwaysOriginal)
        } else {
            cell.imageViewChevron.image = UIImage(systemName: "minus")?
                .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        }
    }
}

// MARK: - JTAppleCalendar Delegate & DataSource
extension InsightsScreenViewController: JTACMonthViewDelegate, JTACMonthViewDataSource {
    
    private func setupCalendar() {
        calendarView = JTACMonthView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.backgroundColor = .clear
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachSection
        
        calendarView.register(CalendarDayCell.self, forCellWithReuseIdentifier: "dateCell")
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        
        scrollViewInsights.addSubview(calendarHeaderLabel)
        scrollViewInsights.addSubview(calendarView)

        NSLayoutConstraint.activate([
            // Header Position
            calendarHeaderLabel.topAnchor.constraint(equalTo: labelStreak.bottomAnchor, constant: 20),
            calendarHeaderLabel.leadingAnchor.constraint(equalTo: scrollViewInsights.contentLayoutGuide.leadingAnchor, constant: 25),
            
            // Calendar Position
            calendarView.topAnchor.constraint(equalTo: calendarHeaderLabel.bottomAnchor, constant: 10),
            calendarView.leadingAnchor.constraint(equalTo: scrollViewInsights.contentLayoutGuide.leadingAnchor, constant: 25),
            calendarView.trailingAnchor.constraint(equalTo: scrollViewInsights.contentLayoutGuide.trailingAnchor, constant: -25),
            calendarView.widthAnchor.constraint(equalTo: scrollViewInsights.frameLayoutGuide.widthAnchor, constant: -50),
            calendarView.heightAnchor.constraint(equalToConstant: 300),
            calendarView.bottomAnchor.constraint(equalTo: scrollViewInsights.contentLayoutGuide.bottomAnchor, constant: -40)
        ])
        
        // Initialize header text
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.visibleDates { (visibleDates) in
            self.updateHeader(visibleDates: visibleDates)
        }
    }

    private func updateHeader(visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        calendarHeaderLabel.text = formatter.string(from: date)
    }

    private func prepareActivities() {
        let sorted = myActivities.sorted { $0.activityStartTime! > $1.activityStartTime! }
        latestActivity = sorted.first
        previousActivity = sorted.count > 1 ? sorted[1] : nil
    }

    // MARK: Green Dates Based on Actual Activities
    private func prepareGreenDates() {
        greenDates.removeAll() //revents old or duplicate dates, empties the set
        let calendar = Calendar.current
        for activity in myActivities {
            let activityDate = calendar.startOfDay(for: activity.activityStartTime!)
            /* Removes time (hours, minutes, seconds)
             2026-01-21 18:42 → 2026-01-21 00:00
             */
            greenDates.insert(activityDate)
        }
        calendarView.reloadData()
    }

    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2024 01 01")!
        let endDate = formatter.date(from: "2026 12 31")!
        
        return ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            numberOfRows: 6,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid
        )
    }
    
    //create and configure cell
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! CalendarDayCell
        self.configureCell(view: cell, cellState: cellState, date: date)
        return cell
    }
    
    //reapply UI before showing (for final correctness)
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState, date: date)
    }
    
    //to update month header
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        updateHeader(visibleDates: visibleDates)
    }

    private func configureCell(view: JTACDayCell?, cellState: CellState, date: Date) {
        guard let cell = view as? CalendarDayCell else { return }

        let calendar = Calendar.current
        //normalized date: A date where the time part is removed, so only the calendar day matters.
        let normalizedDate = calendar.startOfDay(for: date)
        let today = calendar.startOfDay(for: Date())

        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.text = cellState.text

            if normalizedDate == today {
                cell.dateLabel.textColor = UIColor(red: 173/255, green: 248/255, blue: 69/255, alpha: 1)
            } else {
                cell.dateLabel.textColor = .white
            }

            // Flame only if activity exists
            if greenDates.contains(normalizedDate) {
                cell.flameImageView.alpha = 1.0
                cell.dateLabel.font = .systemFont(ofSize: 16, weight: .bold)
            } else {
                cell.flameImageView.alpha = 0
                cell.dateLabel.font = .systemFont(ofSize: 16, weight: .medium)
            }

        } else {
            cell.dateLabel.text = ""
            cell.flameImageView.alpha = 0
        }
    }
}

// MARK: - CollectionView Extension
extension InsightsScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 4 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InsightsScreenCollectionViewCell
        let latest = latestActivity
        let previous = previousActivity
        
        if latest != nil && previous != nil {
            
            switch indexPath.row {
            case 0: // Distance
                let current = latest!.distanceCovered
                cell.labelCardTitle.text = "Distance"
                cell.settingLabelStyle(withValue: String(format: "%.2f", current!), withUnit: "Km")
                cell.labelTrend.text = trendText(current: current!, previous: previous!.distanceCovered!, unit: "Km")
                updateChevron(cell: cell, current: latest?.distanceCovered, previous: previous?.distanceCovered)
                
            case 1: // Calories
                let current = Double(latest?.caloriesBurnt ?? 0)
                cell.labelCardTitle.text = "Calories"
                cell.settingLabelStyle(withValue: "\(Int(current))", withUnit: "Kcal")
                cell.labelTrend.text = latest == nil ? "No recorded calories" : previous != nil ? trendText(current: current, previous: Double(previous!.caloriesBurnt!), unit: "Kcal") : "First run"
                updateChevron(cell: cell, current: current, previous: previous.map { Double($0.caloriesBurnt!) })
                
            case 2: // Steps
                let current = Double(latest!.stepsTaken ?? 0)
                cell.labelCardTitle.text = "Steps"
                cell.settingLabelStyle(withValue: "\(Int(current))", withUnit: "steps")
                cell.labelTrend.text = trendText(current: current, previous: Double(previous!.stepsTaken!), unit: "steps")
                updateChevron(cell: cell, current: current, previous: previous.map { Double($0.stepsTaken!) })
                
            case 3: // Average Pace
                let newFormattedTime = formatTime((latest?.timeTakenSeconds!)!)
                let formattedTime = formatTime((previous?.timeTakenSeconds!)!)
                
                let curMin = newFormattedTime.minute
                let curSec = newFormattedTime.second
                let current = Double(curMin * 60 + curSec)
                cell.labelCardTitle.text = "Average Pace"
                let displayText = String(format: "%d:%02d", curMin, curSec)
                cell.settingLabelStyle(withValue: displayText, withUnit: "min/km")
                cell.labelTrend.text = trendText(current: current, previous: Double(formattedTime.minute * 60 + formattedTime.second), unit: "s")
                //            updateChevron(cell: cell, current: latest.map { _ in current }, previous: previous.map { Double($0.timeMin * 60 + $0.timeSec) })
                
            default:
                break
            }
        }
        else {
            switch indexPath.row {
            case 0: // Distance
                cell.labelCardTitle.text = "Distance"
                
                if latest == nil {
                    cell.labelTrend.text = "No recorded distance"
                    let current = 0
                    cell.settingLabelStyle(withValue: String(format: "%.2f", current), withUnit: "Km")
                }
                else {
                    cell.labelTrend.text = "First run"
                    let current = latest!.distanceCovered!
                    cell.settingLabelStyle(withValue: String(format: "%.2f", current), withUnit: "Km")
                }
                
                updateChevron(cell: cell, current: latest?.distanceCovered, previous: previous?.distanceCovered)
                
            case 1: // Calories
                cell.labelCardTitle.text = "Calories"
                
                if latest == nil {
                    cell.labelTrend.text = "No recorded calories"
                    let current = 0.0
                    cell.settingLabelStyle(withValue: String(format: "%.2f", current), withUnit: "Kcal")
                    updateChevron(cell: cell, current: current, previous: previous.map { Double($0.caloriesBurnt!)})
                }
                else {
                    cell.labelTrend.text = "First run"
                    let current = latest!.caloriesBurnt!
                    cell.settingLabelStyle(withValue: String(format: "%.2f", current), withUnit: "Kcal")
                    updateChevron(cell: cell, current: Double(current), previous: previous.map { Double($0.caloriesBurnt!)})
                }
                
                
            case 2: // Steps
                cell.labelCardTitle.text = "Steps"
                
                if latest == nil {
                    cell.labelTrend.text = "No recorded steps"
                    let current = 0.0
                    cell.settingLabelStyle(withValue: String(format: "%.2f", current), withUnit: "steps")
                    updateChevron(cell: cell, current: current, previous: previous.map { Double($0.stepsTaken!)})
                }
                else {
                    cell.labelTrend.text = "First run"
                    let current = latest!.stepsTaken!
                    cell.settingLabelStyle(withValue: String(format: "%.2f", current), withUnit: "steps")
                    updateChevron(cell: cell, current: Double(current), previous: previous.map { Double($0.stepsTaken!)})
                }
                
                
            case 3: // Average Pace
                cell.labelCardTitle.text = "Average Pace"
                
                if latest == nil {
                    cell.labelTrend.text = "No recorded pace"
                    let current = 0.0
                    cell.settingLabelStyle(withValue: "0:00", withUnit: "min/km")
                    updateChevron(cell: cell,
                                  current: current,
                                  previous: previous.map {
                                      Double(formatTime($0.timeTakenSeconds ?? 0).minute * 60 +
                                             formatTime($0.timeTakenSeconds ?? 0).second)
                                  })
                }
                else {
                    let formatted = formatTime(latest!.timeTakenSeconds ?? 0)
                    let curMin = formatted.minute
                    let curSec = formatted.second
                    let current = Double(curMin * 60 + curSec)
                    
                    let displayText = String(format: "%d:%02d", curMin, curSec)
                    cell.settingLabelStyle(withValue: displayText, withUnit: "min/km")
                    
                    if previous == nil {
                        cell.labelTrend.text = "First run"
                        updateChevron(cell: cell, current: current, previous: nil)
                    } else {
                        let prevFormatted = formatTime(previous!.timeTakenSeconds ?? 0)
                        let prevSeconds = Double(prevFormatted.minute * 60 + prevFormatted.second)
                        
                        cell.labelTrend.text = trendText(current: current,
                                                         previous: prevSeconds,
                                                         unit: "s")
                        
                        updateChevron(cell: cell,
                                      current: current,
                                      previous: prevSeconds)
                    }
                }
                
            default:
                break
            }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             

        }
        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let destinationVC = DistanceViewController()
            destinationVC.graphStore = self.graphStore
            navigationController?.pushViewController(destinationVC, animated: true)
        case 1:
            let destinationVC = CaloriesViewController()
            destinationVC.graphStore = self.graphStore
            navigationController?.pushViewController(destinationVC, animated: true)
        case 2:
            let destinationVC = StepsViewController()
            destinationVC.graphStore = self.graphStore
            navigationController?.pushViewController(destinationVC, animated: true)
        case 3:
            let destinationVC = PaceViewController()
            destinationVC.graphStore = self.graphStore
            navigationController?.pushViewController(destinationVC, animated: true)
        default:
            break
        }
    }
}

// MARK: - Calendar Cell Class
class CalendarDayCell: JTACDayCell {
    let dateLabel = UILabel()
    let flameImageView = UIImageView()

    override init(frame: CGRect) {
        /*
        JTACDayCell already has an init frame,replacing(overriding) to add your own setup
         JTACDayCell inheritance chain is : JTACDayCell -> UICollectionViewCell -> UIView
         UIView already defines an initializer: init(frame: CGRect)
         which means every Every UIView
         Every UICollectionViewCell
         Every JTACDayCell
         automatically has init(frame:), even if you never write it yourself.
         So JTACDayCell doesn’t “create” it — it inherits it from UIKit.
         */
        super.init(frame: frame)
        /*
        1)creates space in memory to store this view,
        2)UIKit sets up all the hidden machinery every view needs: Touch handling
        Drawing system
        Layout system
        Event system
        Sets frame, bounds, layer, etc.
        3) UIKit sets:
         frame → where the view is on screen
         bounds → its internal coordinate system
         layer → the visual backing (rounded corners, shadows, borders)
         */
        
        setupUI()
    }
    
    
    //init(coder:) is the initializer used when a view is loaded from a storyboard or XIB.

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        /*
         init(coder:) is required by UIKit for storyboard-based views, and we include it with fatalError only to satisfy the compiler and to crash loudly if someone accidentally uses the wrong initialization path.
         */
    }

    private func setupUI() {
        // Flame Image
        flameImageView.contentMode = .scaleAspectFit
        flameImageView.image = UIImage(systemName: "flame.fill")
        flameImageView.tintColor = .orange
        flameImageView.alpha = 0

        // Date Label
        dateLabel.textAlignment = .center
        dateLabel.textColor = .white
        dateLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        contentView.addSubview(flameImageView)
        contentView.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        flameImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Flame Image constraints
            flameImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            flameImageView.topAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -12),
            flameImageView.widthAnchor.constraint(equalToConstant: 12),
            flameImageView.heightAnchor.constraint(equalToConstant: 12),

            // Date Label constraints
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        flameImageView.alpha = 0
        dateLabel.text = ""
    }
}

