//
//  InsightsScreenViewController.swift
//  Runnr
//
//  Created by SDC-USER on 18/11/25.
//

import UIKit

class InsightsScreenViewController: UIViewController,
                                    UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionViewInsightsCards: UICollectionView!
    @IBOutlet weak var labelStreak: UILabel!   // Streak label at (20, 575)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark
        
        // Delegates
        collectionViewInsightsCards.delegate = self
        collectionViewInsightsCards.dataSource = self
        
        // Register collection cell
        collectionViewInsightsCards.register(UINib(nibName: "InsightsScreenCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "InsightCardCell")
        
        // Layout for grid
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        collectionViewInsightsCards.collectionViewLayout = layout
        
        // ---- Calendar View (Position using FRAME) ----
        let calendarWidth = view.frame.width - 32   // 16 on left + 16 on right
        let calendarHeight: CGFloat = 350

        let calendarView = UICalendarView(
            frame: CGRect(x: 16, y: 615, width: calendarWidth, height: calendarHeight)
        )

        view.addSubview(calendarView)

        // Optional styling
        calendarView.calendar = Calendar.current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
    }

    // MARK: - Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InsightCardCell", for: indexPath) as! InsightsScreenCollectionViewCell
        
        let item = cardDataArray[indexPath.row]
        
        cell.labelUnits.text = item.units
        cell.imageViewTrendChevron.image = UIImage(named: item.trendChevron)
        cell.labelCardTitle.text = item.title
        cell.labelNumber.text = item.number
        cell.labelTrend.text = item.trend
        
        return cell
    }

    // MARK: - 2×2 Grid Layout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let columns: CGFloat = 2
        let spacing: CGFloat = 22
        let totalSpacing = (columns - 1) * spacing
        
        let width = (collectionView.bounds.width - totalSpacing) / columns
        let height = (collectionView.bounds.height - totalSpacing) / columns
        
        return CGSize(width: width, height: height)
    }
}

