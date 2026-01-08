import UIKit

class AveragePaceViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var weekRangeLabel: UILabel!
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var segmentControlAveragePace: UISegmentedControl!
    @IBOutlet weak var labelAveragePace: UILabel!
    @IBOutlet weak var collectionViewPace: UICollectionView!
    @IBOutlet weak var viewYAxis: UIView! // <-- Y-axis view

    // MARK: - Graph Data
    private let daysPerWeek = 7
    private let barSpacing: CGFloat = 26
    private let barWidth: CGFloat = 30
    private var barValues: [CGFloat] =
    [
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

        navigationItem.title = "Average Pace"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        // Scroll view setup
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false

        // Collection view setup
        collectionViewPace.dataSource = self
        collectionViewPace.delegate = self
        let nib = UINib(nibName: "TrendsCollectionViewCell", bundle: nil)
        collectionViewPace.register(nib, forCellWithReuseIdentifier: "cell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionViewPace.collectionViewLayout = layout

        segmentControlAveragePace.layer.borderWidth = 0.5
        segmentControlAveragePace.layer.borderColor = UIColor.accent.cgColor
        segmentControlAveragePace.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)

//        normalizeDataForFullWeeks()
        setupGraph()
        setupYAxis()
        settingLabelStyle()
        updateWeekLabel(for: 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewMain.contentSize.height = collectionViewPace.frame.height + collectionViewPace.frame.origin.y + 100
    }

    // MARK: - Label Styling
    func settingLabelStyle() {
        let mediumFont = UIFont(name: "SFProText-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .bold)
        let thinFont = UIFont(name: "SFProText-Light", size: 10) ?? UIFont.systemFont(ofSize: 10)
        let titleText = NSAttributedString(string: "Average Pace ", attributes: [.font: mediumFont, .foregroundColor: UIColor.white])
        let unitsText = NSAttributedString(string: "(min/km)", attributes: [.font: thinFont, .foregroundColor: UIColor.white])
        let fullText = NSMutableAttributedString()
        fullText.append(titleText)
        fullText.append(unitsText)
        labelAveragePace.attributedText = fullText

        let boldFont = UIFont(name: "SFProText-Bold", size: 32) ?? UIFont.systemFont(ofSize: 32, weight: .bold)
        let thin2Font = UIFont(name: "SFProText-Light", size: 15) ?? UIFont.systemFont(ofSize: 15)
        let numberText = NSAttributedString(string: "8:30 ", attributes: [.font: boldFont, .foregroundColor: UIColor(named: "AccentColor") ?? UIColor.white])
        let unitText = NSAttributedString(string: "min/km", attributes: [.font: thin2Font, .foregroundColor: UIColor(named: "AccentColor") ?? UIColor.white])
        let fullTexts = NSMutableAttributedString()
        fullTexts.append(numberText)
        fullTexts.append(unitText)
        labelNumber.attributedText = fullTexts
    }

//    // MARK: - Normalize Data
//    private func normalizeDataForFullWeeks() {
//        let remainder = barValues.count % daysPerWeek
//        if remainder == 0 { return }
//        let paddingNeeded = daysPerWeek - remainder
//        for _ in 0..<paddingNeeded {
//            barValues.append(0)
//            dayLabels.append("")
//        }
//    }

    // MARK: - Graph Setup
    func setupGraph() {
        contentView.subviews.forEach { $0.removeFromSuperview() } // Clear previous

        let barColor = UIColor(red: 0xAD/255, green: 0xF8/255, blue: 0x45/255, alpha: 1)
        let maxValue = barValues.max() ?? 200
        let maxDisplayHeight: CGFloat = 200

        // Horizontal lines on graph
        let numberOfLines = 5
        for i in 0...numberOfLines {
            let line = UIView()
            line.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            line.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(line)
            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
                line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                line.heightAnchor.constraint(equalToConstant: 1),
                line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50 - (CGFloat(i)/CGFloat(numberOfLines))*maxDisplayHeight)
            ])
        }

        // Stack view for bars
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

        let stackWidth = CGFloat(barValues.count) * barWidth + CGFloat(barValues.count-1) * barSpacing + 22
        stack.widthAnchor.constraint(equalToConstant: stackWidth).isActive = true

        // Bars
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

    // MARK: - Y-axis Setup
    private func setupYAxis() {
        viewYAxis.subviews.forEach { $0.removeFromSuperview() } // Clear previous
        let maxValue = barValues.max() ?? 200
        let maxDisplayHeight: CGFloat = 200
        let intervals = 5

        for i in 0...intervals {
            let label = UILabel()
            label.textColor = .white.withAlphaComponent(0.5)
            label.font = UIFont.systemFont(ofSize: 12)
            label.textAlignment = .right
            let value = Int((CGFloat(intervals-i)/CGFloat(intervals)) * maxValue)
            label.text = "\(value)"
            label.translatesAutoresizingMaskIntoConstraints = false
            viewYAxis.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.trailingAnchor.constraint(equalTo: viewYAxis.trailingAnchor, constant: -4),
                label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: CGFloat(i*40)-100)
            ])
        }
    }
}

// MARK: - UICollectionView
extension AveragePaceViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return averagePaceTrends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrendsCollectionViewCell
        cell.configureCell(with: averagePaceTrends[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - UIScrollViewDelegate
extension AveragePaceViewController: UIScrollViewDelegate {
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
            weekRangeLabel.text = "\(formatter.string(from: weekDates.start)) - \(formatter.string(from: weekDates.end))"
        }
    }
    
    private func getWeekDates(for index: Int) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else { return nil }
        let start = calendar.date(byAdding: .weekOfYear, value: index, to: startOfWeek)!
        let end = calendar.date(byAdding: .day, value: daysPerWeek-1, to: start)!
        return (start, end)
    }
}

