import UIKit

class GameOverViewController: UIViewController {

    var messageText: String = "You fought hard, but your opponent captured more territories this time."

    // UI Elements
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let iconImageView = UIImageView()
    private let messageLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let dismissButton = UIButton(type: .system)

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
        titleLabel.text = "GAME\nOVER"
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .black)
        // Red-orange color
        titleLabel.textColor = UIColor(red: 0.95, green: 0.30, blue: 0.25, alpha: 1.0)
        if let descriptor = titleLabel.font.fontDescriptor.withSymbolicTraits(.traitItalic) {
            titleLabel.font = UIFont(descriptor: descriptor, size: 32)
        }
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        // Icon (using SF Symbols)
        let config = UIImage.SymbolConfiguration(pointSize: 100, weight: .regular)
        iconImageView.image = UIImage(systemName: "flag.checkered", withConfiguration: config)
        iconImageView.tintColor = UIColor(red: 0.95, green: 0.30, blue: 0.25, alpha: 1.0)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)

        // Message Label
        messageLabel.text = messageText
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.textColor = .lightGray
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)

        // Subtitle Label
        subtitleLabel.text = "Better luck next time! 💪"
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        subtitleLabel.textColor = UIColor(red: 0.95, green: 0.30, blue: 0.25, alpha: 1.0)
        // Add a subtle glow
        subtitleLabel.layer.shadowColor = UIColor(red: 0.95, green: 0.30, blue: 0.25, alpha: 1.0).cgColor
        subtitleLabel.layer.shadowRadius = 8.0
        subtitleLabel.layer.shadowOpacity = 0.5
        subtitleLabel.layer.shadowOffset = .zero
        subtitleLabel.layer.masksToBounds = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subtitleLabel)

        // Dismiss Button
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
        dismissButton.layer.cornerRadius = 15
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        containerView.addSubview(dismissButton)

        // Constraints
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            iconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 150),
            iconImageView.widthAnchor.constraint(equalToConstant: 150),

            messageLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            subtitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            dismissButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            dismissButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            dismissButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            dismissButton.heightAnchor.constraint(equalToConstant: 50),
            dismissButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ])
    }

    @objc private func dismissTapped() {
        dismiss(animated: true, completion: nil)
    }
}
