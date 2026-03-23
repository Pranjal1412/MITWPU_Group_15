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
    @IBOutlet weak var labelElevation: UILabel!
    @IBOutlet weak var labelElevationValue: UILabel!
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
    @IBOutlet weak var buttonViewMap: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonOptions: UIButton!
    
    var activityData : ActivityDetails?
    private let activityImages = DataSource.shared.getCurrentActivityImages() ?? []
    private var datasource = DataSource.shared
    private var UIImage = UIImageView()
    var isNewActivity : Bool = false
    private var hasShownNewActivityAlert = false
    var onActivityDeleted: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingCollectionView()
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
        if self.activityData?.activity?.avgHeartRate == nil {
            self.labelHeartRate.isHidden = true
            self.labelAvgHRValue.isHidden = true
            self.viewHRGraphContainer.isHidden = true
            
            if self.activityImages.count == 0 {
                self.labelPhotosHeading.isHidden = true
                scrollView.contentSize.height = self.viewGraphContainer.frame.origin.y + self.viewGraphContainer.frame.height + 10
            }
            else {
                self.labelPhotosHeading.frame.origin.y = self.viewGraphContainer.frame.origin.y + self.viewGraphContainer.frame.height + 10
                self.collectionViewPhotos.frame.origin.y = self.labelPhotosHeading.frame.origin.y + self.labelPhotosHeading.frame.height + 10
                self.scrollView.contentSize.height = self.collectionViewPhotos.frame.origin.y + self.collectionViewPhotos.frame.height + 10
            }
        }
        else {
            self.labelHeartRate.isHidden = false
            self.labelAvgHRValue.isHidden = false
            self.viewHRGraphContainer.isHidden = false
            
            if self.activityImages.count == 0 {
                self.labelPhotosHeading.isHidden = true
                scrollView.contentSize.height = self.viewHRGraphContainer.frame.origin.y + self.viewHRGraphContainer.frame.height + 10
            }
            else {
                self.labelPhotosHeading.frame.origin.y = self.viewHRGraphContainer.frame.origin.y + self.viewHRGraphContainer.frame.height + 10
                self.collectionViewPhotos.frame.origin.y = self.labelPhotosHeading.frame.origin.y + self.labelPhotosHeading.frame.height + 10
                self.scrollView.contentSize.height = self.collectionViewPhotos.frame.origin.y + self.collectionViewPhotos.frame.height + 10
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            if self.isNewActivity && !hasShownNewActivityAlert {
                hasShownNewActivityAlert = true
                let alert = UIAlertController(title: String(localized: "Congratulations!"),
                                              message: "You have earned \((activityData!.activity?.basePoints! ?? 0) + (activityData!.activity?.skillPoints! ?? 0)) points. Claim them now!",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: String(localized: "Claim Points"), style: .default))
                self.present(alert, animated: true)
            }
        }
    
    func deleteActivityAlert(userActivity : ActivityDetails) {
         let alert = UIAlertController(title: "Delete Activity", message: "Are you sure you want to delete this activity?", preferredStyle: .alert)
         
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
             Task {
                 guard let activityID = userActivity.activity?.activityID, let mapImageURL = userActivity.activity?.mapImageURL else { return }
                 
                 await deleteUserActivity(activityID: activityID, mapImageURL: mapImageURL)
                 
                 await MainActor.run {
                     DataSource.shared.deleteActivityFromLocalArray(activityID: activityID)
                     self.onActivityDeleted?()
                     self.dismiss(animated: true)
                 }
             }
         }
         
         alert.addAction(cancelAction)
         alert.addAction(deleteAction)
         
         present(alert, animated: true, completion: nil)

     }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        if self.isNewActivity == true {
            if let presenter = self.presentingViewController {
                self.dismiss(animated: false) {
                    presenter.dismiss(animated: false)
                }
            }
        }
        else {
               self.dismiss(animated: true)
           }
       }
       
       @IBAction func viewMapButtonPressed(_ sender: UIButton) {
           let destinationVC = ActivitySummaryViewController()
           destinationVC.isNewActivity = self.isNewActivity
           destinationVC.modalPresentationStyle = .overFullScreen
           self.present(destinationVC, animated: true)
       }
    
    @IBAction func didTapOnMoreOptions(_ sender: UIButton) {
          
          let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
          
          let shareAction = UIAlertAction(title: "Share Activity", style: .default)
          let deleteAction = UIAlertAction(title: "Delete Activity", style: .destructive) { _ in
              if self.activityData != nil {
                  self.deleteActivityAlert(userActivity: (self.activityData!))
              }
          }
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

          alert.addAction(shareAction)
          alert.addAction(deleteAction)
          alert.addAction(cancelAction)

          present(alert, animated: true)
      }
    
    func settingUpActivityAnalysisScreenElements() {
        
        setGlassEffect(for: self.buttonOptions, withImage: "ellipsis")
                setGlassEffect(for: self.buttonCancel, withImage: "multiply")

                buttonViewMap.layer.cornerRadius = 27
                buttonViewMap.layer.borderWidth = 2
                buttonViewMap.layer.borderColor = UIColor.accent.cgColor
                
        labelUserName.text = activityData?.userDetails?.userName
        labelUserName.sizeToFit()
        
        let profileImageURL = activityData?.userDetails?.userProfileImageURL
        if let url = URL(string: profileImageURL!) {
            self.userProfileImage.kf.setImage(with: url)
        }
        
        self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height / 2
        self.userProfileImage.clipsToBounds = true
        
        labelActivityTitle.text = activityData?.activity?.activityTitle
        labelActivityTitle.sizeToFit()
        
        labelActivityDate.text = formatDate(with: (activityData?.activity?.activityStartTime!)!)
        labelActivityDate.sizeToFit()
        
        labelActivityRemark.text = activityData?.activity?.activityRemark
        
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
        
        labelElevation.text = String(localized: "Elevation")
        labelElevation.sizeToFit()
        
        labelBasePoints.text = String(localized: "Base Points: ") + String(self.activityData!.activity!.basePoints!)
        labelSkillPoints.text = String(localized: "Skill Points: ") + String((self.activityData?.activity?.skillPoints!)!)
        labelTotalPoints.text = String(localized: "Points: ") + String(self.activityData!.activity!.basePoints! + self.activityData!.activity!.skillPoints!)
        
        viewActivityStats.layer.cornerRadius = 10
    }
    
    func settingAttributedText() {
        let thinFont = UIFont(name: "SFProText-Light", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: .light)
        let boldFont = UIFont(name: "SFProText-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .medium)
        
        
        let distanceText = NSMutableAttributedString(string: String(format: "%.2f", self.activityData!.activity!.distanceCovered!), attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        distanceText.append(NSAttributedString(string: " " + self.activityData!.activity!.distanceUnit!.rawValue, attributes: [.font: thinFont, .foregroundColor: UIColor.white]))
        
        labelDistanceValue.attributedText = distanceText
        labelDistanceValue.textColor = .accent
        
        let paceText = NSMutableAttributedString(string: String(format: "%.2f", self.activityData!.activity!.avgPace!), attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        paceText.append(NSAttributedString(string: self.activityData!.activity!.paceUnit!.rawValue, attributes: [.font: thinFont, .foregroundColor: UIColor.white]))
        
        labelPaceValue.attributedText = paceText
        labelPaceValue.textColor = .accent
        
        var timeText = NSMutableAttributedString(string: "")
        let formattedTime = formatTime(self.activityData!.activity!.timeTakenSeconds!)
        if formattedTime.hour != 0 {
            timeText = NSMutableAttributedString(string: String(format: "%02d", formattedTime.hour), attributes: [.font: boldFont, .foregroundColor: UIColor.accent])
            timeText.append(NSAttributedString(string: "hr ", attributes: [.font: thinFont, .foregroundColor: UIColor.accent]))
        }
        
        timeText.append(NSAttributedString(string: String(format: "%02d", formattedTime.minute), attributes: [.font: boldFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: "min", attributes: [.font: thinFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: " " + String(format: "%02d", formattedTime.second), attributes: [.font: boldFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: "sec", attributes: [.font: thinFont, .foregroundColor: UIColor.accent]))
        
        labelTimeValue.attributedText = timeText
        
        let caloriesText = NSMutableAttributedString(string: String(self.activityData!.activity!.caloriesBurnt!), attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        caloriesText.append(NSAttributedString(string: " kcal", attributes: [.font: thinFont, .foregroundColor: UIColor.white]))

        labelCaloriesValue.attributedText = caloriesText
        labelCaloriesValue.textColor = .accent
        
        labelStepsValue.text = String(format:"%d", self.activityData!.activity!.stepsTaken!);   self.labelAvgHRValue.text = "Average Heart Rate: " + String(format: "%.1f", self.activityData!.activity!.avgHeartRate ?? 0.0)
        
            let elevationText = NSMutableAttributedString(
                string: String(format: "%.1f", self.activityData!.activity!.elevation ?? 0.0),
                attributes: [.font: boldFont, .foregroundColor: UIColor.white]
            )
            
            elevationText.append(NSAttributedString(
                string: " m",
                attributes: [.font: thinFont, .foregroundColor: UIColor.white]
            ))
            
            labelElevationValue.attributedText = elevationText
            labelElevationValue.textColor = .accent
        
        self.labelTimeValue.sizeToFit()
        self.labelDistanceValue.sizeToFit()
        self.labelPaceValue.sizeToFit()
        self.labelCaloriesValue.sizeToFit()
        self.labelAvgHRValue.sizeToFit()
        self.labelElevationValue.sizeToFit()
    }

}

// MARK: - Add Photos CollectionView Settings

extension ActivityAnalysisViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func settingCollectionView() {
        collectionViewPhotos.dataSource = self
        collectionViewPhotos.delegate = self
        collectionViewPhotos.register(UINib(nibName: "AddPhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddPhotosCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activityImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotosCollectionViewCell", for: indexPath) as! AddPhotosCollectionViewCell
        
        if let url = URL(string: self.activityImages[indexPath.row].photoURL) {
            UIImage.kf.setImage(with: url)
            cell.imagePhotos.kf.setImage(with: url)
            cell.configureCell(hideCancel: true)

        }
                
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

