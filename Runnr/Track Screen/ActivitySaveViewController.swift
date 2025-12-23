//
//  SaveActivityViewController.swift
//  Runnr
//
//  Created by SDC-USER on 27/11/25.
//

import UIKit
import GoogleMaps

class ActivitySaveViewController: UIViewController {

    @IBOutlet weak var viewDistance: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var viewPace: UIView!
    @IBOutlet weak var viewCalories: UIView!
    @IBOutlet weak var scrollViewSaveActivity: UIScrollView!
    @IBOutlet weak var labelPhotos: UILabel!
    @IBOutlet weak var imageViewMap: UIImageView!
    
    @IBOutlet weak var textViewRemark: UITextView!
    @IBOutlet weak var textFieldActivityTitle: UITextField!
    
    @IBOutlet weak var labelRunSummary: UILabel!
    @IBOutlet weak var labelPublicActivity: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelDistanceValue: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelTimeValue: UILabel!
    @IBOutlet weak var labelPace: UILabel!
    @IBOutlet weak var labelCalories: UILabel!
    @IBOutlet weak var labelTimeStamp: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var activityRouteCoordinates : [CLLocationCoordinate2D] = []
    var activityMapImage : UIImage?
    var activityTimeStamp : String?
    var activityTotalDistance : String?
    var activityTotalHours : String?
    var activityTotalMins : String?
    var activityTotalSec : String?
    var datsource = DataSource.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.overrideUserInterfaceStyle = .dark
        SettingLabels()
        settingCardView()
        scrollViewSaveActivity.contentSize.height = imageView.frame.origin.y + imageView.frame.size.height + 20

        registerNotifications()
        hideKeyboardWhenTappedAround()
        textViewRemark.clipsToBounds = true
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: NSLocalizedString("Delete Activity", comment: ""),
                                      message: NSLocalizedString("Are you sure you want to Delete this Activity?", comment: ""),
                                      preferredStyle: .alert)
              
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: {_ in
            self.datsource.deleteMyActivity()
            print("After passing count: \(self.datsource.getMyActivityData().count)")
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        alert.overrideUserInterfaceStyle = .dark
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIButton) {
        
        if textFieldActivityTitle.text == "" {
            textFieldActivityTitle.text = "Morning Run"
        }
        
        if textViewRemark.text == "" {
            textViewRemark.text = "No Remark"
        }
        
        let newActivity = MyRunActivity(
                    name: "Ava Brooks",
                    date: activityTimeStamp!,
                    runTitle: textFieldActivityTitle.text ?? "Morning Run",
                    distanceValue: activityTotalDistance!,
                    distanceUnit: "km",
                    paceValue: "7:45",
                    paceUnit: "/km",
                    timeHour: activityTotalHours ?? "00",
                    timeMin: activityTotalMins ?? "00",
                    timeSec: activityTotalSec ?? "00",
                    image: activityMapImage!,
                    note: textViewRemark.text ?? "No Remark",
                    routeCoordinates: activityRouteCoordinates)
        
        self.datsource.addMyActivity(newActivity)
        print("After passing count: \(self.datsource.getMyActivityData().count)")
        
        let destinationVC = ActivitySummaryViewController()
        destinationVC.activityData = newActivity
        
        destinationVC.modalPresentationStyle = .fullScreen
        navigationController?.present(destinationVC, animated: true)
        
    }
    
    func settingCardView() {
        viewDistance.layer.cornerRadius = 15
        viewPace.layer.cornerRadius = 15
        viewTime.layer.cornerRadius = 15
        viewCalories.layer.cornerRadius = 15
        
        textViewRemark.layer.cornerRadius = 15
        textViewRemark.layer.borderColor = UIColor.white.cgColor
        textViewRemark.layer.borderWidth = 0.5
        
        imageViewMap.image = activityMapImage
        imageViewMap.layer.cornerRadius = 15
        imageView.layer.cornerRadius = 10
    }
    
    func SettingLabels() {
        labelPhotos.text = NSLocalizedString( "Photos", comment: "")
        labelDescription.text = NSLocalizedString( "Anyone on Runnr can see your activity", comment: "")
        labelRunSummary.text = NSLocalizedString( "Run Summary", comment: "")
        labelPublicActivity.text = NSLocalizedString( "Public Activity", comment: "")
        labelTimeStamp.text = self.activityTimeStamp!
        
        labelDescription.sizeToFit()
        
        labelPace.text = NSLocalizedString( "Pace", comment: "")
        labelTime.text = NSLocalizedString( "Time", comment: "")
        labelTimeValue.text = self.activityTotalHours! + " : " + self.activityTotalMins! + " : " + self.activityTotalSec!
        labelTimeValue.sizeToFit()
        labelCalories.text = NSLocalizedString( "Calories", comment: "")
        labelDistance.text = NSLocalizedString( "Distance", comment: "")
        labelDistanceValue.text = self.activityTotalDistance! + " km"
    }
    
}

extension ActivitySaveViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification){
        
        if let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
            scrollViewSaveActivity.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification){
        scrollViewSaveActivity.contentInset.bottom = 0
    }
}
