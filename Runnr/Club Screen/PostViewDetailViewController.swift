import UIKit

class PostViewDetailViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeContainerView: UIView!
    @IBOutlet weak var likeIconImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var moreOptionButton: UIButton!
    
    // Passing data
    var postImage: UIImage?
    // We can add other data properties as needed

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateData()
    }
    
    private func setupUI() {
        // View Background (very dark green/black)
        view.backgroundColor = UIColor(red: 0.08, green: 0.12, blue: 0.09, alpha: 1.0)
        
        // Profile Image
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor(named: "AccentColor")?.cgColor ?? UIColor.green.cgColor
        
        // Follow Button
        followButton.layer.cornerRadius = followButton.frame.height / 2
        followButton.backgroundColor = UIColor(named: "AccentColor") ?? .green
        followButton.setTitleColor(.black, for: .normal)
        followButton.layer.shadowColor = followButton.backgroundColor?.cgColor
        followButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        followButton.layer.shadowRadius = 8
        followButton.layer.shadowOpacity = 0.5
        
        // More Option Button
        moreOptionButton.layer.cornerRadius = moreOptionButton.frame.height / 2
        moreOptionButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        // Like Container
        likeContainerView.layer.cornerRadius = likeContainerView.frame.height / 2
        likeContainerView.backgroundColor = UIColor(red: 0.08, green: 0.20, blue: 0.10, alpha: 1.0)
        
        // Format Caption text to Highlight Mentions and Hashtags
        formatCaptionText()
    }
    
    private func populateData() {
        postImageView.image = postImage ?? UIImage(named: "post 1")
        profileImageView.image = UIImage(named: "club1") // Dummy profile
        nameLabel.text = "Alex Runner"
        locationLabel.text = "San Francisco, CA"
        timeLabel.text = "2 HOURS AGO"
        likeCountLabel.text = "1,245"
    }
    
    private func formatCaptionText() {
        let text = "Early morning run through the Presidio. The fog was lifting and the air was perfect. Every mile felt like a gift today. #running #fitness #community @run_club"
        
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
            sender.layer.shadowOpacity = 0.5
        }
    }
    
    @IBAction func moreOptionsTapped(_ sender: UIButton) {
        // Add options like share, report, etc.
    }
}
