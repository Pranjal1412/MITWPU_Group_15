//
//  SaveActivityViewController.swift
//  Runnr
//
//  Created by SDC-USER on 27/11/25.
//

import UIKit
import GoogleMaps
import PhotosUI

class ActivitySaveViewController: UIViewController {

    @IBOutlet weak var viewDistance: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var viewPace: UIView!
    @IBOutlet weak var viewCalories: UIView!
    @IBOutlet weak var scrollViewSaveActivity: UIScrollView!
    @IBOutlet weak var labelPhotos: UILabel!
    @IBOutlet weak var imageViewMap: UIImageView!
    
    @IBOutlet weak var switchIsActivityPublic: UISwitch!
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
    @IBOutlet weak var labelPaceValue: UILabel!
    @IBOutlet weak var labelCalories: UILabel!
    @IBOutlet weak var labelCaloriesValue: UILabel!
    @IBOutlet weak var labelTimeStamp: UILabel!
        
    @IBOutlet weak var stackAddPhotos: UIStackView!
    @IBOutlet weak var collectionViewAddPhotos: UICollectionView!
    
    var activityData: MyRunActivity!
    var datsource = DataSource.shared
    private var selectedImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.overrideUserInterfaceStyle = .dark
        SettingLabels()
        settingCardView()
        scrollViewSaveActivity.contentSize.height = stackAddPhotos.frame.origin.y + stackAddPhotos.frame.size.height + 20

        collectionViewAddPhotos.isHidden = true
        collectionViewAddPhotos.register(UINib(nibName: "AddPhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddPhotosCollectionViewCell")
        collectionViewAddPhotos.dataSource = self
        
        registerNotifications()
        hideKeyboardWhenTappedAround()
        textViewRemark.clipsToBounds = true
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: String(localized: "Delete Activity"),
                                      message: String(localized: "Are you sure you want to Delete this Activity?"),
                                      preferredStyle: .alert)
              
        let cancelAction = UIAlertAction(title: String(localized: "Cancel"), style: .cancel)
        
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
            textFieldActivityTitle.text = defaultActivityTitle()
        }
        
        if textViewRemark.text == "" {
            textViewRemark.text = ""
        }
        
        activityData.runTitle = self.textFieldActivityTitle.text!
        activityData.note = self.textViewRemark.text
        activityData.isPublic = self.switchIsActivityPublic.isOn
        activityData.activityPhotos = self.selectedImages
        
        self.datsource.addMyActivity(activityData)
        self.datsource.updateTotalRunnrPoints(with: activityData.basePoints + activityData.skillPoints)
        self.datsource.updateTotalDistance(with: activityData.distanceValue)
        
        print("After passing count: \(self.datsource.getMyActivityData().count)")
        
        let destinationVC = ActivitySummaryViewController()
        destinationVC.activityData = self.activityData
        destinationVC.showAlert = true
        
        destinationVC.modalPresentationStyle = .fullScreen
        navigationController?.present(destinationVC, animated: true)
        
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
        
        textViewRemark.layer.cornerRadius = 15
        textViewRemark.layer.borderColor = UIColor.white.cgColor
        textViewRemark.layer.borderWidth = 0.5
        
        imageViewMap.image = self.activityData.mapImage
        imageViewMap.layer.cornerRadius = 15
    }
    
    func SettingLabels() {
        labelPhotos.text = NSLocalizedString( "Photos", comment: "")
        labelDescription.text = NSLocalizedString( "Anyone on Runnr can see your activity", comment: "")
        labelRunSummary.text = NSLocalizedString( "Run Summary", comment: "")
        labelPublicActivity.text = NSLocalizedString( "Public Activity", comment: "")
        labelTimeStamp.text = formatDate(with: self.activityData.timeStamp)
        
        labelDescription.sizeToFit()
        
        labelPace.text = NSLocalizedString( "Pace", comment: "")
        labelPaceValue.text = String(format: "%.2f", self.activityData.paceValue) + " " + self.activityData.paceUnit
        labelTime.text = NSLocalizedString( "Time", comment: "")
        labelTimeValue.text = String(format: "%02d : %02d : %02d", self.activityData.timeHour, self.activityData.timeMin, self.activityData.timeSec)
        labelTimeValue.sizeToFit()
        labelCalories.text = NSLocalizedString( "Calories", comment: "")
        labelCaloriesValue.text = String(format: "%.0f", self.activityData.caloriesValue) + " kcal"
        labelDistance.text = NSLocalizedString( "Distance", comment: "")
        labelDistanceValue.text = String(format: "%.2f", self.activityData.distanceValue) + " " + self.activityData.distanceUnit
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

extension ActivitySaveViewController : PHPickerViewControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    func openPhotoLibrary() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 5

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
            
            if self.selectedImages.count == 0 {
                self.collectionViewAddPhotos.isHidden = true
                self.stackAddPhotos.isHidden = false
                
                self.scrollViewSaveActivity.contentSize.height = self.stackAddPhotos.frame.height + self.stackAddPhotos.frame.origin.y + 10

            }
            else {
                self.collectionViewAddPhotos.reloadData()
                self.scrollViewSaveActivity.contentSize.height = self.collectionViewAddPhotos.frame.height + self.collectionViewAddPhotos.frame.origin.y + 10

            }
            
        }
                
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        self.collectionViewAddPhotos.isHidden = false

        if let image = info[.originalImage] as? UIImage {
            self.selectedImages.append(image)
        }
        
        self.scrollViewSaveActivity.contentSize.height = self.collectionViewAddPhotos.frame.height + self.collectionViewAddPhotos.frame.origin.y + 10

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
        cell.configureCell(with: image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
