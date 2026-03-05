//
//  SaveActivityViewController.swift
//  Runnr
//
//  Created by SDC-USER on 27/11/25.
//

import UIKit
import PhotosUI
import GoogleMaps
import Kingfisher

class ActivitySaveViewController: UIViewController {

    @IBOutlet weak var viewDistance: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var viewPace: UIView!
    @IBOutlet weak var viewCalories: UIView!
    @IBOutlet weak var scrollViewSaveActivity: UIScrollView!
    @IBOutlet weak var labelPhotos: UILabel!
    @IBOutlet weak var imageViewMap: UIImageView!
    @IBOutlet weak var buttonAddPhotos: UIButton!
    @IBOutlet weak var switchIsActivityPublic: UISwitch!
    @IBOutlet weak var textViewRemark: UITextView!
    @IBOutlet weak var textFieldActivityTitle: UITextField!
    @IBOutlet weak var viewRemark: UIView!
    @IBOutlet weak var labelRunSummary: UILabel!
    @IBOutlet weak var labelPublicActivity: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelDistanceValue: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelTimeValue: UILabel!
    @IBOutlet weak var labelPace: UILabel!
    @IBOutlet weak var labelPaceValue: UILabel!
    @IBOutlet weak var labelCalories: UILabel!
    @IBOutlet weak var labelCaloriesValue: UILabel!
    @IBOutlet weak var labelTimeStamp: UILabel!
    @IBOutlet weak var labelAddPhotos: UILabel!
    @IBOutlet weak var stackAddPhotos: UIStackView!
    @IBOutlet weak var collectionViewAddPhotos: UICollectionView!
    
    var activityData: UserActivity!
    private var dataSource = DataSource.shared
    private var userStats = DataSource.shared.getUserStats()
    
    private var selectedImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.settingLabels()
        self.settingCardView()
        self.collectionViewAddPhotos.isHidden = true
        self.collectionViewAddPhotos.dataSource = self
        self.textViewRemark.delegate = self

        if let url = URL(string: activityData.mapImageURL!) {
            self.imageViewMap.kf.setImage(with: url)
        }

        
        scrollViewSaveActivity.contentSize.height = stackAddPhotos.frame.origin.y + stackAddPhotos.frame.size.height + 30

        collectionViewAddPhotos.register(UINib(nibName: "AddPhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddPhotosCollectionViewCell")
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        registerNotifications()
        hideKeyboardWhenTappedAround()
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: String(localized: "Delete Activity"),
                                      message: String(localized: "Are you sure you want to Delete this Activity?"),
                                      preferredStyle: .alert)
              
        let cancelAction = UIAlertAction(title: String(localized: "Cancel"), style: .cancel)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: {_ in
            Task {
                await deleteUserActivity(activityID: self.activityData.activityID!, mapImageURL: self.activityData.mapImageURL!)
                await MainActor.run {
                    self.navigationController?.dismiss(animated: true)
                }

            }
        })
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIButton) {
        
        if textFieldActivityTitle.text == "" {
            textFieldActivityTitle.text = defaultActivityTitle()
        }
        
        if textViewRemark.text == "" {
            textViewRemark.text = ""
        }
        
        self.activityData.activityTitle = self.textFieldActivityTitle.text!
        self.activityData.activityRemark = self.textViewRemark.text
        self.activityData.isPublic = self.switchIsActivityPublic.isOn
        
        Task {
            await updateUserActivity(newActivity: activityData)
            
            self.userStats?.totalPointsEarned += (self.activityData.basePoints ?? 0) + (self.activityData.skillPoints ?? 0)
            self.userStats?.totalDistanceCovered += self.activityData.distanceCovered ?? 0

            self.dataSource.setCurrentActivity(activityData)
            self.dataSource.resetMyActivities()
            self.dataSource.setUserStats(self.userStats!)

            await updateUserStats(userID: activityData.userID!, newStats: self.userStats!)
            
            let destinationVC = ActivitySummaryViewController()
            destinationVC.isNewActivity = true
            
            destinationVC.modalPresentationStyle = .fullScreen
            navigationController?.present(destinationVC, animated: true)
        }
        //MARK: - Still yet to be implmented
//        self.activityData.activityPhotos = self.selectedImages
        
    }
    
    @IBAction func addPhotosButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraButton = UIAlertAction(title: String(localized: "Camera"), style: .default, handler: {_ in 
            self.openCamera()
        })
        let photoLibraryButton = UIAlertAction(title: String(localized: "Gallery"), style: .default, handler: {_ in
            self.openPhotoLibrary()
        })
        let cancelButton = UIAlertAction(title: String("Cancel"), style: .cancel)

        alert.addAction(cameraButton)
        alert.addAction(photoLibraryButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true)
    }
        
    func settingCardView() {
        viewDistance.layer.cornerRadius = 15
        viewPace.layer.cornerRadius = 15
        viewTime.layer.cornerRadius = 15
        viewCalories.layer.cornerRadius = 15
        
        self.viewRemark.layer.cornerRadius = 15
        self.viewRemark.layer.borderColor = UIColor.white.cgColor
        self.viewRemark.layer.borderWidth = 0.5
//        Task{
//            imageViewMap.image = await loadUIImage(from: activityData.mapImageURL!)
//        }
        imageViewMap.layer.cornerRadius = 15
    }
    
    func settingLabels() {
        labelPhotos.text = String(localized: "Photos")
        labelDescription.text = String(localized: "Anyone on Runnr can see your activity")
        labelRunSummary.text = String(localized: "Run Summary")
        labelPublicActivity.text = String(localized: "Public Activity")
        labelTimeStamp.text = formatDate(with: self.activityData.activityStartTime!)
        
        labelDescription.sizeToFit()
        
        labelPace.text = NSLocalizedString( "Pace", comment: "")
        labelPaceValue.text = String(format: "%.2f", self.activityData.avgPace!) + " " + self.activityData.paceUnit!.rawValue
        labelTime.text = NSLocalizedString( "Time", comment: "")
        
        let formattedTime = formatTime(self.activityData.timeTakenSeconds!)
        labelTimeValue.text = String(format: "%02d : %02d : %02d", formattedTime.hour, formattedTime.minute, formattedTime.second)
        labelTimeValue.sizeToFit()
        labelCalories.text = NSLocalizedString( "Calories", comment: "")
        labelCaloriesValue.text = String(format: "%.0f", self.activityData.caloriesBurnt!) + " kcal"
        labelDistance.text = NSLocalizedString( "Distance", comment: "")
        labelDistanceValue.text = String(format: "%.2f", self.activityData.distanceCovered!) + " " + self.activityData.distanceUnit!.rawValue
        
        labelAddPhotos.text = String(localized: "Tap here to upload photos")
    }
    
    func defaultActivityTitle() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 5..<12:
            return "Morning Run"
        case 12..<17:
            return "Afternoon Run"
        case 17..<21:
            return "Evening Run"
        default:
            return "Night Run"
        }
    }

}

// MARK: - KeyBoard Settings

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

// MARK: - Camera & Photos

extension ActivitySaveViewController : PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func openPhotoLibrary() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 5 - self.selectedImages.count

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }

        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }

    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        self.collectionViewAddPhotos.isHidden = false
        self.stackAddPhotos.isHidden = true
        
//        this is required because it takes time to load the images but collection vew gets loaded before all the images are loaded
//        so group allows to keep track about when all the task are completed and upon completion reloadData is called
        let group = DispatchGroup()
        
        for result in results {
//          .itemProvider -> object that can load the image data
            let provider = result.itemProvider
            
//          .canLoadObject -> Confirms the selected item can be converted into UIImage
            if provider.canLoadObject(ofClass: UIImage.self) {
                group.enter()
//              loading the image
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self.selectedImages.append(image)
                            print("Current count:", self.selectedImages.count)
                        }
                    }
                    group.leave()
                }
            }
        }
        
        // not called until all the task that has entered in the task leave the group
        group.notify(queue: .main) {
            self.updatePhotoUI()
        }
                
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        self.collectionViewAddPhotos.isHidden = false

        if let image = info[.originalImage] as? UIImage {
            self.selectedImages.append(image)
        }
        
        self.updatePhotoUI()

    }
    
    func updatePhotoUI() {
        if self.selectedImages.count == 0 {
            self.collectionViewAddPhotos.isHidden = true
            self.stackAddPhotos.isHidden = false
            self.buttonAddPhotos.isHidden = true
            
            self.scrollViewSaveActivity.contentSize.height = self.stackAddPhotos.frame.height + self.stackAddPhotos.frame.origin.y + 10

        }
        else {
            self.collectionViewAddPhotos.reloadData()
            self.collectionViewAddPhotos.isHidden = false
            self.stackAddPhotos.isHidden = true
            
            self.scrollViewSaveActivity.contentSize.height = self.collectionViewAddPhotos.frame.height + self.collectionViewAddPhotos.frame.origin.y + 10
            
            if self.selectedImages.count < 5 {
                self.buttonAddPhotos.isHidden = false
            }
            else {
                self.buttonAddPhotos.isHidden = true
            }

        }
    }
    
}

// MARK: - Add Photos CollectionView Settings

extension ActivitySaveViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.selectedImages.count)
        return self.selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotosCollectionViewCell", for: indexPath) as! AddPhotosCollectionViewCell
                
        let image = self.selectedImages[indexPath.row]
        cell.buttonDeletePhoto.tag = indexPath.row
        cell.buttonDeletePhoto.addTarget(self, action: #selector(deletePhoto(_ :)), for: .touchUpInside)
        
        cell.configureCell(with: image, hideCancel: false)
        
        return cell
    }
    
    @objc func deletePhoto(_ sender: UIButton) {
        self.selectedImages.remove(at: sender.tag)
       self.updatePhotoUI()
       self.collectionViewAddPhotos.reloadData()
   }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

// MARK: - Text View dynammic height Settings

extension ActivitySaveViewController : UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.size.width, height: .infinity)
        let estimatedsize = textView.sizeThatFits(size)
        
        if estimatedsize.height < 100 {
            textView.isScrollEnabled = false
            self.viewRemark.frame.size.height = estimatedsize.height + 20
            
        } else {
            textView.isScrollEnabled = true
            self.viewRemark.frame.size.height = 100 + 10
        }
        
        if self.stackAddPhotos.isHidden {
            self.scrollViewSaveActivity.contentSize.height = self.collectionViewAddPhotos.frame.origin.y + self.collectionViewAddPhotos.frame.size.height + 30

        }
        else {
            self.scrollViewSaveActivity.contentSize.height = self.stackAddPhotos.frame.origin.y + self.stackAddPhotos.frame.size.height + 30
        }
        
    }
    
}
