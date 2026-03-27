//
//  GameDescriptionViewController.swift
//  Runnr
//
//  Created by Mrunal Aralkar on 27/03/26.
//

import UIKit

class GameDescriptionViewController: UIViewController {

    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var view7: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var view9: UIView!
    @IBOutlet weak var numberView2: UIView!
    @IBOutlet weak var numberView1: UIView!
    @IBOutlet weak var numberView4: UIView!
    @IBOutlet weak var numberView3: UIView!
    @IBOutlet weak var view8: UIView!
    @IBOutlet weak var imageViewTrophy: UIImageView!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var imageView1: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupScrollView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.viewWithTag(999) == nil {
            addDismissButton()
        }
        setScrollContentSize()
    }
    
    func setupScrollView() {
        scrollViewMain.showsVerticalScrollIndicator = false
        scrollViewMain.showsHorizontalScrollIndicator = false
        scrollViewMain.alwaysBounceVertical = true
        scrollViewMain.contentInsetAdjustmentBehavior = .automatic
    }

    func setScrollContentSize() {
        var maxY: CGFloat = 0
        for subview in scrollViewMain.subviews {
            let bottomEdge = subview.frame.maxY
            if bottomEdge > maxY {
                maxY = bottomEdge
            }
        }
        scrollViewMain.contentSize = CGSize(width: scrollViewMain.frame.width, height: maxY + 32)
    }

    func setup() {
        view1.layer.cornerRadius = 15
        view2.layer.cornerRadius = 15
        view3.layer.cornerRadius = 15
        view4.layer.cornerRadius = 15
        view5.layer.cornerRadius = 15
        view6.layer.cornerRadius = 15
        view7.layer.cornerRadius = 15
        view8.layer.cornerRadius = 15
        view9.layer.cornerRadius = 15

        imageView1.layer.cornerRadius = imageView1.frame.height / 2
        imageView2.layer.cornerRadius = imageView1.frame.height / 2
        imageView3.layer.cornerRadius = imageView1.frame.height / 2
        imageView4.layer.cornerRadius = imageView1.frame.height / 2
        imageViewTrophy.layer.cornerRadius = 30
        numberView1.layer.cornerRadius = imageView1.frame.height / 2
        numberView2.layer.cornerRadius = imageView1.frame.height / 2
        numberView3.layer.cornerRadius = imageView1.frame.height / 2
        numberView4.layer.cornerRadius = imageView1.frame.height / 2

        view1.layer.borderWidth = 1
        view1.layer.borderColor = UIColor.systemGray5.cgColor
        view2.layer.borderWidth = 1
        view2.layer.borderColor = UIColor.systemGray5.cgColor
        view3.layer.borderWidth = 1
        view3.layer.borderColor = UIColor.systemGray5.cgColor
        view4.layer.borderWidth = 1
        view4.layer.borderColor = UIColor.systemGray5.cgColor
        view5.layer.borderWidth = 1
        view5.layer.borderColor = UIColor.systemGray5.cgColor
        view6.layer.borderWidth = 1
        view6.layer.borderColor = UIColor.systemGray5.cgColor
        view7.layer.borderWidth = 1
        view7.layer.borderColor = UIColor.systemGray5.cgColor
        view8.layer.borderWidth = 1
        view8.layer.borderColor = UIColor.systemGray5.cgColor
        view9.layer.borderWidth = 1
        view9.layer.borderColor = UIColor.accent.cgColor
    }

    func addDismissButton() {
        let size: CGFloat = 44
        let padding: CGFloat = 16
        let glassButton = UIButton(type: .custom)
        glassButton.tag = 999
        glassButton.frame = CGRect(
            x: padding,                          // top LEFT
            y: view.safeAreaInsets.top + padding,
            width: size,
            height: size
        )
        glassButton.layer.cornerRadius = size / 2
        glassButton.clipsToBounds = true

        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = glassButton.bounds
        blurView.isUserInteractionEnabled = false
        glassButton.insertSubview(blurView, at: 0)

        let vibrancy = UIVibrancyEffect(blurEffect: blur)
        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        vibrancyView.frame = blurView.bounds

        let xLabel = UILabel(frame: vibrancyView.bounds)
        xLabel.text = "✕"
        xLabel.textAlignment = .center
        xLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        xLabel.textColor = .white
        vibrancyView.contentView.addSubview(xLabel)
        blurView.contentView.addSubview(vibrancyView)

        glassButton.layer.borderWidth = 0.5
        glassButton.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor

        glassButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        view.addSubview(glassButton)
    }

    func makeAttributedString(boldText: String, normalText: String, fontSize: CGFloat = 16) -> NSAttributedString {
        let attributed = NSMutableAttributedString()

        let boldPart = NSAttributedString(
            string: boldText,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: fontSize),
                .foregroundColor: UIColor.label
            ]
        )

        let normalPart = NSAttributedString(
            string: normalText,
            attributes: [
                .font: UIFont.systemFont(ofSize: fontSize),
                .foregroundColor: UIColor.label
            ]
        )

        attributed.append(boldPart)
        attributed.append(normalPart)

        return attributed
    }

    @objc func dismissSelf() {
        dismiss(animated: true)
    }
}
