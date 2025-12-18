//
//  GameScreenViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 26/10/25.
//

import UIKit

class GameScreenViewController: UIViewController {

    @IBOutlet weak var collectionViewOngoing: UICollectionView!
    @IBOutlet weak var buttonClub: UIButton!
    @IBOutlet weak var collectionViewUpcoming: UICollectionView!
    @IBOutlet weak var button1V1: UIButton!
    @IBOutlet weak var collectionViewCompleted: UICollectionView!
    @IBOutlet weak var segmentedControlGame: UISegmentedControl!

    @IBOutlet weak var labelScreenTitle: UILabel!
    
    private let sideInset: CGFloat = 15
    private let cellHeight: CGFloat = 166

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        setupSegmentedControl()
        setupCollectionView()
        setupButtons()
        collectionViewOngoing.isHidden = false
        collectionViewUpcoming.isHidden = true
        collectionViewCompleted.isHidden = true
        labelScreenTitle.sizeToFit()
    }

    // MARK: - Layout

    private func configureLayout() {
        if let layout = collectionViewOngoing.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.sectionInset = .zero
            layout.minimumLineSpacing = 16
            layout.estimatedItemSize = .zero
        }
    }

    // MARK: - Setup

    private func setupCollectionView() {
        collectionViewOngoing.delegate = self
        collectionViewOngoing.dataSource = self
        collectionViewOngoing.showsVerticalScrollIndicator = false

        collectionViewUpcoming.delegate = self
        collectionViewUpcoming.dataSource = self
        collectionViewUpcoming.showsVerticalScrollIndicator = false

        collectionViewCompleted.delegate = self
        collectionViewCompleted.dataSource = self
        collectionViewCompleted.showsVerticalScrollIndicator = false

        collectionViewOngoing.register(
            UINib(nibName: "GameOngoingCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "cellGame"
        )

        collectionViewUpcoming.register(
            UINib(nibName: "GameUpcomingCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "upcomingCell"
        )

        collectionViewCompleted.register(
            UINib(nibName: "GameCompletedCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "CompletedCell"
        )
    }

    private func setupSegmentedControl() {
        segmentedControlGame.layer.borderColor = UIColor.accent.cgColor
        segmentedControlGame.layer.borderWidth = 0.5
        segmentedControlGame.setTitleTextAttributes(
            [.foregroundColor: UIColor.black],
            for: .selected
        )
    }

    private func setupButtons() {
        button1V1.layer.cornerRadius = button1V1.frame.height / 2
        buttonClub.layer.cornerRadius = buttonClub.frame.height / 2
    }

    @IBAction func segmentControlChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            collectionViewOngoing.isHidden = true
            collectionViewUpcoming.isHidden = false
            collectionViewCompleted.isHidden = true
        } else if sender.selectedSegmentIndex == 2 {
            collectionViewOngoing.isHidden = true
            collectionViewUpcoming.isHidden = true
            collectionViewCompleted.isHidden = false
        } else {
            collectionViewOngoing.isHidden = false
            collectionViewUpcoming.isHidden = true
            collectionViewCompleted.isHidden = true
        }
    }
}

// MARK: - Collection View Delegates

extension GameScreenViewController: UICollectionViewDelegate,
                                     UICollectionViewDataSource,
                                     UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewOngoing {
            return currentGame.count
        } else if collectionView == collectionViewUpcoming {
            return upcomingGame.count
        } else if collectionView == collectionViewCompleted {
            return completedGame.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == collectionViewOngoing {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cellGame",
                for: indexPath
            ) as! GameOngoingCollectionViewCell

            let game = currentGame[indexPath.item]
            cell.configure(with: game)
            return cell

        } else if collectionView == collectionViewUpcoming {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "upcomingCell",
                for: indexPath
            ) as! GameUpcomingCollectionViewCell

            let game = upcomingGame[indexPath.item]
            cell.configure(with: game)
            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CompletedCell",
                for: indexPath
            ) as! GameCompletedCollectionViewCell

            let game = completedGame[indexPath.item]
            cell.configure(with: game)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.bounds.width - (sideInset * 2)
        
        if collectionView == collectionViewOngoing || collectionView == collectionViewUpcoming {
            return CGSize(width: width, height: 140)
        }
        return CGSize(width: width, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(
            top: 0,
            left: sideInset,
            bottom: 25,
            right: sideInset
        )
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    // navigate to game image view controller
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        guard collectionView == collectionViewOngoing else { return }

        let destinationVC = BattleRunViewController(nibName: "BattleRunViewController",bundle: nil)

        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true , completion: nil)
        
    }

}

