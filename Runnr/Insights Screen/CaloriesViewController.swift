import UIKit
import SwiftUI

class CaloriesViewController: UIViewController {

    //    @IBOutlet weak var weekRangeLabel: UILabel!
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var segmentControlCalories: UISegmentedControl!
    @IBOutlet weak var buttonWeekDates: UIButton!
    @IBOutlet weak var labelCaloriesBurnt: UILabel!
    @IBOutlet weak var collectionViewCalories: UICollectionView!
    @IBOutlet weak var viewGraphContainer: UIView!

    var graphStore: GraphManager?
    let dataSource = DataSource.shared
    private var hostingController: UIHostingController<CaloriesChartView>?
    private var userProfile = DataSource.shared.getUserProfile()

    private var selectedDate: Date = Date()
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentControlCalories.selectedSegmentIndex = 0
        graphStore?.selectedPeriod = .weekly

        updateDateDisplay()

        navigationItem.title = "Calories"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        //        collectionViewCalories.dataSource = self
        //        collectionViewCalories.delegate = self
        let nib = UINib(nibName: "TrendsCollectionViewCell", bundle: nil)
        collectionViewCalories.register(nib, forCellWithReuseIdentifier: "cell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionViewCalories.collectionViewLayout = layout

        segmentControlCalories.layer.borderWidth = 0.5
        segmentControlCalories.layer.borderColor = UIColor.accent.cgColor
        segmentControlCalories.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)

        settingLabelStyle()
        setupGraph()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateTopValueForSelectedSegment()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewMain.contentSize.height =
        collectionViewCalories.frame.height +
        collectionViewCalories.frame.origin.y + 100
    }

    @IBAction func buttonRangeClicked(_ sender: Any) {

        let alert = UIAlertController(title: "Select Date\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.date = selectedDate
        datePicker.maximumDate = Date()

        alert.view.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 60),
            datePicker.widthAnchor.constraint(equalToConstant: 250),
            datePicker.heightAnchor.constraint(equalToConstant: 180)
        ])

        let select = UIAlertAction(title: "Select", style: .default) { _ in
            Task {
                self.selectedDate = datePicker.date
                await self.graphStore!.loadData(userID: self.userProfile.userID!, referenceDate: self.selectedDate)
                self.updateDateDisplay()
                self.updateTopValueForSelectedSegment()
            }
        }

        alert.addAction(select)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    func updateDateDisplay() {

        let formatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)

        switch segmentControlCalories.selectedSegmentIndex {

        case 0: // Weekly
            graphStore?.selectedPeriod = .weekly

            let weekEnd = selectedDate
            guard let weekStart = calendar.date(byAdding: .day, value: -6, to: weekEnd) else { return }

            formatter.dateFormat = "d MMMM"

            let startString = formatter.string(from: weekStart)
            let endString = formatter.string(from: weekEnd)

            buttonWeekDates.setTitle("\(startString) - \(endString)", for: .normal)

        case 1: // Monthly
            graphStore?.selectedPeriod = .monthly

            formatter.dateFormat = "MMMM"
            buttonWeekDates.setTitle(formatter.string(from: selectedDate), for: .normal)

        case 2: // Yearly
            graphStore?.selectedPeriod = .yearly

            formatter.dateFormat = "yyyy"
            buttonWeekDates.setTitle(formatter.string(from: selectedDate), for: .normal)

        default:
            break
        }
    }

    func updateTopValueForSelectedSegment() {

        guard let graphStore = graphStore else { return }

        switch segmentControlCalories.selectedSegmentIndex {
        case 0:
            let total = dataSource.getWeeklyTotal(graphStore: graphStore).totalCalories
            labelNumber.text = "\(Int(total))"

        case 1:
            let total = dataSource.getMonthlyTotal(graphStore: graphStore).totalCalories
            labelNumber.text = "\(Int(total))"

        case 2:
            let total = dataSource.getYearlyTotal(graphStore: graphStore).totalCalories
            labelNumber.text = "\(Int(total))"

        default:
            break
        }
    }

    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        updateDateDisplay()
        updateTopValueForSelectedSegment()
    }

    func setupGraph() {
        //        let graphView = CaloriesChartView(store: graphStore ?? GraphManager())
        guard let graphStore = graphStore else { return }
        let graphView = CaloriesChartView(store: graphStore)

        let hc = UIHostingController(rootView: graphView)
        hostingController = hc

        addChild(hc)
        hc.view.translatesAutoresizingMaskIntoConstraints = false
        viewGraphContainer.addSubview(hc.view)

        NSLayoutConstraint.activate([
            hc.view.topAnchor.constraint(equalTo: viewGraphContainer.topAnchor),
            hc.view.bottomAnchor.constraint(equalTo: viewGraphContainer.bottomAnchor),
            hc.view.leadingAnchor.constraint(equalTo: viewGraphContainer.leadingAnchor),
            hc.view.trailingAnchor.constraint(equalTo: viewGraphContainer.trailingAnchor)
        ])

        hc.didMove(toParent: self)
    }

    func settingLabelStyle() {
        let mediumFont = UIFont.systemFont(ofSize: 15, weight: .bold)
        let thinFont = UIFont.systemFont(ofSize: 10)

        let titleText = NSAttributedString(
            string: "Calories Burnt ",
            attributes: [.font: mediumFont, .foregroundColor: UIColor.white]
        )
        let unitsText = NSAttributedString(
            string: "(Kcal)",
            attributes: [.font: thinFont, .foregroundColor: UIColor.white]
        )

        let fullText = NSMutableAttributedString()
        fullText.append(titleText)
        fullText.append(unitsText)
        labelCaloriesBurnt.attributedText = fullText

        // SAME CHANGE AS DISTANCE
        labelNumber.text = "--"
        labelNumber.textColor = UIColor.accent
        labelNumber.font = UIFont.systemFont(ofSize: 32, weight: .bold)
    }
}

// extension CaloriesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        caloriesBurntTrends.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: "cell",
//            for: indexPath
//        ) as! TrendsCollectionViewCell
//        cell.configureCell(with: caloriesBurntTrends[indexPath.row])
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: collectionView.frame.width, height: 90)
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        10
//    }
// }

// MARK: - Calories Graphs

struct CaloriesChartView: View {
    @ObservedObject var store: GraphManager

    var body: some View {
        ResponsiveBarChart(data: store.chartData(for: store.selectedPeriod, metric: .calories))
    }
}
