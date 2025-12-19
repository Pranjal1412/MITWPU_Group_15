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

    // GREEN dates → ORANGE FLAME
        let greenDates: [Date] = [
            Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
            Calendar.current.date(byAdding: .day, value: -6, to: Date())!,
            Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
            Calendar.current.date(byAdding: .day, value: -10, to: Date())!
        ]

        // RED dates → RED DOT
        let redDates: [Date] = [
            Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
            Calendar.current.date(byAdding: .day, value: -8, to: Date())!,
            Calendar.current.date(byAdding: .day, value: -11, to: Date())!
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark

        collectionViewInsightsCards.dataSource = self
        collectionViewInsightsCards.delegate = self

        // Force vertical scrolling only → stops horizontal scroll
        (collectionViewInsightsCards.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .vertical

        let nib = UINib(nibName: "InsightsScreenCollectionViewCell", bundle: nil)
        collectionViewInsightsCards.register(nib, forCellWithReuseIdentifier: "cell")
        
        collectionViewInsightsCards.isScrollEnabled = false
        
        calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.frame.origin.x = scrollViewInsights.frame.origin.x + 25
        calendarView.frame.origin.y = labelStreak.frame.width + labelStreak.frame.origin.y
        
        scrollViewInsights.addSubview(calendarView)

        // Circle today + decorations delegate
        let selection = UICalendarSelectionSingleDate(delegate: self)
        selection.selectedDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        calendarView.selectionBehavior = selection
        calendarView.delegate = self

        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: labelStreak.bottomAnchor, constant: 0),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            calendarView.heightAnchor.constraint(equalToConstant: 350)
        ])

        // Disable horizontal scrolling of ScrollView
        scrollViewInsights.alwaysBounceHorizontal = false
        scrollViewInsights.showsHorizontalScrollIndicator = false
        scrollViewInsights.isDirectionalLockEnabled = true

        // Fix content height for ScrollView
        scrollViewInsights.contentSize = CGSize(
            width: scrollViewInsights.bounds.width,
            height: calendarView.frame.maxY + 100
        )
    }

}

// DECORATIONS (Dots)
extension InsightsScreenViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView,
                      decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        
        let calendar = Calendar.current
        guard let date = calendar.date(from: dateComponents) else { return nil }
        _ = UIColor(red: 0xad/255, green: 0xf8/255, blue: 0x45/255, alpha: 1)

        // GREEN dates → ORANGE FLAME SF Symbol
                if greenDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
                    let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
                    let flame = UIImage(systemName: "flame.fill", withConfiguration: config)?
                        .withTintColor(.orange, renderingMode: .alwaysOriginal)

            return .image(flame)

                }


                // RED dates → RED DOT
//                if redDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
//                    return .default(color: .red, size: .small)
//                }

                return nil
            }
    }


// Needed to show today’s circle (empty but required)
extension InsightsScreenViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate,
                       didSelectDate dateComponents: DateComponents?) { }
}

extension InsightsScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardDataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InsightsScreenCollectionViewCell

        let data = cardDataArray[indexPath.row]
        cell.configureCell(with: data)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let inset: CGFloat = 16
        let interSpacing: CGFloat = 10

        let width = (collectionView.bounds.width - inset - interSpacing) / 2

        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let destinationVC = DistanceViewController()
            navigationController?.pushViewController(destinationVC, animated: true)
        }
        if indexPath.row == 1 {
            let destinationVC = CaloriesViewController()
            navigationController?.pushViewController(destinationVC, animated: true)
        }
        if indexPath.row == 2 {
            let destinationVC = StepsViewController()
            navigationController?.pushViewController(destinationVC, animated: true)
        }
        if indexPath.row == 3 {
            let destinationVC = AveragePaceViewController()
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

}

