import UIKit
import SwiftUI

class PaceViewController: UIViewController {

    @IBOutlet weak var weekRangeLabel: UILabel!
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var buttonWeekDates: UIButton!
    @IBOutlet weak var segmentControlAveragePace: UISegmentedControl!
    @IBOutlet weak var labelAveragePace: UILabel!
    @IBOutlet weak var collectionViewPace: UICollectionView!
    @IBOutlet weak var viewGraphContainer: UIView!
    
    var graphStore: GraphManager? = nil
    let dataSource = DataSource.shared
    private var hostingController: UIHostingController<PaceChartView>?
    
    private var selectedDate: Date = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDateDisplay()
        
        segmentControlAveragePace.selectedSegmentIndex = 0
        updateTopValueForSelectedSegment()

        navigationItem.title = "Average Pace"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        // Collection view setup
//        collectionViewPace.dataSource = self
//        collectionViewPace.delegate = self
        let nib = UINib(nibName: "TrendsCollectionViewCell", bundle: nil)
        collectionViewPace.register(nib, forCellWithReuseIdentifier: "cell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionViewPace.collectionViewLayout = layout

        segmentControlAveragePace.layer.borderWidth = 0.5
        segmentControlAveragePace.layer.borderColor = UIColor.accent.cgColor
        segmentControlAveragePace.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)

        settingLabelStyle()
        setupGraph()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewMain.contentSize.height = collectionViewPace.frame.height + collectionViewPace.frame.origin.y + 100
    }
    
    @IBAction func buttonRangeClicked(_ sender: Any) {

        let alert = UIAlertController(title: "Select Date\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)

            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            datePicker.date = selectedDate
            
            alert.view.addSubview(datePicker)

            NSLayoutConstraint.activate([
                datePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
                datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 60),
                datePicker.widthAnchor.constraint(equalToConstant: 250),
                datePicker.heightAnchor.constraint(equalToConstant: 180)
            ])

            let select = UIAlertAction(title: "Select", style: .default) { _ in
                self.selectedDate = datePicker.date
                self.updateDateDisplay()
            }

            alert.addAction(select)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            present(alert, animated: true)
    }

    
    func updateDateDisplay() {

        let formatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)

        switch segmentControlAveragePace.selectedSegmentIndex {

        case 0: // Rolling 7 days ending at selected date

            let weekEnd = selectedDate
            guard let weekStart = calendar.date(byAdding: .day, value: -6, to: weekEnd) else { return }

            formatter.dateFormat = "d MMMM"

            let startString = formatter.string(from: weekStart)
            let endString = formatter.string(from: weekEnd)

            buttonWeekDates.setTitle("\(startString) - \(endString)", for: .normal)

        case 1: // Monthly
            formatter.dateFormat = "MMMM"
            buttonWeekDates.setTitle(formatter.string(from: selectedDate), for: .normal)

        case 2: // Yearly
            formatter.dateFormat = "yyyy"
            buttonWeekDates.setTitle(formatter.string(from: selectedDate), for: .normal)

        default:
            break
        }
    }
    
    
    func updateTopValueForSelectedSegment() {

        guard let graphStore = graphStore else { return }

        switch segmentControlAveragePace.selectedSegmentIndex {
        case 0:
            labelNumber.text = String(dataSource.getWeeklyTotal(graphStore: graphStore).totalCalories)

        case 1:
            labelNumber.text = String(dataSource.getMonthlyTotal(graphStore: graphStore).totalCalories)

        case 2:
            labelNumber.text = String(dataSource.getYearlyTotal(graphStore: graphStore).totalCalories)

        default:
            break
        }
    }

    
    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        updateTopValueForSelectedSegment()
        updateDateDisplay()
//        switch sender.selectedSegmentIndex {
//            case 0:
//                graphStore?.selectedPeriod = .weekly
//                self.labelNumber.text = String(dataSource.getWeeklyTotal(graphStore: graphStore!).totalPace)
//            
//            case 1:
//                graphStore?.selectedPeriod = .monthly
//            self.labelNumber.text = String(dataSource.getMonthlyTotal(graphStore: graphStore!).totalPace)
//
//            case 2:
//                graphStore?.selectedPeriod = .yearly
//            self.labelNumber.text = String(dataSource.getYearlyTotal(graphStore: graphStore!).totalPace)
//
//            default:
//                break
//            }
    }
    
    func setupGraph() {
        let graphView = PaceChartView(store: graphStore ?? GraphManager())

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
        let mediumFont = UIFont(name: "SFProText-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .bold)
        let thinFont = UIFont(name: "SFProText-Light", size: 10) ?? UIFont.systemFont(ofSize: 10)
        let titleText = NSAttributedString(string: "Average Pace ", attributes: [.font: mediumFont, .foregroundColor: UIColor.white])
        let unitsText = NSAttributedString(string: "(min/km)", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        let fullText = NSMutableAttributedString()
        fullText.append(titleText)
        fullText.append(unitsText)
        labelAveragePace.attributedText = fullText

        let boldFont = UIFont(name: "SFProText-Bold", size: 32) ?? UIFont.systemFont(ofSize: 32, weight: .bold)
        let thin2Font = UIFont(name: "SFProText-Light", size: 15) ?? UIFont.systemFont(ofSize: 15)
        let numberText = NSAttributedString(string: "8:30 ", attributes: [.font: boldFont, .foregroundColor: UIColor(named: "AccentColor") ?? UIColor.white])
        let unitText = NSAttributedString(string: "min/km", attributes: [.font: thin2Font, .foregroundColor: UIColor(named: "AccentColor") ?? UIColor.white])
        let fullTexts = NSMutableAttributedString()
        fullTexts.append(numberText)
        fullTexts.append(unitText)
        labelNumber.attributedText = fullTexts
    }

}

//extension PaceViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return averagePaceTrends.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrendsCollectionViewCell
//        cell.configureCell(with: averagePaceTrends[indexPath.row])
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 90)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//}

struct PaceChartView: View {
    @ObservedObject var store: GraphManager

    var body: some View {
        ResponsiveBarChart(data: store.chartData(for: store.selectedPeriod, metric: .pace))
    }
}

