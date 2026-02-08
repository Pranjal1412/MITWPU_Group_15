import UIKit

class FriendsActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewMainBackground: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelRunTitle: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelPace: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDistanceContent: UILabel!
    @IBOutlet weak var labelPaceContent: UILabel!
    @IBOutlet weak var labelTimeContent: UILabel!
    @IBOutlet weak var labelNote: UILabel!
    @IBOutlet weak var labelDummy: UILabel!
    @IBOutlet weak var collectionViewPhotos: UICollectionView!
    private var photos: [UIImage] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 20
        selectionStyle = .none

        collectionViewPhotos.dataSource = self
        collectionViewPhotos.delegate   = self

        let nib = UINib(nibName: "FriendsPhotosCollectionViewCell", bundle: nil)
        collectionViewPhotos.register(nib,forCellWithReuseIdentifier: "friendCell")
        
        self.viewMainBackground.layer.cornerRadius = 20
    }

    func configure(with activity: UserActivity) {
        labelName.text = "Ava Brooks"
        labelDate.text = formatDate(with: activity.activityStartTime!)
        labelRunTitle.text = activity.activityTitle
        
        self.labelDummy.text = ""
        if activity.activityRemark != "" {
            self.labelDummy.text = "Dummy Text"
        }
        
        labelNote.text = activity.activityRemark
        labelDistance.text = "Distance"
        labelPace.text = "Pace"
        labelTime.text = "Time"
        imageProfile.layer.cornerRadius = imageProfile.frame.height / 2
        let valueFont = UIFont(name: "SFProText-Medium", size: 20)
            ?? UIFont.systemFont(ofSize: 20, weight: .medium)
        let unitFont = UIFont(name: "SFProText-Light", size: 11)
            ?? UIFont.systemFont(ofSize: 11, weight: .light)
        let highlightColor = UIColor(red: 173/255, green: 248/255, blue: 69/255, alpha: 1)
        let distanceValue = String(format: "%.1f", activity.distanceCovered!)
        let distanceText = NSMutableAttributedString(string: distanceValue,
                                                     attributes: [.font: valueFont, .foregroundColor: highlightColor])
        distanceText.append(NSAttributedString(string: " " + activity.distanceUnit!.rawValue,
                                               attributes: [.font: unitFont, .foregroundColor: highlightColor]))
        labelDistanceContent.attributedText = distanceText
        let paceText = NSMutableAttributedString(string: String(format: "%.1f", activity.avgPace!),
                                                 attributes: [.font: valueFont, .foregroundColor: highlightColor])
        paceText.append(NSAttributedString(string: " " + activity.paceUnit!.rawValue,
                                           attributes: [.font: unitFont, .foregroundColor: highlightColor]))
        labelPaceContent.attributedText = paceText
        var timeText = NSMutableAttributedString()
        
        let formattedTime = formatTime(activity.timeTakenSeconds!)

        if formattedTime.hour != 0 {
            timeText = NSMutableAttributedString(string: String(format: "%02d", formattedTime.hour), attributes: [.font: valueFont, .foregroundColor: UIColor.accent])
            timeText.append(NSAttributedString(string: "hr ", attributes: [.font: unitFont, .foregroundColor: UIColor.accent]))
        }
        
        timeText.append(NSAttributedString(string: String(format: "%02d", formattedTime.minute), attributes: [.font: valueFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: "min ", attributes: [.font: unitFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: " " + String(format: "%02d", formattedTime.second), attributes: [.font: valueFont, .foregroundColor: UIColor.accent]))
        
        timeText.append(NSAttributedString(string: "sec", attributes: [.font: unitFont, .foregroundColor: UIColor.accent]))
        
        labelTimeContent.attributedText = timeText
        
        labelPaceContent.minimumScaleFactor = 0.5
        collectionViewPhotos.backgroundColor = .clear
//        setPhotos(activity.activityPhotos)
    }

    func setPhotos(_ names: [UIImage]) {
        photos = names
        print("photos in cell:", photos)
    }
}

//MARK: - CollectionView Settings
extension FriendsActivityTableViewCell: UICollectionViewDataSource,
                                        UICollectionViewDelegate,
                                        UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell",for: indexPath) as! FriendsPhotosCollectionViewCell

        let imageName = photos[indexPath.row]
        cell.configure(with: imageName)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = 152.0
        let height = collectionView.bounds.height
        if indexPath.row == 2 {
            width = collectionView.bounds.width - 32.0
            
        }
        return CGSize(width: width, height: height)

    }
    
}
