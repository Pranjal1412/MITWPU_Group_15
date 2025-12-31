import UIKit

class InsightsScreenViewController: UIViewController {

    @IBOutlet weak var labelStreak: UILabel!
    @IBOutlet weak var collectionViewInsightsCards: UICollectionView!
    @IBOutlet weak var scrollViewInsights: UIScrollView!

    private var calendarView: UICalendarView!

    // GREEN dates → ORANGE FLAME
    let greenDates: [Date] = [
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
        Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
        Calendar.current.date(byAdding: .day, value: -6, to: Date())!,
        Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
        Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
        Calendar.current.date(byAdding: .day, value: -10, to: Date())!
    ]

    // RED dates (optional)
    let redDates: [Date] = [
        Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
        Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
        Calendar.current.date(byAdding: .day, value: -8, to: Date())!,
        Calendar.current.date(byAdding: .day, value: -11, to: Date())!
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark

        setupScrollView()
        setupCollectionView()
        setupCalendar()
    }

    // MARK: - ScrollView
    private func setupScrollView() {
        scrollViewInsights.alwaysBounceHorizontal = false
        scrollViewInsights.showsHorizontalScrollIndicator = false
        scrollViewInsights.isDirectionalLockEnabled = true
    }

    // MARK: - CollectionView
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

    // MARK: - Calendar
    private func setupCalendar() {
        calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        scrollViewInsights.addSubview(calendarView)

        let selection = UICalendarSelectionSingleDate(delegate: self)
        selection.selectedDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        calendarView.selectionBehavior = selection
        calendarView.delegate = self

        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: labelStreak.bottomAnchor, constant: 16),

            calendarView.leadingAnchor.constraint(
                equalTo: scrollViewInsights.contentLayoutGuide.leadingAnchor,
                constant: 25
            ),
            calendarView.trailingAnchor.constraint(
                equalTo: scrollViewInsights.contentLayoutGuide.trailingAnchor,
                constant: -25
            ),

            // Lock width to screen → no horizontal scroll
            calendarView.widthAnchor.constraint(
                equalTo: scrollViewInsights.frameLayoutGuide.widthAnchor,
                constant: -50
            ),

            // ✅ FIXED HEIGHT (prevents cut-off)
            calendarView.heightAnchor.constraint(equalToConstant: 450),

            // ✅ Defines scroll content height
            calendarView.bottomAnchor.constraint(
                equalTo: scrollViewInsights.contentLayoutGuide.bottomAnchor,
                constant: -40
            )
        ])
    }
}

// MARK: - Calendar Decorations
extension InsightsScreenViewController: UICalendarViewDelegate {

    func calendarView(_ calendarView: UICalendarView,
                      decorationFor dateComponents: DateComponents)
    -> UICalendarView.Decoration? {

        let calendar = Calendar.current
        guard let date = calendar.date(from: dateComponents) else { return nil }

        if greenDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
            let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
            let flame = UIImage(systemName: "flame.fill", withConfiguration: config)?
                .withTintColor(.orange, renderingMode: .alwaysOriginal)
            return .image(flame)
        }

        return nil
    }
}

// MARK: - Calendar Selection
extension InsightsScreenViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate,
                       didSelectDate dateComponents: DateComponents?) { }
}

// MARK: - CollectionView DataSource & Delegate
extension InsightsScreenViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return cardDataArray.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as! InsightsScreenCollectionViewCell

        cell.configureCell(with: cardDataArray[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let inset: CGFloat = 16
        let spacing: CGFloat = 10
        let width = (collectionView.bounds.width - inset - spacing) / 2
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let destinationVC = DistanceViewController()
            navigationController?.pushViewController(destinationVC, animated: true)
        }
        if indexPath.row == 1 {
            let destinationVC = CaloriesViewController()
            navigationController?.pushViewController(destinationVC, animated: true)
        }
        if indexPath.row == 2 {
            let destinationVC = StepsViewController()
            navigationController?.pushViewController(destinationVC, animated: true)
        }
        if indexPath.row == 3 {
            let destinationVC = AveragePaceViewController()
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

}

