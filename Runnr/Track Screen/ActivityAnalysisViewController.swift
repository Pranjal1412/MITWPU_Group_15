//
//  ShowAnalysisViewController.swift
//  Runnr
//
//  Created by SDC-USER on 17/12/25.
//

import UIKit

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
    
    @IBOutlet weak var viewActivityStats: UIView!
    @IBOutlet weak var imageViewPhotos: UIImageView!
    
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

        view.overrideUserInterfaceStyle = .dark
        scrollView.contentSize.height = imageViewPhotos.frame.origin.y + imageViewPhotos.frame.height + 25
        
        setElements()
        settingAttributedText()
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func setElements() {
        
        labelUserName.text = localize(stringWith: "Ava Brooks")
        labelUserName.sizeToFit()
    
        labelActivityTitle.text = localize(stringWith: activityData!.runTitle)
        labelActivityTitle.sizeToFit()
        
        labelActivityDate.text = activityData?.timeStamp
        labelActivityDate.sizeToFit()
        
        labelActivityRemark.text = localize(stringWith: activityData!.note)
        
        labelDistance.text = localize(stringWith:"Distance")
        labelDistance.sizeToFit()
        
        labelPace.text = localize(stringWith: "Pace")
        labelPace.sizeToFit()
        
        labelTime.text = localize(stringWith: "Time")
        labelTime.sizeToFit()
        
        labelCalories.text = localize(stringWith: "Calories")
        labelCalories.sizeToFit()
        
        labelSteps.text = localize(stringWith: "Steps Taken")
        labelSteps.sizeToFit()
        
        labelBasePoints.text = localize(stringWith: "Base Points: ") + String(self.activityData!.basePoints)
        labelSkillPoints.text = localize(stringWith: "Skill Points: ") + String(self.activityData!.skillPoints)
        labelTotalPoints.text = localize(stringWith: "Points: ") + String(self.activityData!.basePoints + self.activityData!.skillPoints)
        
        viewActivityStats.layer.cornerRadius = 10
        imageViewPhotos.layer.cornerRadius = 10
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
        
        let timeText = NSMutableAttributedString(string: String(format: "%02d", self.activityData!.timeHour), attributes: [.font: boldFont, .foregroundColor: UIColor.accent])
        timeText.append(NSAttributedString(string: "hr", attributes: [.font: thinFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: " " + String(format: "%02d", self.activityData!.timeMin), attributes: [.font: boldFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: "min", attributes: [.font: thinFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: " " + String(format: "%02d", self.activityData!.timeSec), attributes: [.font: boldFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: "sec", attributes: [.font: thinFont, .foregroundColor: UIColor.accent]))
        
        labelTimeValue.attributedText = timeText
        
        let caloriesText = NSMutableAttributedString(string: "116", attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        caloriesText.append(NSAttributedString(string: " kcal", attributes: [.font: thinFont, .foregroundColor: UIColor.white]))

        labelCaloriesValue.attributedText = caloriesText
        labelCaloriesValue.textColor = .accent
        
        labelStepsValue.text = String(self.activityData!.stepsValue)
    }

}
