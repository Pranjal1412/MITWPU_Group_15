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
    
    var activityData: ActivityDetails?
    private let activityImages = DataSource.shared.getCurrentActivityImages() ?? []
    private var datasource = DataSource.shared
    private var UIImage = UIImageView()
    var isNewActivity: Bool = false
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
                scrollView.contentSize.height = self.viewGraphContainer.frame.origin.y + self.viewGraphContainer.frame.height + 50
            } else {
                self.labelPhotosHeading.frame.origin.y = self.viewGraphContainer.frame.origin.y + self.viewGraphContainer.frame.height + 10
                self.collectionViewPhotos.frame.origin.y = self.labelPhotosHeading.frame.origin.y + self.labelPhotosHeading.frame.height + 10
                self.scrollView.contentSize.height = self.collectionViewPhotos.frame.origin.y + self.collectionViewPhotos.frame.height + self.buttonViewMap.frame.height + 50
            }
        } else {
            self.labelHeartRate.isHidden = false
            self.labelAvgHRValue.isHidden = false
            self.viewHRGraphContainer.isHidden = false
            
            if self.activityImages.count == 0 {
                self.labelPhotosHeading.isHidden = true
                scrollView.contentSize.height = self.viewHRGraphContainer.frame.origin.y + self.viewHRGraphContainer.frame.height + 10
            } else {
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
            let alert = UIAlertController(
                title: String(localized: "Congratulations!"),
                message: "You have earned \((activityData!.activity?.basePoints! ?? 0) + (activityData!.activity?.skillPoints! ?? 0)) points. Claim them now!",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: String(localized: "Claim Points"), style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func deleteActivityAlert(userActivity: ActivityDetails) {
        let alert = UIAlertController(title: "Delete Activity", message: "Are you sure you want to delete this activity?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            Task {
                guard let activityID = userActivity.activity?.activityID,
                      let mapImageURL = userActivity.activity?.mapImageURL else { return }
                await deleteUserActivity(activityID: activityID, mapImageURL: mapImageURL)
                await MainActor.run {
                    DataSource.shared.deleteActivityFromLocalArray(activityID: activityID)
                    self.onActivityDeleted?()
                    self.dismiss(animated: true)
                }
            }
        })
        
        present(alert, animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        if self.isNewActivity {
            if let presenter = self.presentingViewController {
                self.dismiss(animated: false) {
                    presenter.dismiss(animated: false)
                }
            }
        } else {
            self.dismiss(animated: true)
        }
    }
       
    @IBAction func viewMapButtonPressed(_ sender: UIButton) {
        let destinationVC = ActivitySummaryViewController()
        destinationVC.isNewActivity = self.isNewActivity
        destinationVC.modalPresentationStyle = .overFullScreen
        self.present(destinationVC, animated: true)
    }
    
    func settingUpActivityAnalysisScreenElements() {
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
        
        labelDistance.text = String(localized: "Distance"); labelDistance.sizeToFit()
        labelPace.text = String(localized: "Pace"); labelPace.sizeToFit()
        labelTime.text = String(localized: "Time"); labelTime.sizeToFit()
        labelCalories.text = String(localized: "Calories"); labelCalories.sizeToFit()
        labelSteps.text = String(localized: "Steps Taken"); labelSteps.sizeToFit()
        labelElevation.text = String(localized: "Elevation"); labelElevation.sizeToFit()
        
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
        
        labelStepsValue.text = String(format: "%d", self.activityData!.activity!.stepsTaken!)
        self.labelAvgHRValue.text = "Average Heart Rate: " + String(format: "%.1f", self.activityData!.activity!.avgHeartRate ?? 0.0)
        
        let elevationText = NSMutableAttributedString(
            string: String(format: "%.1f", self.activityData!.activity!.elevation ?? 0.0),
            attributes: [.font: boldFont, .foregroundColor: UIColor.white]
        )
        elevationText.append(NSAttributedString(string: " m", attributes: [.font: thinFont, .foregroundColor: UIColor.white]))
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

extension ActivityAnalysisViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

    var maxXValue: ActivityPaceGraphData? { paceData.max { $0.distanceValue < $1.distanceValue } }
    var maxYValue: ActivityPaceGraphData? { paceData.max { $0.paceValue < $1.paceValue } }
    var minYValue: ActivityPaceGraphData? { paceData.min { $0.paceValue < $1.paceValue } }

    var body: some View {
        Chart { iteratePaceData(paceData) }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .chartXAxis {
            AxisMarks(values: Array(stride(from: 0.0, through: (maxXValue?.distanceValue ?? 5.0), by: 1.0))) { _ in
                AxisGridLine().foregroundStyle(.white.opacity(1))
                AxisTick().foregroundStyle(.white)
                AxisValueLabel().foregroundStyle(.white)
            }
        }
        .chartXScale(domain: 0...(maxXValue?.distanceValue ?? 5))
        .chartYScale(domain: 0...(maxYValue?.paceValue ?? 5))
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine().foregroundStyle(.white.opacity(1))
                AxisTick().foregroundStyle(.white)
                AxisValueLabel().foregroundStyle(.white)
            }
        }
        .background(Color(.black))
    }
    
    @ChartContentBuilder
    func iteratePaceData(_ paceData: [ActivityPaceGraphData]) -> some ChartContent {
        ForEach(paceData, id: \.activityID) { data in
            LineMark(x: .value("Distance", data.distanceValue), y: .value("Pace", data.paceValue))
                .symbol(.circle).symbolSize(70)
            AreaMark(x: .value("Distance", data.distanceValue), y: .value("Pace", data.paceValue))
                .foregroundStyle(.accent.opacity(0.2))
        }
    }
}

// MARK: - Share Activity

extension ActivityAnalysisViewController {

    // Called when the VC is fully presented (share from inside the analysis screen — not used for swipe share)
    func shareActivity() {
        guard let activity = activityData?.activity else { return }

        let loadingAlert = showLoadingAlert(message: "Preparing share...")

        if let mapURLString = activity.mapImageURL, let mapURL = URL(string: mapURLString) {
            KingfisherManager.shared.retrieveImage(with: mapURL) { [weak self] result in
                guard let self else { return }
                let mapImage: UIImage? = try? result.get().image
                DispatchQueue.main.async {
                    loadingAlert.dismiss(animated: true) {
                        let card = self.buildShareCard(mapImage: mapImage)
                        self.presentShareSheet(image: card)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                loadingAlert.dismiss(animated: true) {
                    let card = self.buildShareCard(mapImage: nil)
                    self.presentShareSheet(image: card)
                }
            }
        }
    }

    // PUBLIC: Called from ActivityScreenViewController swipe-share
    // Does NOT require the VC to be in the view hierarchy — safe to call off-screen
    func buildShareCardPublic(mapImage: UIImage?) -> UIImage {
        return buildShareCard(mapImage: mapImage)
    }

    // MARK: - Present Share Sheet (only used when VC is presented normally)

    private func presentShareSheet(image: UIImage) {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.assignToContact, .addToReadingList, .openInIBooks]
        present(activityVC, animated: true)
    }

    // MARK: - Build Share Card (pure function — no UIKit hierarchy needed)

    func buildShareCard(mapImage: UIImage?) -> UIImage {
        let cardWidth:  CGFloat = 390
        let cardHeight: CGFloat = 700
        let mapHeight:  CGFloat = 350
        let cardSize = CGSize(width: cardWidth, height: cardHeight)

        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: cardSize, format: format)

        return renderer.image { ctx in
            let context = ctx.cgContext

            UIColor(hex: "#0D0D0D").setFill()
            UIBezierPath(rect: CGRect(origin: .zero, size: cardSize)).fill()

            let mapRect = CGRect(x: 0, y: 0, width: cardWidth, height: mapHeight)
            if let map = mapImage {
                context.saveGState()
                UIBezierPath(rect: mapRect).addClip()
                let mapSize = map.size
                let scale   = max(cardWidth / mapSize.width, mapHeight / mapSize.height)
                let drawW   = mapSize.width  * scale
                let drawH   = mapSize.height * scale
                let drawX   = (cardWidth  - drawW) / 2
                let drawY   = (mapHeight  - drawH) / 2
                map.draw(in: CGRect(x: drawX, y: drawY, width: drawW, height: drawH))
                context.restoreGState()
            } else {
                UIColor(hex: "#1A1A1A").setFill()
                UIBezierPath(rect: mapRect).fill()
            }

            let gradColors = [UIColor.clear.cgColor, UIColor(hex: "#0D0D0D").cgColor]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                      colors: gradColors as CFArray,
                                      locations: [0.7, 1.0])!
            context.drawLinearGradient(gradient,
                                       start: CGPoint(x: 0, y: mapHeight - 100),
                                       end:   CGPoint(x: 0, y: mapHeight),
                                       options: [])

            let brandAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .bold),
                .foregroundColor: UIColor(hex: "#ADF845"),
                .kern: 4.0
            ]
            NSAttributedString(string: "Runnr.", attributes: brandAttrs).draw(at: CGPoint(x: 20, y: 16))

            let avatarY    = mapHeight + 16
            let avatarRect = CGRect(x: 20, y: avatarY, width: 44, height: 44)
            UIColor(hex: "#222222").setFill()
            UIBezierPath(ovalIn: avatarRect).fill()

            if let profileURLStr = activityData?.userDetails?.userProfileImageURL,
               let profileImg = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: profileURLStr) {
                context.saveGState()
                UIBezierPath(ovalIn: avatarRect).addClip()
                profileImg.draw(in: avatarRect)
                context.restoreGState()
            }

            let nameAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                .foregroundColor: UIColor.white
            ]
            let subtitleAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12, weight: .regular),
                .foregroundColor: UIColor(hex: "#666666")
            ]
            NSAttributedString(string: activityData?.userDetails?.userName ?? "", attributes: nameAttrs)
                .draw(at: CGPoint(x: 74, y: avatarY + 7))
            NSAttributedString(string: activityData?.activity?.activityTitle ?? "", attributes: subtitleAttrs)
                .draw(at: CGPoint(x: 74, y: avatarY + 27))

            let dividerY = avatarY + 60
            drawDivider(at: dividerY, from: 20, to: 370, color: "#222222", context: context)

            let activity = activityData?.activity
            let row1: [(label: String, value: String, unit: String)] = [
                ("DISTANCE", String(format: "%.2f", activity?.distanceCovered ?? 0), activity?.distanceUnit?.rawValue ?? "km"),
                ("PACE",     String(format: "%.2f", activity?.avgPace ?? 0),         activity?.paceUnit?.rawValue ?? "/km"),
                ("TIME",     buildTimeStringShort(from: activity?.timeTakenSeconds ?? 0), "")
            ]
            let row1Y = dividerY + 12
            drawStatRow(row1, yBase: row1Y, cardWidth: cardWidth, isPoints: [false, false, false], context: context)

            let midDividerY = row1Y + 80
            drawDivider(at: midDividerY, from: 20, to: 370, color: "#1E1E1E", context: context)

            let points = (activity?.basePoints ?? 0) + (activity?.skillPoints ?? 0)
            let row2: [(label: String, value: String, unit: String)] = [
                ("CALORIES", "\(activity?.caloriesBurnt ?? 0)", "kcal"),
                ("STEPS",    "\(activity?.stepsTaken ?? 0)",    "steps"),
                ("POINTS",   "\(points)",                       "points")
            ]
            drawStatRow(row2, yBase: midDividerY + 12, cardWidth: cardWidth, isPoints: [false, false, true], context: context)

            let barY = cardHeight - 80
            drawDivider(at: barY, from: 20, to: 370, color: "#1E1E1E", context: context)

            let tagAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11, weight: .medium),
                .foregroundColor: UIColor(hex: "#444444"),
                .kern: 2.5
            ]
            let tagStr  = NSAttributedString(string: "Tracked with Runnr.", attributes: tagAttrs)
            let tagSize = tagStr.size()
            tagStr.draw(at: CGPoint(x: (cardWidth - tagSize.width) / 2, y: barY + 12))
        }
    }

    // MARK: - Draw Stat Row

    private func drawStatRow(_ stats: [(label: String, value: String, unit: String)],
                             yBase: CGFloat, cardWidth: CGFloat,
                             isPoints: [Bool], context: CGContext) {
        let colPositions: [CGFloat] = [cardWidth * 0.20, cardWidth * 0.5, cardWidth * 0.80]
        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10, weight: .medium),
            .foregroundColor: UIColor(hex: "#666666"),
            .kern: 1.2
        ]
        let unitAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11, weight: .regular),
            .foregroundColor: UIColor(hex: "#666666")
        ]
        let valueFont = UIFont.systemFont(ofSize: 26, weight: .bold)

        for (i, stat) in stats.enumerated() {
            let cx = colPositions[i]
            let labelStr = NSAttributedString(string: stat.label, attributes: labelAttrs)
            labelStr.draw(at: CGPoint(x: cx - labelStr.size().width / 2, y: yBase))

            let valueColor: UIColor = isPoints[i] ? UIColor(hex: "#AAFF00") : .white
            let valueStr = NSAttributedString(string: stat.value, attributes: [.font: valueFont, .foregroundColor: valueColor])
            valueStr.draw(at: CGPoint(x: cx - valueStr.size().width / 2, y: yBase + 22))

            if !stat.unit.isEmpty {
                let unitStr = NSAttributedString(string: stat.unit, attributes: unitAttrs)
                unitStr.draw(at: CGPoint(x: cx - unitStr.size().width / 2, y: yBase + 54))
            }
        }
    }

    // MARK: - Draw Divider

    private func drawDivider(at y: CGFloat, from x1: CGFloat, to x2: CGFloat,
                             color: String, context: CGContext) {
        UIColor(hex: color).setStroke()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x1, y: y))
        path.addLine(to: CGPoint(x: x2, y: y))
        path.lineWidth = 1
        path.stroke()
    }

    // MARK: - Time String

    private func buildTimeStringShort(from totalSeconds: Int) -> String {
        let formatted = formatTime(totalSeconds)
        if formatted.hour > 0 {
            return String(format: "%d:%02d:%02d", formatted.hour, formatted.minute, formatted.second)
        }
        return String(format: "%02d:%02d", formatted.minute, formatted.second)
    }

    // MARK: - Loading Alert

    private func showLoadingAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor, constant: 16)
        ])
        alert.view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        present(alert, animated: true)
        return alert
    }
}

// MARK: - UIColor Hex Helper

extension UIColor {
    convenience init(hex: String) {
        var hexStr = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexStr.hasPrefix("#") { hexStr.removeFirst() }
        var rgb: UInt64 = 0
        Scanner(string: hexStr).scanHexInt64(&rgb)
        self.init(
            red:   CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8)  & 0xFF) / 255,
            blue:  CGFloat( rgb        & 0xFF) / 255,
            alpha: 1.0
        )
    }
}
