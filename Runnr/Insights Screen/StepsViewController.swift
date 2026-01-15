import UIKit

class StepsViewController: UIViewController {

    @IBOutlet weak var segmentControlSteps: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionViewSteps: UICollectionView!
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var viewYAxis: UIView!
    @IBOutlet weak var labelStepsCovered: UILabel!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var weekRangeLabel: UILabel!

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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Steps"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false

        collectionViewSteps.dataSource = self
        collectionViewSteps.delegate = self
        let nib = UINib(nibName: "TrendsCollectionViewCell", bundle: nil)
        collectionViewSteps.register(nib, forCellWithReuseIdentifier: "cell")

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionViewSteps.collectionViewLayout = layout

        segmentControlSteps.layer.borderWidth = 0.5
        segmentControlSteps.layer.borderColor = UIColor.accent.cgColor
        segmentControlSteps.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)

        setupGraph()
        setupYAxis()
        settingLabelStyle()
        updateWeekLabel(for: 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewMain.contentSize.height =
        collectionViewSteps.frame.height + collectionViewSteps.frame.origin.y + 100
    }

    func settingLabelStyle() {
        let mediumFont = UIFont.systemFont(ofSize: 15, weight: .bold)
        let thinFont = UIFont.systemFont(ofSize: 10)

        let titleText = NSAttributedString(
            string: "Steps Covered ",
            attributes: [.font: mediumFont, .foregroundColor: UIColor.white]
        )
        let unitText = NSAttributedString(
            string: "(k)",
            attributes: [.font: thinFont, .foregroundColor: UIColor.white]
        )

        let fullTitle = NSMutableAttributedString()
        fullTitle.append(titleText)
        fullTitle.append(unitText)
        labelStepsCovered.attributedText = fullTitle

        let boldFont = UIFont.systemFont(ofSize: 32, weight: .bold)
        let thin2Font = UIFont.systemFont(ofSize: 15)

        let numberText = NSAttributedString(
            string: "8000 ",
            attributes: [.font: boldFont, .foregroundColor: UIColor.accent]
        )
        let unit2Text = NSAttributedString(
            string: "k",
            attributes: [.font: thin2Font, .foregroundColor: UIColor.accent]
        )

        let fullNumber = NSMutableAttributedString()
        fullNumber.append(numberText)
        fullNumber.append(unit2Text)
        labelNumber.attributedText = fullNumber
    }

    func setupGraph() {
        contentView.subviews.forEach { $0.removeFromSuperview() }

        let barColor = UIColor(red: 0xAD/255, green: 0xF8/255, blue: 0x45/255, alpha: 1)
        let maxValue = barValues.max() ?? 200
        let maxDisplayHeight: CGFloat = 200

        // Horizontal grid lines
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
                    constant: -50 - (CGFloat(i) / CGFloat(numberOfLines)) * maxDisplayHeight
                )
            ])
        }

        // Stack view
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

        // Bars
        for (index, value) in barValues.enumerated() {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            container.widthAnchor.constraint(equalToConstant: barWidth).isActive = true

            let height = (value / maxValue) * maxDisplayHeight
            let bar = UIView()
            bar.backgroundColor = barColor
            bar.layer.cornerRadius = 8
            bar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bar.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(bar)

            NSLayoutConstraint.activate([
                bar.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                bar.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                bar.widthAnchor.constraint(equalToConstant: barWidth),
                bar.heightAnchor.constraint(equalToConstant: height)
            ])

            let label = UILabel()
            label.text = dayLabels[index]
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 13)
            label.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: bar.bottomAnchor, constant: 4),
                label.centerXAnchor.constraint(equalTo: bar.centerXAnchor)
            ])

            stack.addArrangedSubview(container)
        }

        scrollView.contentSize.width = stackWidth + 50
        contentView.frame.size.width = scrollView.contentSize.width
    }

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

extension StepsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stepsCoveredTrends.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrendsCollectionViewCell
        cell.configureCell(with: stepsCoveredTrends[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 90)
    }
}

extension StepsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }

        let weekWidth = (barWidth + barSpacing) * CGFloat(daysPerWeek)
        let midX = scrollView.contentOffset.x + scrollView.frame.width / 2
        let weekIndex = Int(midX / weekWidth)
        let totalWeeks = barValues.count / daysPerWeek
        updateWeekLabel(for: max(0, min(weekIndex, totalWeeks - 1)))
    }

    private func updateWeekLabel(for index: Int) {
        if let week = getWeekDates(for: index) {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            weekRangeLabel.text =
            "\(formatter.string(from: week.start)) - \(formatter.string(from: week.end))"
        }
    }

    private func getWeekDates(for index: Int) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else { return nil }
        let start = calendar.date(byAdding: .weekOfYear, value: index, to: startOfWeek)!
        let end = calendar.date(byAdding: .day, value: daysPerWeek - 1, to: start)!
        return (start, end)
    }
}

