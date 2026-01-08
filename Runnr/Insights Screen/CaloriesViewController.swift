import UIKit

class CaloriesViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var weekRangeLabel: UILabel!
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var segmentControlCalories: UISegmentedControl!
    @IBOutlet weak var labelCaloriesBurnt: UILabel!
    @IBOutlet weak var collectionViewCalories: UICollectionView!
    @IBOutlet weak var viewYAxis: UIView!

    // MARK: - Graph Data
    private let daysPerWeek = 7
    private let barSpacing: CGFloat = 26
    private let barWidth: CGFloat = 30
    private var barValues: [CGFloat] = [
        50, 120, 75, 90, 160, 130, 200,
        40, 180, 110, 70, 150, 90, 210,
        60, 140, 195, 80, 170, 125, 230
    ]
    private var dayLabels: [String] = [
        "S","M","T","W","T","F","S",
        "S","M","T","W","T","F","S",
        "S","M","T","W","T","F","S"
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Calories"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false

        collectionViewCalories.dataSource = self
        collectionViewCalories.delegate = self
        let nib = UINib(nibName: "TrendsCollectionViewCell", bundle: nil)
        collectionViewCalories.register(nib, forCellWithReuseIdentifier: "cell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionViewCalories.collectionViewLayout = layout

        segmentControlCalories.layer.borderWidth = 0.5
        segmentControlCalories.layer.borderColor = UIColor.accent.cgColor
        segmentControlCalories.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)

        setupGraph()
        setupYAxis()
        settingLabelStyle()
        updateWeekLabel(for: 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewMain.contentSize.height =
        collectionViewCalories.frame.height +
        collectionViewCalories.frame.origin.y + 100
    }

    // MARK: - Label Styling
    func settingLabelStyle() {
        let mediumFont = UIFont.systemFont(ofSize: 15, weight: .bold)
        let thinFont = UIFont.systemFont(ofSize: 10)

        let titleText = NSAttributedString(
            string: "Calories Burnt ",
            attributes: [.font: mediumFont, .foregroundColor: UIColor.white]
        )
        let unitsText = NSAttributedString(
            string: "(kcal)",
            attributes: [.font: thinFont, .foregroundColor: UIColor.white]
        )

        let fullText = NSMutableAttributedString()
        fullText.append(titleText)
        fullText.append(unitsText)
        labelCaloriesBurnt.attributedText = fullText

        let boldFont = UIFont.systemFont(ofSize: 32, weight: .bold)
        let thin2Font = UIFont.systemFont(ofSize: 15)

        let numberText = NSAttributedString(
            string: "230 ",
            attributes: [.font: boldFont, .foregroundColor: UIColor.accent]
        )
        let unitText = NSAttributedString(
            string: "kcal",
            attributes: [.font: thin2Font, .foregroundColor: UIColor.accent]
        )

        let fullTexts = NSMutableAttributedString()
        fullTexts.append(numberText)
        fullTexts.append(unitText)
        labelNumber.attributedText = fullTexts
    }

    // MARK: - Graph Setup
    func setupGraph() {
        contentView.subviews.forEach { $0.removeFromSuperview() }

        let barColor = UIColor(red: 0xAD/255, green: 0xF8/255, blue: 0x45/255, alpha: 1)
        let maxValue = barValues.max() ?? 200
        let maxDisplayHeight: CGFloat = 200

        let numberOfLines = 5
        for i in 0...numberOfLines {
            let line = UIView()
            line.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            line.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(line)

            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                line.heightAnchor.constraint(equalToConstant: 1),
                line.bottomAnchor.constraint(
                    equalTo: contentView.bottomAnchor,
                    constant: -50 - (CGFloat(i)/CGFloat(numberOfLines)) * maxDisplayHeight
                )
            ])
        }

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .bottom
        stack.spacing = barSpacing
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])

        let stackWidth =
        CGFloat(barValues.count) * barWidth +
        CGFloat(barValues.count - 1) * barSpacing + 22

        stack.widthAnchor.constraint(equalToConstant: stackWidth).isActive = true

        for (index, value) in barValues.enumerated() {
            let barContainer = UIView()
            barContainer.translatesAutoresizingMaskIntoConstraints = false
            barContainer.widthAnchor.constraint(equalToConstant: barWidth).isActive = true

            let normalizedHeight = (value / maxValue) * maxDisplayHeight

            let bar = UIView()
            bar.backgroundColor = barColor
            bar.layer.cornerRadius = 8
            bar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bar.translatesAutoresizingMaskIntoConstraints = false
            barContainer.addSubview(bar)

            NSLayoutConstraint.activate([
                bar.bottomAnchor.constraint(equalTo: barContainer.bottomAnchor),
                bar.centerXAnchor.constraint(equalTo: barContainer.centerXAnchor),
                bar.widthAnchor.constraint(equalToConstant: barWidth),
                bar.heightAnchor.constraint(equalToConstant: normalizedHeight)
            ])

            let label = UILabel()
            label.text = dayLabels[index]
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 13)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            barContainer.addSubview(label)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: bar.bottomAnchor, constant: 4),
                label.centerXAnchor.constraint(equalTo: bar.centerXAnchor)
            ])

            stack.addArrangedSubview(barContainer)
        }

        scrollView.contentSize.width = stackWidth + 50
        contentView.frame.size.width = scrollView.contentSize.width
    }

    // MARK: - Y Axis
    private func setupYAxis() {
        viewYAxis.subviews.forEach { $0.removeFromSuperview() }

        let maxValue = barValues.max() ?? 200
        let intervals = 5

        for i in 0...intervals {
            let label = UILabel()
            label.textColor = .white.withAlphaComponent(0.5)
            label.font = UIFont.systemFont(ofSize: 12)
            label.textAlignment = .right

            let value = Int((CGFloat(intervals - i) / CGFloat(intervals)) * maxValue)
            label.text = "\(value)"
            label.translatesAutoresizingMaskIntoConstraints = false
            viewYAxis.addSubview(label)

            NSLayoutConstraint.activate([
                label.trailingAnchor.constraint(equalTo: viewYAxis.trailingAnchor, constant: -4),
                label.centerYAnchor.constraint(
                    equalTo: contentView.centerYAnchor,
                    constant: CGFloat(i * 40) - 100
                )
            ])
        }
    }
}

// MARK: - UICollectionView
extension CaloriesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        caloriesBurntTrends.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as! TrendsCollectionViewCell
        cell.configureCell(with: caloriesBurntTrends[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 90)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

// MARK: - UIScrollViewDelegate
extension CaloriesViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }

        let weekWidth = (barWidth + barSpacing) * CGFloat(daysPerWeek)
        let midPointX = scrollView.contentOffset.x + scrollView.frame.width / 2
        let weekIndex = Int(midPointX / weekWidth)
        let totalWeeks = barValues.count / daysPerWeek
        let currentWeek = max(0, min(weekIndex, totalWeeks - 1))
        updateWeekLabel(for: currentWeek)
    }

    private func updateWeekLabel(for index: Int) {
        if let weekDates = getWeekDates(for: index) {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            weekRangeLabel.text =
            "\(formatter.string(from: weekDates.start)) - \(formatter.string(from: weekDates.end))"
        }
    }

    private func getWeekDates(for index: Int) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        guard let startOfWeek =
                calendar.dateInterval(of: .weekOfYear, for: Date())?.start else { return nil }

        let start = calendar.date(byAdding: .weekOfYear, value: index, to: startOfWeek)!
        let end = calendar.date(byAdding: .day, value: daysPerWeek - 1, to: start)!
        return (start, end)
    }
}

