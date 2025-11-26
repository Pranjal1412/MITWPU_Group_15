//
//  InsightsScreenViewController 2.swift
//  Runnr
//
//  Created by SDC-USER on 19/11/25.
//

import UIKit

class InsightsScreenViewController: UIViewController {

    @IBOutlet weak var labelStreak: UILabel!
    @IBOutlet weak var collectionViewInsightsCards: UICollectionView!
    @IBOutlet weak var scrollViewInsights: UIScrollView!
    
    private var calendarView: UICalendarView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark

        collectionViewInsightsCards.dataSource = self
        collectionViewInsightsCards.delegate = self

        let nib = UINib(nibName: "InsightsScreenCollectionViewCell", bundle: nil)
        collectionViewInsightsCards.register(nib, forCellWithReuseIdentifier: "cell")
        
        calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.frame.origin.x = scrollViewInsights.frame.origin.x + 25
        calendarView.frame.origin.y = labelStreak.frame.width + labelStreak.frame.origin.y
        
        scrollViewInsights.addSubview(calendarView)

        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: labelStreak.bottomAnchor, constant: 0),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            calendarView.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        scrollViewInsights.contentSize = CGSize(width: view.frame.width, height: calendarView.frame.origin.y + calendarView.frame.height + 100)
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
        
        if cell.imageViewChevron.image == UIImage(systemName: "chevron.up.2") {
            cell.imageViewChevron.tintColor = .accent
        }
        else {
            cell.imageViewChevron.tintColor = .blue
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let finalWidth = (collectionViewInsightsCards.bounds.width - 20.0) / 2.0
        let finalHeight = finalWidth
        
        let totalRow = CGFloat(cardDataArray.count / 2)
        collectionViewInsightsCards.frame.size.height = (finalHeight * totalRow) + 20.0
        
        return CGSize(width: finalWidth, height: finalHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}



