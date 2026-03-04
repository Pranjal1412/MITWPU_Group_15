import UIKit
import SwiftUI

class CaloriesViewController: UIViewController {

    @IBOutlet weak var weekRangeLabel: UILabel!
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var segmentControlCalories: UISegmentedControl!
    @IBOutlet weak var labelCaloriesBurnt: UILabel!
    @IBOutlet weak var collectionViewCalories: UICollectionView!
    @IBOutlet weak var viewGraphContainer: UIView!
    
    var graphStore: GraphDataStore? = nil
    let dataSource = DataSource.shared
    private var hostingController: UIHostingController<CaloriesChartView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Calories"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        collectionViewCalories.dataSource = self
        collectionViewCalories.delegate = self
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewMain.contentSize.height =
        collectionViewCalories.frame.height +
        collectionViewCalories.frame.origin.y + 100
    }

    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            case 0:
                graphStore?.selectedPeriod = .weekly
                self.labelNumber.text = String(dataSource.getWeeklyTotal(graphStore: graphStore!).totalCalories)
            
            case 1:
                graphStore?.selectedPeriod = .monthly
            self.labelNumber.text = String(dataSource.getMonthlyTotal(graphStore: graphStore!).totalCalories)

            case 2:
                graphStore?.selectedPeriod = .yearly
            self.labelNumber.text = String(dataSource.getYearlyTotal(graphStore: graphStore!).totalCalories)

            default:
                break
            }
    }
    
    func setupGraph() {
        let graphView = CaloriesChartView(store: graphStore ?? GraphDataStore())

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

        let boldFont = UIFont.systemFont(ofSize: 32, weight: .bold)
        let thin2Font = UIFont.systemFont(ofSize: 15)

        let numberText = NSAttributedString(
            string: "230 ",
            attributes: [.font: boldFont, .foregroundColor: UIColor.accent]
        )
        let unitText = NSAttributedString(
            string: "Kcal",
            attributes: [.font: thin2Font, .foregroundColor: UIColor.accent]
        )

        let fullTexts = NSMutableAttributedString()
        fullTexts.append(numberText)
        fullTexts.append(unitText)
        labelNumber.attributedText = fullTexts
    }

}

extension CaloriesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        caloriesBurntTrends.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as! TrendsCollectionViewCell
        cell.configureCell(with: caloriesBurntTrends[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 90)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

//MARK: - Calories Graphs

struct CaloriesChartView: View {
    @ObservedObject var store: GraphDataStore

    var body: some View {
        ResponsiveBarChart(data: store.chartData(for: store.selectedPeriod, metric: .calories))
    }
}

