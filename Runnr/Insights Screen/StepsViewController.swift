import UIKit
import SwiftUI

class StepsViewController: UIViewController {

    @IBOutlet weak var segmentControlSteps: UISegmentedControl!
    @IBOutlet weak var collectionViewSteps: UICollectionView!
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var labelStepsCovered: UILabel!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var viewGraphContainer: UIView!
    @IBOutlet weak var weekRangeLabel: UILabel!

    var graphStore: GraphDataStore? = nil
    let dataSource = DataSource.shared
    private var hostingController: UIHostingController<StepsChartView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Steps"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        collectionViewSteps.dataSource = self
        collectionViewSteps.delegate = self
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewMain.contentSize.height =
        collectionViewSteps.frame.height + collectionViewSteps.frame.origin.y + 100
    }

    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            case 0:
                graphStore?.selectedPeriod = .weekly
            self.labelNumber.text = String(format: ".2f%", dataSource.getWeeklyTotal(graphStore: graphStore!).totalSteps)
            
            case 1:
                graphStore?.selectedPeriod = .monthly
            self.labelNumber.text = String(dataSource.getMonthlyTotal(graphStore: graphStore!).totalSteps)

            case 2:
                graphStore?.selectedPeriod = .yearly
            self.labelNumber.text = String(dataSource.getYearlyTotal(graphStore: graphStore!).totalSteps)

            default:
                break
            }
    }
    
    func setupGraph() {
        let graphView = StepsChartView(store: graphStore ?? GraphDataStore())

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

        let boldFont = UIFont.systemFont(ofSize: 32, weight: .bold)
        let thin2Font = UIFont.systemFont(ofSize: 15)

        let numberText = NSAttributedString(
            string: "8000 ",
            attributes: [.font: boldFont, .foregroundColor: UIColor.accent]
        )
        let unit2Text = NSAttributedString(
            string: "k",
            attributes: [.font: thin2Font, .foregroundColor: UIColor.accent]
        )

        let fullNumber = NSMutableAttributedString()
        fullNumber.append(numberText)
        fullNumber.append(unit2Text)
        labelNumber.attributedText = fullNumber
    }

}

// MARK: - Collection View
extension StepsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stepsCoveredTrends.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrendsCollectionViewCell
        cell.configureCell(with: stepsCoveredTrends[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 90)
    }
}

//MARK: - Steps Graph

struct StepsChartView: View {
    @ObservedObject var store: GraphDataStore
    
    var body: some View {
        ResponsiveBarChart(data: store.chartData(for: store.selectedPeriod, metric: .steps))
    }
}

