//
//  ShowAnalysisViewController.swift
//  Runnr
//
//  Created by SDC-USER on 17/12/25.
//

import UIKit
import SwiftUI
import Charts

class ActivityAnalysisViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelActivityDate: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelActivityTitle: UILabel!
    @IBOutlet weak var labelActivityRemark: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelPace: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelCalories: UILabel!
    @IBOutlet weak var labelSteps: UILabel!
    @IBOutlet weak var labelPhotosHeading: UILabel!
    
    @IBOutlet weak var viewActivityStats: UIView!
    @IBOutlet weak var collectionViewPhotos: UICollectionView!
    
    @IBOutlet weak var imageGraph: UIImageView!
    @IBOutlet weak var labelDistanceValue: UILabel!
    @IBOutlet weak var labelPaceValue: UILabel!
    @IBOutlet weak var labelTimeValue: UILabel!
    @IBOutlet weak var labelCaloriesValue: UILabel!
    @IBOutlet weak var labelStepsValue: UILabel!
    @IBOutlet weak var labelBasePoints: UILabel!
    @IBOutlet weak var labelSkillPoints: UILabel!
    @IBOutlet weak var labelTotalPoints: UILabel!
    
    var activityData : MyRunActivity?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let GraphView = swi
        
        setElements()
        settingCollectioView()
        settingAttributedText()
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setElements() {
        
        if self.activityData?.activityPhotos.count == 0 {
            self.labelPhotosHeading.isHidden = true
            scrollView.contentSize.height = self.imageGraph.frame.origin.y + self.imageGraph.frame.height + 10
        }
        else {
            scrollView.contentSize.height = self.collectionViewPhotos.frame.origin.y + self.collectionViewPhotos.frame.height + 10
        }
        
        labelUserName.text = activityData!.userName
        labelUserName.sizeToFit()
    
        labelActivityTitle.text = activityData!.runTitle
        labelActivityTitle.sizeToFit()
        
        labelActivityDate.text = formatDate(with: activityData!.timeStamp)
        labelActivityDate.sizeToFit()
        
        labelActivityRemark.text = activityData!.note
        
        labelDistance.text = String(localized: "Distance")
        labelDistance.sizeToFit()
        
        labelPace.text = String(localized: "Pace")
        labelPace.sizeToFit()
        
        labelTime.text = String(localized: "Time")
        labelTime.sizeToFit()
        
        labelCalories.text = String(localized: "Calories")
        labelCalories.sizeToFit()
        
        labelSteps.text = String(localized: "Steps Taken")
        labelSteps.sizeToFit()
        
        labelBasePoints.text = String(localized: "Base Points: ") + String(self.activityData!.basePoints)
        labelSkillPoints.text = String(localized: "Skill Points: ") + String(self.activityData!.skillPoints)
        labelTotalPoints.text = String(localized: "Points: ") + String(self.activityData!.basePoints + self.activityData!.skillPoints)
        
        viewActivityStats.layer.cornerRadius = 10
    }
    
    func settingAttributedText() {
        let thinFont = UIFont(name: "SFProText-Light", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: .light)
        let boldFont = UIFont(name: "SFProText-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .medium)
        
        
        let distanceText = NSMutableAttributedString(string: String(format: "%.2f", self.activityData!.distanceValue), attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        distanceText.append(NSAttributedString(string: " " + self.activityData!.distanceUnit, attributes: [.font: thinFont, .foregroundColor: UIColor.white]))
        
        labelDistanceValue.attributedText = distanceText
        labelDistanceValue.textColor = .accent
        
        let paceText = NSMutableAttributedString(string: String(format: "%.2f", self.activityData!.paceValue), attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        paceText.append(NSAttributedString(string: " /km", attributes: [.font: thinFont, .foregroundColor: UIColor.white]))
        
        labelPaceValue.attributedText = paceText
        labelPaceValue.textColor = .accent
        
        var timeText = NSMutableAttributedString(string: "")
        
        if self.activityData!.timeHour != 0 {
            timeText = NSMutableAttributedString(string: String(format: "%02d", self.activityData!.timeHour), attributes: [.font: boldFont, .foregroundColor: UIColor.accent])
            timeText.append(NSAttributedString(string: "hr ", attributes: [.font: thinFont, .foregroundColor: UIColor.accent]))
        }
        
        timeText.append(NSAttributedString(string: String(format: "%02d", self.activityData!.timeMin), attributes: [.font: boldFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: "min", attributes: [.font: thinFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: " " + String(format: "%02d", self.activityData!.timeSec), attributes: [.font: boldFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: "sec", attributes: [.font: thinFont, .foregroundColor: UIColor.accent]))
        
        labelTimeValue.attributedText = timeText
        
        let caloriesText = NSMutableAttributedString(string: String(self.activityData!.caloriesValue), attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        caloriesText.append(NSAttributedString(string: " kcal", attributes: [.font: thinFont, .foregroundColor: UIColor.white]))

        labelCaloriesValue.attributedText = caloriesText
        labelCaloriesValue.textColor = .accent
        
        labelStepsValue.text = String(self.activityData!.stepsValue)
        
        self.labelTimeValue.sizeToFit()
        self.labelDistanceValue.sizeToFit()
        self.labelPaceValue.sizeToFit()
        self.labelCaloriesValue.sizeToFit()
    }

}

// MARK: - Add Photos CollectionView Settings

extension ActivityAnalysisViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func settingCollectioView() {
        collectionViewPhotos.dataSource = self
        collectionViewPhotos.delegate = self
        collectionViewPhotos.register(UINib(nibName: "AddPhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddPhotosCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activityData!.activityPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotosCollectionViewCell", for: indexPath) as! AddPhotosCollectionViewCell
        
        let image = self.activityData!.activityPhotos[indexPath.row]
        cell.configureCell(with: image, hideCancel: true)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

// MARK: - Setting up Pace Graph

struct GraphView: View {
    var body: some View {
        Chart {
            LineMark(x: .value("Distance", "1 Km"), y: .value("Pace", 4))
                .symbol(.square)
                .symbolSize(100)
            
            LineMark(x: .value("Distance", "2 Km"), y: .value("Pace", 6))
                .symbol(.circle)
                .symbolSize(100)
            
            LineMark(x: .value("Distance", "3 Km"), y: .value("Pace", 5))
                .symbol(.circle)
                .symbolSize(100)
            
            LineMark(x: .value("Distance", "4 Km"), y: .value("Pace", 5.75))
                .symbol(.circle)
                .symbolSize(100)
            
            LineMark(x: .value("Distance", "5 Km"), y: .value("Pace", 7))
                .symbol(.square)
                .symbolSize(100)
            
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
        .chartXAxis {
            AxisMarks { _ in
                AxisGridLine()
                    .foregroundStyle(.black.opacity(1))
                AxisTick()
                    .foregroundStyle(.black)
                AxisValueLabel()
                    .foregroundStyle(.black)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine()
                    .foregroundStyle(.black.opacity(1))
                AxisTick()
                    .foregroundStyle(.black)
                AxisValueLabel()
                    .foregroundStyle(.black)
            }
        }

    }
}

