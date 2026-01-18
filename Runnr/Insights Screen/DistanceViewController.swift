import UIKit
import SwiftUI

class DistanceViewController: UIViewController {
    
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var segmentControlDistance: UISegmentedControl!
    @IBOutlet weak var collectionViewDistance: UICollectionView!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelDistanceCovered: UILabel!
    @IBOutlet weak var weekRangeLabel: UILabel!
    @IBOutlet weak var viewGraphContainer: UIView!
    
    private let graphStore = GraphDataStore()
    private var hostingController: UIHostingController<DistanceGraphView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Distance"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        collectionViewDistance.dataSource = self
        collectionViewDistance.delegate = self
        let nib = UINib(nibName: "TrendsCollectionViewCell", bundle: nil)
        collectionViewDistance.register(nib, forCellWithReuseIdentifier: "cell")
        
        segmentControlDistance.layer.borderWidth = 0.5
        segmentControlDistance.layer.borderColor = UIColor.accent.cgColor
        segmentControlDistance.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        
        settingLabelStyle()
        
        setupGraph()
        graphStore.data = weeklyDistance
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewMain.contentSize.height =
        collectionViewDistance.frame.height +
        collectionViewDistance.frame.origin.y + 100
    }
    
    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            case 0:
                graphStore.data = weeklyDistance
            case 1:
                graphStore.data = monthlyDistance
            case 2:
                graphStore.data = yearlyDistance
            default:
                break
            }
    }
    
    func setupGraph() {
        let graphView = DistanceGraphView(store: graphStore)

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
            string: "(km)",
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
            string: "km",
            attributes: [.font: thin2Font, .foregroundColor: UIColor.accent]
        )
        
        let fullTexts = NSMutableAttributedString()
        fullTexts.append(numberText)
        fullTexts.append(unitText)
        labelNumber.attributedText = fullTexts
    }

}

// MARK: - Collection View Settings

extension DistanceViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        distanceTrends.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as! TrendsCollectionViewCell
        cell.configureCell(with: distanceTrends[indexPath.row])
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

//MARK: - Distance Graph

struct DistanceGraphView: View {
    @ObservedObject var store: GraphDataStore

    var body: some View {
        ResponsiveBarChart(data: store.data)
    }
}
