import UIKit
import SwiftUI

class StepsViewController: UIViewController {

    @IBOutlet weak var segmentControlSteps: UISegmentedControl!
    @IBOutlet weak var collectionViewSteps: UICollectionView!
    @IBOutlet weak var buttonWeekDates: UIButton!
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var labelStepsCovered: UILabel!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var viewGraphContainer: UIView!
    @IBOutlet weak var weekRangeLabel: UILabel!

    var graphStore: GraphManager?
    let dataSource = DataSource.shared
    private var hostingController: UIHostingController<StepsChartView>?
    private var userProfile = DataSource.shared.getUserProfile()

    private var selectedDate: Date = Date()
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentControlSteps.selectedSegmentIndex = 0
        graphStore?.selectedPeriod = .weekly

        updateDateDisplay()

        navigationItem.title = "Steps"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        //        collectionViewSteps.dataSource = self
        //        collectionViewSteps.delegate = self
        let nib = UINib(nibName: "TrendsCollectionViewCell", bundle: nil)
        collectionViewSteps.register(nib, forCellWithReuseIdentifier: "cell")

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionViewSteps.collectionViewLayout = layout

        segmentControlSteps.layer.borderWidth = 0.5
        segmentControlSteps.layer.borderColor = UIColor.accent.cgColor
        segmentControlSteps.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)

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
        collectionViewSteps.frame.height + collectionViewSteps.frame.origin.y + 100
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
            }
        }

        alert.addAction(select)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    func updateDateDisplay() {

        let formatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)

        switch segmentControlSteps.selectedSegmentIndex {

        case 0: // Rolling 7 days ending at selected date
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

        let total: Double

        switch segmentControlSteps.selectedSegmentIndex {
        case 0:
            total = dataSource.getWeeklyTotal(graphStore: graphStore).totalSteps
        case 1:
            total = dataSource.getMonthlyTotal(graphStore: graphStore).totalSteps
        case 2:
            total = dataSource.getYearlyTotal(graphStore: graphStore).totalSteps
        default:
            return
        }

        DispatchQueue.main.async {
            self.labelNumber.text = "\(Int(total))"        }
    }

    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        updateDateDisplay()
        updateTopValueForSelectedSegment()
    }

    func setupGraph() {
        //        let graphView = StepsChartView(store: graphStore ?? GraphManager())
        guard let graphStore = graphStore else { return }
        let graphView = StepsChartView(store: graphStore)

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
            string: "Steps Covered ",
            attributes: [.font: mediumFont, .foregroundColor: UIColor.white]
        )
        let unitText = NSAttributedString(
            string: "(k)",
            attributes: [.font: thinFont, .foregroundColor: UIColor.white]
        )

        let fullTitle = NSMutableAttributedString()
        fullTitle.append(titleText)
        fullTitle.append(unitText)
        labelStepsCovered.attributedText = fullTitle

        // SAME CHANGE (placeholder)
        let boldFont = UIFont.systemFont(ofSize: 32, weight: .bold)

        labelNumber.text = "--"
        labelNumber.textColor = UIColor.accent
        labelNumber.font = boldFont
    }
}

// MARK: - Collection View
// extension StepsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        stepsCoveredTrends.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrendsCollectionViewCell
//        cell.configureCell(with: stepsCoveredTrends[indexPath.row])
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: collectionView.frame.width, height: 90)
//    }
// }

// MARK: - Steps Graph

struct StepsChartView: View {
    @ObservedObject var store: GraphManager

    var body: some View {
        ResponsiveBarChart(data: store.chartData(for: store.selectedPeriod, metric: .steps))
    }
}
