import UIKit

final class DualProgressBarView: UIView {

    var maxValue: CGFloat = 10 { didSet { setNeedsLayout() } }
    var leftValue: CGFloat = 0 { didSet { setNeedsLayout() } }
    var rightValue: CGFloat = 0 { didSet { setNeedsLayout() } }

    private let trackView = UIView()
    private let leftBar = UIView()
    private let rightBar = UIView()
    private let centerIcon = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear

        trackView.backgroundColor = .systemGray5
        trackView.layer.cornerRadius = 6

        leftBar.backgroundColor = .accent
        rightBar.backgroundColor = .white

        centerIcon.contentMode = .scaleAspectFit
        centerIcon.tintColor = .darkGray   // visible color

        addSubview(trackView)
        addSubview(leftBar)
        addSubview(rightBar)
        addSubview(centerIcon)
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()

        guard window != nil else { return }

        maxValue = 10
        leftValue = 8
        rightValue = 3
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let barHeight: CGFloat = 6
        let halfWidth = bounds.width / 2

        trackView.frame = CGRect(
            x: 0,
            y: bounds.midY - barHeight / 2,
            width: bounds.width,
            height: barHeight
        )

        let leftProgress = min(leftValue / maxValue, 1)
        let rightProgress = min(rightValue / maxValue, 1)

        let leftWidth = halfWidth * leftProgress
        let rightWidth = halfWidth * rightProgress

        leftBar.frame = CGRect(
            x: 0,
            y: trackView.frame.minY,
            width: leftWidth,
            height: barHeight
        )

        rightBar.frame = CGRect(
            x: bounds.width - rightWidth,
            y: trackView.frame.minY,
            width: rightWidth,
            height: barHeight
        )

        leftBar.layer.cornerRadius = barHeight / 2
        rightBar.layer.cornerRadius = barHeight / 2

        updateCenterIcon()
        bringSubviewToFront(centerIcon)
    }

    private func updateCenterIcon() {
        let iconSize: CGFloat = 40
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)

        if leftValue >= rightValue {
            centerIcon.image = UIImage(
                systemName: "flag.filled.and.flag.crossed",
                withConfiguration: config
            )
            centerIcon.tintColor = .accent
        } else {
            centerIcon.image = UIImage(
                systemName: "flag.and.flag.filled.crossed",
                withConfiguration: config
            )
            centerIcon.tintColor = .white
        }

        centerIcon.frame = CGRect(
            x: bounds.midX - iconSize / 2,
            y: trackView.frame.midY - iconSize / 2,
            width: iconSize,
            height: iconSize
        )
    }
}

