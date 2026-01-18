import UIKit
import JTAppleCalendar

class InsightsScreenViewController: UIViewController {

    @IBOutlet weak var labelStreak: UILabel!
    @IBOutlet weak var labelTotalPoints: UILabel!
    @IBOutlet weak var collectionViewInsightsCards: UICollectionView!
    @IBOutlet weak var scrollViewInsights: UIScrollView!
    @IBOutlet weak var buttonUserProfile: UIButton!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    // JTAppleCalendar View
    private var calendarView: JTACMonthView!
    
    // Month/Year Label
    private let calendarHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Data source references
    var dataSource = DataSource.shared
    var myActivities: [MyRunActivity] {
        dataSource.getMyActivityData()
    }
    
    private var latestActivity: MyRunActivity?
    private var previousActivity: MyRunActivity?
    private var greenDates: Set<Date> = []

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
        buttonUserProfile.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        prepareActivities()
        prepareGreenDates() // Flames only for actual activity dates

        labelTotalPoints.text = "\(totalPoints)"

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

        if let layout = collectionViewInsightsCards.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }

        let nib = UINib(nibName: "InsightsScreenCollectionViewCell", bundle: nil)
        collectionViewInsightsCards.register(nib, forCellWithReuseIdentifier: "cell")
    }

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
        let sorted = myActivities.sorted { $0.timeStamp > $1.timeStamp }
        latestActivity = sorted.first
        previousActivity = sorted.count > 1 ? sorted[1] : nil
    }

    // MARK: - Green Dates Based on Actual Activities
    private func prepareGreenDates() {
        greenDates.removeAll()
        let calendar = Calendar.current
        for activity in myActivities {
            let activityDate = calendar.startOfDay(for: activity.timeStamp)
            greenDates.insert(activityDate)
        }
        calendarView.reloadData()
    }

    @IBAction func profileButtonPressed(_ sender: Any) {
        let destinationVC = UserProfileViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true)
    }

    // Trend Text
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

    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! CalendarDayCell
        self.configureCell(view: cell, cellState: cellState, date: date)
        return cell
    }

    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState, date: date)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        updateHeader(visibleDates: visibleDates)
    }

    private func configureCell(view: JTACDayCell?, cellState: CellState, date: Date) {
        guard let cell = view as? CalendarDayCell else { return }

        let calendar = Calendar.current
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
        
        switch indexPath.row {
        case 0: // Distance
            let current = latest?.distanceValue ?? 0
            cell.labelCardTitle.text = "Distance"
            cell.settingLabelStyle(withValue: String(format: "%.2f", current), withUnit: "km")
            cell.labelTrend.text = latest == nil ? "No recorded distance" : previous != nil ? trendText(current: current, previous: previous!.distanceValue, unit: "km") : "First run"
            updateChevron(cell: cell, current: latest?.distanceValue, previous: previous?.distanceValue)
            
        case 1: // Calories
            let current = Double(latest?.caloriesValue ?? 0)
            cell.labelCardTitle.text = "Calories"
            cell.settingLabelStyle(withValue: "\(Int(current))", withUnit: "kcal")
            cell.labelTrend.text = latest == nil ? "No recorded calories" : previous != nil ? trendText(current: current, previous: Double(previous!.caloriesValue), unit: "kcal") : "First run"
            updateChevron(cell: cell, current: current, previous: previous.map { Double($0.caloriesValue) })
            
        case 2: // Steps
            let current = Double(latest?.stepsValue ?? 0)
            cell.labelCardTitle.text = "Steps"
            cell.settingLabelStyle(withValue: "\(Int(current))", withUnit: "steps")
            cell.labelTrend.text = latest == nil ? "No recorded steps" : previous != nil ? trendText(current: current, previous: Double(previous!.stepsValue), unit: "steps") : "First run"
            updateChevron(cell: cell, current: current, previous: previous.map { Double($0.stepsValue) })
            
        case 3: // Average Pace
            let curMin = latest?.timeMin ?? 0
            let curSec = latest?.timeSec ?? 0
            let current = Double(curMin * 60 + curSec)
            cell.labelCardTitle.text = "Average Pace"
            let displayText = String(format: "%d:%02d", curMin, curSec)
            cell.settingLabelStyle(withValue: displayText, withUnit: "min/km")
            cell.labelTrend.text = latest == nil ? "No recorded pace" : previous != nil ? trendText(current: current, previous: Double(previous!.timeMin * 60 + previous!.timeSec), unit: "s") : "First run"
            updateChevron(cell: cell, current: latest.map { _ in current }, previous: previous.map { Double($0.timeMin * 60 + $0.timeSec) })
            
        default:
            break
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewControllers: [UIViewController] = [DistanceViewController(), CaloriesViewController(), StepsViewController(), AveragePaceViewController()]
        if indexPath.row < viewControllers.count {
            navigationController?.pushViewController(viewControllers[indexPath.row], animated: true)
        }
    }
}

// MARK: - Calendar Cell Class
class CalendarDayCell: JTACDayCell {
    let dateLabel = UILabel()
    let flameImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

