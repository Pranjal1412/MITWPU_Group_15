import UIKit

class GameImageViewController: UIViewController {

    @IBOutlet weak var buttonImage: UIButton!
    @IBOutlet weak var viewFriend: UIView!
    @IBOutlet weak var imageViewYou: UIImageView!
    @IBOutlet weak var imageViewFriend: UIImageView!
    @IBOutlet weak var labelYou: UILabel!
    @IBOutlet weak var labelYourPoints: UILabel!
    @IBOutlet weak var labelFriend: UILabel!
    @IBOutlet weak var labelFriendPoints: UILabel!
    @IBOutlet weak var viewYou: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)

        viewYou.layer.cornerRadius = 15
        viewYou.clipsToBounds = true

        viewFriend.layer.cornerRadius = 15
        viewFriend.clipsToBounds = true

        setupCloseButton()
    }

    
    private func setupCloseButton() {

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        closeButton.tintColor = .black

        closeButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        closeButton.layer.cornerRadius = 18
        closeButton.clipsToBounds = true

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            closeButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

