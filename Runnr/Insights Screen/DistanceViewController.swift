import UIKit
import SwiftUI

class DistanceViewController: UIViewController {
    
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var buttonWeekDates: UIButton!
    @IBOutlet weak var segmentControlDistance: UISegmentedControl!
    @IBOutlet weak var collectionViewDistance: UICollectionView!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelDistanceCovered: UILabel!
    @IBOutlet weak var weekRangeLabel: UILabel!
    @IBOutlet weak var viewGraphContainer: UIView!
    
    var graphStore: GraphManager? = nil
    let dataSource = DataSource.shared
    private var hostingController: UIHostingController<DistanceGraphView>?
    
    private var selectedDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDateDisplay()
        
        segmentControlDistance.selectedSegmentIndex = 0
        updateTopValueForSelectedSegment()
        
        
        navigationItem.title = "Distance"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
//        collectionViewDistance.dataSource = self
//        collectionViewDistance.delegate = self
        let nib = UINib(nibName: "TrendsCollectionViewCell", bundle: nil)
        collectionViewDistance.register(nib, forCellWithReuseIdentifier: "cell")
        
        segmentControlDistance.layer.borderWidth = 0.5
        segmentControlDistance.layer.borderColor = UIColor.accent.cgColor
        segmentControlDistance.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        
        settingLabelStyle()
        setupGraph()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewMain.contentSize.height =
        collectionViewDistance.frame.height +
        collectionViewDistance.frame.origin.y + 100
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

        switch segmentControlDistance.selectedSegmentIndex {

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

        switch segmentControlDistance.selectedSegmentIndex {
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
//            self.labelNumber.text = String(format: ".2f%", dataSource.getWeeklyTotal(graphStore: graphStore!).totalDistance)
//            
//            case 1:
//                graphStore?.selectedPeriod = .monthly
//            self.labelNumber.text = String(format: ".2f%", dataSource.getMonthlyTotal(graphStore: graphStore!).totalDistance)
//
//            case 2:
//                graphStore?.selectedPeriod = .yearly
//            self.labelNumber.text = String(format: ".2f%", dataSource.getYearlyTotal(graphStore: graphStore!).totalDistance)
//
//            default:
//                break
//            }
    }
    
    func setupGraph() {
        let graphView = DistanceGraphView(store: graphStore ?? GraphManager())

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
            string: "Distance Covered ",
            attributes: [.font: mediumFont, .foregroundColor: UIColor.white]
        )
        let unitsText = NSAttributedString(
            string: "(Km)",
            attributes: [.font: thinFont, .foregroundColor: UIColor.white]
        )
        
        let fullText = NSMutableAttributedString()
        fullText.append(titleText)
        fullText.append(unitsText)
        labelDistanceCovered.attributedText = fullText
        
        let boldFont = UIFont.systemFont(ofSize: 32, weight: .bold)
        let thin2Font = UIFont.systemFont(ofSize: 15)
        
        let numberText = NSAttributedString(
            string: "20.3 ",
            attributes: [.font: boldFont, .foregroundColor: UIColor.accent]
        )
        let unitText = NSAttributedString(
            string: "Km",
            attributes: [.font: thin2Font, .foregroundColor: UIColor.accent]
        )
        
        let fullTexts = NSMutableAttributedString()
        fullTexts.append(numberText)
        fullTexts.append(unitText)
        labelNumber.attributedText = fullTexts
    }

}

// MARK: - Collection View Settings

//extension DistanceViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//        
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        distanceTrends.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: "cell",
//            for: indexPath
//        ) as! TrendsCollectionViewCell
//        cell.configureCell(with: distanceTrends[indexPath.row])
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
//}

//MARK: - Distance Graph

struct DistanceGraphView: View {
    @ObservedObject var store: GraphManager

    var body: some View {
        let data = store.chartData(for: store.selectedPeriod, metric: .distance)
        ResponsiveBarChart(data: data)
    }
}
