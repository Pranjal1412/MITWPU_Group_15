import UIKit

class InsightsScreenViewController: UIViewController {

    @IBOutlet weak var labelStreak: UILabel!
    @IBOutlet weak var collectionViewInsightsCards: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark

        collectionViewInsightsCards.delegate = self
        collectionViewInsightsCards.dataSource = self

        let nib = UINib(nibName: "InsightsScreenCollectionViewCell", bundle: nil)
        collectionViewInsightsCards.register(nib, forCellWithReuseIdentifier: "cell")
    }
}

extension InsightsScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InsightsScreenCollectionViewCell
        
        let data = cardDataArray[indexPath.row]
        
        cell.labelNumber.text = data.number
        cell.labelUnits.text = data.units
        cell.labelCardTitle.text = data.title
        cell.labelTrend.text = data.trend
        cell.imageViewChevron.image = UIImage(systemName: data.trendChevron)
        
        return cell
    }
    
    // MARK: Equal Vertical + Horizontal Spacing (2×2 Grid)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

//        let columns: CGFloat = 2
//        let spacing: CGFloat = 12
//
//        // total horizontal spacing = left + middle + right
//        let totalHorizontalSpacing = (columns + 1) * spacing
//
//        let width = (collectionView.bounds.width - totalHorizontalSpacing) / columns
//
//        return CGSize(width: width, height: width)   // square cards
        let finalWidth = (collectionView.bounds.width - 20.0) / 2.0
        let finalHeight = finalWidth
        let totalRow = CGFloat(cardDataArray.count / 2)
        collectionViewInsightsCards.frame.size.height = (finalHeight * totalRow) + 20.0
        return CGSize(width: finalWidth, height: finalHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20   // vertical spacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20   // horizontal spacing
    }

    }
    

