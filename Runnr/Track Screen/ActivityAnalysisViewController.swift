//
//  ShowAnalysisViewController.swift
//  Runnr
//
//  Created by SDC-USER on 17/12/25.
//

import UIKit
import SwiftUI
import Charts
import Kingfisher

class ActivityAnalysisViewController: UIViewController {

    @IBOutlet weak var userProfileImage: UIImageView!
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
    @IBOutlet weak var labelHeartRate: UILabel!
    @IBOutlet weak var labelPhotosHeading: UILabel!
    @IBOutlet weak var viewActivityStats: UIView!
    @IBOutlet weak var collectionViewPhotos: UICollectionView!
    @IBOutlet weak var labelDistanceValue: UILabel!
    @IBOutlet weak var labelPaceValue: UILabel!
    @IBOutlet weak var labelTimeValue: UILabel!
    @IBOutlet weak var labelCaloriesValue: UILabel!
    @IBOutlet weak var labelStepsValue: UILabel!
    @IBOutlet weak var labelAvgHRValue: UILabel!
    @IBOutlet weak var labelBasePoints: UILabel!
    @IBOutlet weak var labelSkillPoints: UILabel!
    @IBOutlet weak var labelTotalPoints: UILabel!
    @IBOutlet weak var viewGraphContainer: UIView!
    @IBOutlet weak var viewHRGraphContainer: UIView!
    
    var activityData : UserActivity?
    private var datasource = DataSource.shared
    private let userProfile = DataSource.shared.getUserProfile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //settingCollectionView()
        settingAttributedText()
        settingUpActivityAnalysisScreenElements()

        let graphView = GraphView(paceData: self.datasource.getCurrentActivityPaceData())

        let hostingController = UIHostingController(rootView: graphView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        viewGraphContainer.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: self.viewGraphContainer.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.viewGraphContainer.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: self.viewGraphContainer.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.viewGraphContainer.trailingAnchor)
        ])
        
        hostingController.didMove(toParent: self)
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.activityData?.avgHeartRate == nil {
            self.labelHeartRate.isHidden = true
            self.labelAvgHRValue.isHidden = true
            self.viewHRGraphContainer.isHidden = true
            
            //if self.activityData?.activityPhotos.count == 0 {
                self.labelPhotosHeading.isHidden = true
                scrollView.contentSize.height = self.viewGraphContainer.frame.origin.y + self.viewGraphContainer.frame.height + 10
            //}
//            else {
//                self.labelPhotosHeading.frame.origin.y = self.viewGraphContainer.frame.origin.y + self.viewGraphContainer.frame.height + 10
//                self.collectionViewPhotos.frame.origin.y = self.labelPhotosHeading.frame.origin.y + self.labelPhotosHeading.frame.height + 10
//                self.scrollView.contentSize.height = self.collectionViewPhotos.frame.origin.y + self.collectionViewPhotos.frame.height + 10
//            }
        }
        else {
            self.labelHeartRate.isHidden = false
            self.labelAvgHRValue.isHidden = false
            self.viewHRGraphContainer.isHidden = false
            
//            if self.activityData?.activityPhotos.count == 0 {
                self.labelPhotosHeading.isHidden = true
                scrollView.contentSize.height = self.viewHRGraphContainer.frame.origin.y + self.viewHRGraphContainer.frame.height + 10
            //}
//            else {
//                self.labelPhotosHeading.frame.origin.y = self.viewHRGraphContainer.frame.origin.y + self.viewHRGraphContainer.frame.height + 10
//                self.collectionViewPhotos.frame.origin.y = self.labelPhotosHeading.frame.origin.y + self.labelPhotosHeading.frame.height + 10
//                self.scrollView.contentSize.height = self.collectionViewPhotos.frame.origin.y + self.collectionViewPhotos.frame.height + 10
//            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func settingUpActivityAnalysisScreenElements() {
                
        labelUserName.text = userProfile.userName
        labelUserName.sizeToFit()
        
        let profileImageURL = userProfile.userProfileImageURL
        if let url = URL(string: profileImageURL!) {
            self.userProfileImage.kf.setImage(with: url)
        }
        
        self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height / 2
        self.userProfileImage.clipsToBounds = true
        
        labelActivityTitle.text = activityData!.activityTitle
        labelActivityTitle.sizeToFit()
        
        labelActivityDate.text = formatDate(with: activityData!.activityStartTime!)
        labelActivityDate.sizeToFit()
        
        labelActivityRemark.text = activityData!.activityRemark
        
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
        
        labelBasePoints.text = String(localized: "Base Points: ") + String(self.activityData!.basePoints!)
        labelSkillPoints.text = String(localized: "Skill Points: ") + String(self.activityData!.skillPoints!)
        labelTotalPoints.text = String(localized: "Points: ") + String(self.activityData!.basePoints! + self.activityData!.skillPoints!)
        
        viewActivityStats.layer.cornerRadius = 10
    }
    
    func settingAttributedText() {
        let thinFont = UIFont(name: "SFProText-Light", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: .light)
        let boldFont = UIFont(name: "SFProText-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .medium)
        
        
        let distanceText = NSMutableAttributedString(string: String(format: "%.2f", self.activityData!.distanceCovered!), attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        distanceText.append(NSAttributedString(string: " " + self.activityData!.distanceUnit!.rawValue, attributes: [.font: thinFont, .foregroundColor: UIColor.white]))
        
        labelDistanceValue.attributedText = distanceText
        labelDistanceValue.textColor = .accent
        
        let paceText = NSMutableAttributedString(string: String(format: "%.2f", self.activityData!.avgPace!), attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        paceText.append(NSAttributedString(string: self.activityData!.paceUnit!.rawValue, attributes: [.font: thinFont, .foregroundColor: UIColor.white]))
        
        labelPaceValue.attributedText = paceText
        labelPaceValue.textColor = .accent
        
        var timeText = NSMutableAttributedString(string: "")
        let formattedTime = formatTime(self.activityData!.timeTakenSeconds!)
        if formattedTime.hour != 0 {
            timeText = NSMutableAttributedString(string: String(format: "%02d", formattedTime.hour), attributes: [.font: boldFont, .foregroundColor: UIColor.accent])
            timeText.append(NSAttributedString(string: "hr ", attributes: [.font: thinFont, .foregroundColor: UIColor.accent]))
        }
        
        timeText.append(NSAttributedString(string: String(format: "%02d", formattedTime.minute), attributes: [.font: boldFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: "min", attributes: [.font: thinFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: " " + String(format: "%02d", formattedTime.second), attributes: [.font: boldFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: "sec", attributes: [.font: thinFont, .foregroundColor: UIColor.accent]))
        
        labelTimeValue.attributedText = timeText
        
        let caloriesText = NSMutableAttributedString(string: String(self.activityData!.caloriesBurnt!), attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        caloriesText.append(NSAttributedString(string: " kcal", attributes: [.font: thinFont, .foregroundColor: UIColor.white]))

        labelCaloriesValue.attributedText = caloriesText
        labelCaloriesValue.textColor = .accent
        
        labelStepsValue.text = String(format:"%02d", self.activityData!.stepsTaken!)
        self.labelAvgHRValue.text = "Average Heart Rate: " + String(format: "%0.2d", self.activityData!.avgHeartRate ?? 0.0)
        
        self.labelTimeValue.sizeToFit()
        self.labelDistanceValue.sizeToFit()
        self.labelPaceValue.sizeToFit()
        self.labelCaloriesValue.sizeToFit()
        self.labelAvgHRValue.sizeToFit()
    }

}

// MARK: - Add Photos CollectionView Settings

//extension ActivityAnalysisViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    func settingCollectionView() {
//        collectionViewPhotos.dataSource = self
//        collectionViewPhotos.delegate = self
//        collectionViewPhotos.register(UINib(nibName: "AddPhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddPhotosCollectionViewCell")
//    }
//    
////    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return self.activityData!.activityPhotos.count
////    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotosCollectionViewCell", for: indexPath) as! AddPhotosCollectionViewCell
//        
//        //let image = self.activityData!.activityPhotos[indexPath.row]
//        cell.configureCell(with: image, hideCancel: true)
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100, height: 100)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10.0
//    }
//}

// MARK: - Setting up Pace Graph

struct GraphView: View {

    let paceData: [ActivityPaceGraphData]

    var maxXValue : ActivityPaceGraphData? {
        paceData.max { $0.distanceValue < $1.distanceValue }
    }

    var maxYValue : ActivityPaceGraphData? {
        paceData.max { $0.paceValue < $1.paceValue }
    }
    var minYValue : ActivityPaceGraphData? {
        paceData.min { $0.paceValue < $1.paceValue }
    }

    var body: some View {
        Chart {
            iteratePaceData(paceData)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .chartXAxis {
            AxisMarks(values: Array(stride(from: 0.0, through: (maxXValue?.distanceValue ?? 5.0), by: 1.0))) { value in
                AxisGridLine()
                    .foregroundStyle(.white.opacity(1))
                AxisTick()
                    .foregroundStyle(.white)
                AxisValueLabel()
                    .foregroundStyle(.white)
            }
        }
        .chartXScale(domain: 0...(maxXValue?.distanceValue ?? 5))
        .chartYScale(domain: 0...(maxYValue?.paceValue ?? 5))
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine()
                    .foregroundStyle(.white.opacity(1))
                AxisTick()
                    .foregroundStyle(.white)
                AxisValueLabel()
                    .foregroundStyle(.white)
            }
        }
        .background(Color(.black))

    }
    
    @ChartContentBuilder
    func iteratePaceData(_ paceData: [ActivityPaceGraphData]) -> some ChartContent {
        ForEach(paceData, id: \.activityID) { data in

            LineMark(
                x: .value("Distance", data.distanceValue),
                y: .value("Pace", data.paceValue)
            )
            .symbol(.circle)
            .symbolSize(70)

            AreaMark(
                x: .value("Distance", data.distanceValue),
                y: .value("Pace", data.paceValue)
            )
            .foregroundStyle(.accent.opacity(0.2))
        }
    }

}

