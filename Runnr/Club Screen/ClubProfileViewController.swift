import UIKit

class ClubProfileViewController: UIViewController,
                                 UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ClubProfileTableViewCell
        
        cell.configureCell(with: leaderBoardArray[indexPath.row])
//        cell.configureCell(with: friendsDataArray[indexPath.row])
        return cell
    }
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var clubDescription: UILabel!
    @IBOutlet weak var clubProfileImage: UIImageView!
    @IBOutlet weak var joinNowButton: UIButton!

    @IBOutlet var tableViewLeaderBoard: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()

        view.overrideUserInterfaceStyle = .dark

        clubDescription.numberOfLines = 2
        clubDescription.lineBreakMode = .byWordWrapping

        clubProfileImage.layer.cornerRadius = 12
        clubProfileImage.clipsToBounds = true

        joinNowButton.titleLabel?.textColor = .black
        
        tableViewLeaderBoard.dataSource = self
        tableViewLeaderBoard.delegate = self
        tableViewLeaderBoard.register(UINib(nibName: "ClubProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 4
            layout.minimumLineSpacing = 4
            layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        }

    }

   
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        let nib = UINib(
            nibName: "ClubProfileCollectionViewCell",
            bundle: nil
        )
        collectionView.register(nib,forCellWithReuseIdentifier: "cell")
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as! ClubProfileCollectionViewCell

        cell.configureCell(with: postImagesArray[indexPath.row])
       

        return cell
    }


    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (collectionView.frame.width - 20) / 3
        return CGSize(width: width, height: width)
    }
}

