//
//  IntroductionViewController.swift
//  Runnr
//
//  Created by SDC-USER on 23/01/26.
//

import UIKit

class IntroductionViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewMainBackground: UIView!
    @IBOutlet var viewScreenOne: UIView!
    @IBOutlet var viewScreenTwo: UIView!
    @IBOutlet var viewScreenThree: UIView!
    @IBOutlet weak var viewRunnrCoin: UIView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpScreenElements()
        self.scrollView.delegate = self
        self.settingHorizontalScroll()
    }

    @IBAction func skipButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            let alert = UIAlertController(title: String(localized: "Welcome to RUNR."), message: String(localized: "Congratulations! You’ve earned 100 points!"), preferredStyle: .alert)

            let claimAction = UIAlertAction(title: String(localized: "Claim!"), style: .default, handler: nil)
            alert.addAction(claimAction)
            alert.view.tintColor = .accent
            self.present(alert, animated: true, completion: nil)
        }
    }

    func setUpScreenElements() {
        self.viewMainBackground.layer.cornerRadius = 20
        self.viewMainBackground.layer.shadowColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        self.viewMainBackground.layer.shadowOpacity = 0.5
        self.viewMainBackground.layer.shadowRadius = 20

        self.viewRunnrCoin.layer.cornerRadius = self.viewRunnrCoin.frame.height / 2
        self.viewRunnrCoin.layer.shadowColor = UIColor.accent.withAlphaComponent(0.5).cgColor
        self.viewRunnrCoin.layer.shadowOpacity = 0.5
        self.viewRunnrCoin.layer.shadowRadius = 20

    }
}

// MARK: - Page Control Code & Scroll View Setting

extension IntroductionViewController: UIScrollViewDelegate {

    func settingHorizontalScroll() {

        scrollView.contentSize.width = scrollView.frame.width * 3
        scrollView.contentSize.height = scrollView.frame.height

            for index in 0..<3 {
                let page = UIView(frame: CGRect(x: CGFloat(index) * scrollView.frame.width, y: 0,
                                                width: scrollView.frame.width, height: scrollView.frame.height))
                page.backgroundColor = .yellow

                switch index {
                case 0:
                    self.viewScreenOne.frame = CGRect(x: 0, y: 0, width: page.frame.width, height: page.frame.height)
                    page.addSubview(viewScreenOne)

                case 1:
                    self.viewScreenTwo.frame = CGRect(x: 0, y: 0, width: page.frame.width, height: page.frame.height)

                    page.addSubview(self.viewScreenTwo)

                case 2:
                    self.viewScreenThree.frame = CGRect(x: 0, y: 0, width: page.frame.width, height: page.frame.height)
                    page.addSubview(self.viewScreenThree)

                default: break
                }

                scrollView.addSubview(page)
            }
//        scrollView.contentOffset = CGPoint(x: view.frame.width, y: 0)
    }

    @IBAction func pageValueChanged(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(currentPage) * scrollView.frame.width, y: 0), animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }

}
