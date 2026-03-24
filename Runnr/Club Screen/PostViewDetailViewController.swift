import UIKit
import Kingfisher

class PostViewDetailViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moreOptionButton: UIButton!
    
    //    @IBOutlet weak var likeContainerView: UIView!
    //    @IBOutlet weak var likeIconImageView: UIImageView!
    //    @IBOutlet weak var likeCountLabel: UILabel!
    //    @IBOutlet weak var locationLabel: UILabel!

    private let imageLikeButton = UIButton(type: .custom)
    // Tracks double-tap like state: false = accent, true = red
    private var isImageLiked = false
    
    var postDetails: ClubPostDetail?
    var isLiked: Bool = false
    var likeStatusChanged: ((Bool) -> Void)?
    var isOwner: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateData()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "modalBackground")

        // Hide time label
        timeLabel.isHidden = true

        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor(named: "AccentColor")?.cgColor ?? UIColor.green.cgColor

        if let url = URL(string: (postDetails?.postOwner.userProfileImageURL)!) {
            profileImageView.kf.setImage(with: url)
        }
        
        followButton.layer.cornerRadius = followButton.frame.height / 2
        followButton.backgroundColor = UIColor(named: "AccentColor") ?? .green
        followButton.setTitleColor(.black, for: .normal)
        followButton.layer.shadowOpacity = 0
        
        setGlassEffect(for: self.moreOptionButton, withImage: "ellipsis")
        setupImageLikeButton()
        formatCaptionText()
        
        if isOwner {
            moreOptionButton.isHidden = false
        }
        else {
            moreOptionButton.isHidden = true
        }
        
        // More Option Button
//        moreOptionButton.layer.cornerRadius = moreOptionButton.frame.height / 2
//        moreOptionButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        // Like Container
//        likeContainerView.layer.cornerRadius = likeContainerView.frame.height / 2
//        likeContainerView.backgroundColor = UIColor(red: 0.08, green: 0.20, blue: 0.10, alpha: 1.0)

    }

    private func setupImageLikeButton() {
        // Make imageView interactive
        postImageView.isUserInteractionEnabled = true

        // Configure the like button
        let accentColor = UIColor(named: "AccentColor") ?? UIColor.green
        let heartImage = UIImage(systemName: "heart.fill")
        imageLikeButton.setImage(heartImage, for: .normal)
        self.isImageLiked = self.isLiked
        imageLikeButton.tintColor = self.isLiked ? .systemRed : accentColor
        imageLikeButton.contentVerticalAlignment = .fill
        imageLikeButton.contentHorizontalAlignment = .fill
        imageLikeButton.imageView?.contentMode = .scaleAspectFit
        imageLikeButton.translatesAutoresizingMaskIntoConstraints = false
        imageLikeButton.isUserInteractionEnabled = false // Driven by gesture only

        // Drop shadow so it's visible on any image
        imageLikeButton.layer.shadowColor = UIColor.black.cgColor
        imageLikeButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        imageLikeButton.layer.shadowRadius = 4
        imageLikeButton.layer.shadowOpacity = 0.6

        postImageView.addSubview(imageLikeButton)

        NSLayoutConstraint.activate([
            imageLikeButton.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor, constant: -14),
            imageLikeButton.bottomAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: -14),
            imageLikeButton.widthAnchor.constraint(equalToConstant: 32),
            imageLikeButton.heightAnchor.constraint(equalToConstant: 32)
        ])

        // Double-tap gesture on the imageView
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleImageDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(doubleTap)
    }

    @objc private func handleImageDoubleTap() {
        isImageLiked.toggle()
        likeStatusChanged?(isImageLiked)
        let accentColor = UIColor(named: "AccentColor") ?? UIColor.green
        let newColor: UIColor = isImageLiked ? .systemRed : accentColor

        // Animate the color change with a quick bounce
        UIView.animate(withDuration: 0.15, animations: {
            self.imageLikeButton.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            self.imageLikeButton.tintColor = newColor
        }, completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.imageLikeButton.transform = .identity
            }
        })
    }
    
    private func populateData() {
        if let url = URL(string: postDetails!.post.postImageURL!) {
            postImageView.kf.setImage(with: url)
        }
        
        nameLabel.text = postDetails?.postOwner.userName
        //locationLabel.text = "San Francisco, CA"
        // timeLabel removed — hidden in setupUI
        //likeCountLabel.text = "1,245"
    }
    
    private func formatCaptionText() {
        let text = postDetails?.post.caption ?? ""
        
        // Default attributes
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 15, weight: .regular)
        ]
        
        // Highlight attributes for hashtags and mentions
        let highlightAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "AccentColor") ?? .green,
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ]
        
        let attributedString = NSMutableAttributedString(string: text, attributes: normalAttributes)
        
        // Find words starting with # or @
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        for word in words {
            if word.hasPrefix("#") || word.hasPrefix("@") {
                let range = (text as NSString).range(of: word)
                if range.location != NSNotFound {
                    attributedString.addAttributes(highlightAttributes, range: range)
                }
            }
        }
        
        // Set paragraph style for line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        captionLabel.attributedText = attributedString
    }

    @IBAction func moreOptionClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editPostButton = UIAlertAction(title: String(localized: "Edit Post"), style: .default, handler: {_ in
        })
        let deleteButton = UIAlertAction(title: String(localized: "Delete"), style: .destructive, handler: {_ in
            
            Task {
                await deleteClubPost(postID: self.postDetails!.post.postID!, postImageURL: self.postDetails!.post.postImageURL!)
                self.dismiss(animated: true)
            }
        })
        let cancelButton = UIAlertAction(title: String("Cancel"), style: .cancel)
        
        alert.addAction(editPostButton)
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true)
    }
    
    @IBAction func followTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "Follow" {
            sender.setTitle("Following", for: .normal)
            sender.backgroundColor = .clear
            sender.setTitleColor(UIColor(named: "AccentColor") ?? .green, for: .normal)
            sender.layer.borderWidth = 1
            sender.layer.borderColor = (UIColor(named: "AccentColor") ?? .green).cgColor
            sender.layer.shadowOpacity = 0
        } else {
            sender.setTitle("Follow", for: .normal)
            sender.backgroundColor = UIColor(named: "AccentColor") ?? .green
            sender.setTitleColor(.black, for: .normal)
            sender.layer.borderWidth = 0
            sender.layer.shadowOpacity = 0  // No glow ever
        }
    }
    
}
