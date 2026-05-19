import UIKit

class WinnerViewController: UIViewController {

    var rewardPoints: Int = 200
    var messageText: String = "You dominated the map and captured the most territories this month."

    // UI Elements
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let trophyImageView = UIImageView()
    private let messageLabel = UILabel()
    private let pointsLabel = UILabel()
    private let claimButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6) // Dimmed background

        // Container
        containerView.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0) // Dark gray
        containerView.layer.cornerRadius = 20
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        // Title
        titleLabel.text = "SEASON\nCHAMPION!"
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .black)
        // Neon green color
        titleLabel.textColor = UIColor(red: 0.68, green: 0.97, blue: 0.27, alpha: 1.0)
        // Simulate italic if possible, but system black font is fine
        if let descriptor = titleLabel.font.fontDescriptor.withSymbolicTraits(.traitItalic) {
            titleLabel.font = UIFont(descriptor: descriptor, size: 32)
        }
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        // Trophy Image (using SF Symbols as placeholder for the generated asset)
        let config = UIImage.SymbolConfiguration(pointSize: 100, weight: .regular)
        trophyImageView.image = UIImage(systemName: "trophy.fill", withConfiguration: config)
        trophyImageView.tintColor = UIColor(red: 0.68, green: 0.97, blue: 0.27, alpha: 1.0) // Accent color
        trophyImageView.contentMode = .scaleAspectFit
        trophyImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(trophyImageView)

        // Message Label
        messageLabel.text = messageText
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.textColor = .lightGray
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)

        // Points Label
        pointsLabel.text = "+\(rewardPoints) POINTS"
        pointsLabel.textAlignment = .center
        pointsLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        pointsLabel.textColor = UIColor(red: 0.68, green: 0.97, blue: 0.27, alpha: 1.0)
        // Add a subtle glow
        pointsLabel.layer.shadowColor = UIColor(red: 0.68, green: 0.97, blue: 0.27, alpha: 1.0).cgColor
        pointsLabel.layer.shadowRadius = 8.0
        pointsLabel.layer.shadowOpacity = 0.5
        pointsLabel.layer.shadowOffset = .zero
        pointsLabel.layer.masksToBounds = false
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(pointsLabel)

        // Claim Button
        claimButton.setTitle("Claim Reward", for: .normal)
        claimButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        claimButton.setTitleColor(.black, for: .normal)
        claimButton.backgroundColor = UIColor(red: 0.68, green: 0.97, blue: 0.27, alpha: 1.0)
        claimButton.layer.cornerRadius = 15
        claimButton.translatesAutoresizingMaskIntoConstraints = false
        claimButton.addTarget(self, action: #selector(claimTapped), for: .touchUpInside)
        containerView.addSubview(claimButton)

        // Constraints
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            trophyImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            trophyImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            trophyImageView.heightAnchor.constraint(equalToConstant: 150),
            trophyImageView.widthAnchor.constraint(equalToConstant: 150),

            messageLabel.topAnchor.constraint(equalTo: trophyImageView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            pointsLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            pointsLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            claimButton.topAnchor.constraint(equalTo: pointsLabel.bottomAnchor, constant: 30),
            claimButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            claimButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            claimButton.heightAnchor.constraint(equalToConstant: 50),
            claimButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ])
    }

    @objc private func claimTapped() {
        if var stats = DataSource.shared.getUserStats() {
            let userID = stats.userID
            stats.totalPointsEarned += rewardPoints
            DataSource.shared.setUserStats(stats)
            Task {
                await updateUserStats(userID: userID, newStats: stats)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
