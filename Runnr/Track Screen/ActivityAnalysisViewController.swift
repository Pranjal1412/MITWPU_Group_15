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
        
        labelUserName.text = NSLocalizedString("Ava Brooks", comment: "")
        labelUserName.sizeToFit()
        
        labelActivityTitle.text = NSLocalizedString(activityData!.runTitle, comment: "")
        labelActivityTitle.sizeToFit()
        
        labelActivityRemark.text = NSLocalizedString(activityData!.note, comment: "")
        
        labelDistance.text = NSLocalizedString("Distance", comment: "")
        labelDistance.sizeToFit()
        
        labelPace.text = NSLocalizedString("Pace", comment: "")
        labelPace.sizeToFit()
        
        labelTime.text = NSLocalizedString("Time", comment: "")
        labelTime.sizeToFit()
        
        labelCalories.text = NSLocalizedString("Calories", comment: "")
        labelCalories.sizeToFit()
        
        labelSteps.text = NSLocalizedString("Steps Taken", comment: "")
        labelSteps.sizeToFit()
        
        viewActivityStats.layer.cornerRadius = 10
        imageViewPhotos.layer.cornerRadius = 10
    }
    
    func settingAttributedText() {
        let thinFont = UIFont(name: "SFProText-Light", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: .light)
        let boldFont = UIFont(name: "SFProText-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .medium)
        
        
        var thinText = NSAttributedString(string: " km", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        var boldText = NSAttributedString(string: "7.2", attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        let fullDistanceText = NSMutableAttributedString()
        fullDistanceText.append(boldText)
        fullDistanceText.append(thinText)
        labelDistanceValue.attributedText = fullDistanceText
        labelDistanceValue.textColor = .accent
        
        thinText = NSAttributedString(string: " /km", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        boldText = NSAttributedString(string: "7:90", attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        let fullPaceText = NSMutableAttributedString()
        fullPaceText.append(boldText)
        fullPaceText.append(thinText)
        labelPaceValue.attributedText = fullPaceText
        labelPaceValue.textColor = .accent
        
        thinText = NSAttributedString(string: " kcal", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        boldText = NSAttributedString(string: "116", attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        let fullCaloriesText = NSMutableAttributedString()
        fullCaloriesText.append(boldText)
        fullCaloriesText.append(thinText)
        labelCaloriesValue.attributedText = fullCaloriesText
        labelCaloriesValue.textColor = .accent
        
        thinText = NSAttributedString(string: "hr", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        boldText = NSAttributedString(string: "01", attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        let fullTimeText = NSMutableAttributedString()
        fullTimeText.append(boldText)
        fullTimeText.append(thinText)
        
        thinText = NSAttributedString(string: "min", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        boldText = NSAttributedString(string: " 53", attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        fullTimeText.append(boldText)
        fullTimeText.append(thinText)
        
        thinText = NSAttributedString(string: "sec", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        boldText = NSAttributedString(string: " 12", attributes: [.font: boldFont, .foregroundColor: UIColor.white])
        
        fullTimeText.append(boldText)
        fullTimeText.append(thinText)
        
        labelTimeValue.attributedText = fullTimeText
        labelTimeValue.textColor = .accent
    }

}
