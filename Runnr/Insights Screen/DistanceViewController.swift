import UIKit

class DistanceViewController: UIViewController {

    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var scrollViewGraph: UIScrollView!
    @IBOutlet weak var segmentControlDistance: UISegmentedControl!
    @IBOutlet weak var collectionViewDistance: UICollectionView!
    @IBOutlet weak var contentViewGraph: UIView!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelDistanceCovered: UILabel!
    @IBOutlet weak var weekRangeLabel: UILabel! // Added like CaloriesVC

    private let daysPerWeek = 7
    private var weeklyBarValues: [[CGFloat]] = []
    private var weeklyDayLabels: [[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Distance"

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        scrollViewGraph.delegate = self
        scrollViewGraph.isPagingEnabled = true
        scrollViewGraph.showsHorizontalScrollIndicator = false

        scrollViewMain.alwaysBounceVertical = false
        scrollViewMain.bounces = false

        scrollViewMain.translatesAutoresizingMaskIntoConstraints = false
        scrollViewMain.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollViewMain.contentLayoutGuide.widthAnchor).isActive = true
        scrollViewMain.contentSize.width = view.frame.width

        // Collection view setup
        collectionViewDistance.dataSource = self
        collectionViewDistance.delegate = self
        let nib = UINib(nibName: "TrendsCollectionViewCell", bundle: nil)
        collectionViewDistance.register(nib, forCellWithReuseIdentifier: "cell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionViewDistance.collectionViewLayout = layout
        collectionViewDistance.reloadData()

        // Segment control styling
        segmentControlDistance.layer.borderWidth = 0.5
        segmentControlDistance.layer.borderColor = UIColor.accent.cgColor
        segmentControlDistance.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)

        setupGraph()
        settingLabelStyle()
        updateWeekLabel(for: 0) // Initialize first week label
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewMain.contentSize.height = collectionViewDistance.frame.height + collectionViewDistance.frame.origin.y + 100
    }

    // MARK: — Label Styling
    func settingLabelStyle() {
        let mediumFont = UIFont(name: "SFProText-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        let thinFont = UIFont(name: "SFProText-Light", size: 10) ?? UIFont.systemFont(ofSize: 10)
        let titleText = NSAttributedString(string: "Distance Covered" + " ", attributes: [.font: mediumFont, .foregroundColor: UIColor.white])
        let unitsText = NSAttributedString(string: "(km)", attributes: [.font: thinFont, .foregroundColor: UIColor.white])

        let fullText = NSMutableAttributedString()
        fullText.append(titleText)
        fullText.append(unitsText)
        labelDistanceCovered.attributedText = fullText

        let boldFont = UIFont(name: "SFProText-Bold", size: 32) ?? UIFont.systemFont(ofSize: 32, weight: .bold)
        let thin2Font = UIFont(name: "SFProText-Light", size: 15) ?? UIFont.systemFont(ofSize: 15)
        let numberText = NSAttributedString(string: "20.3" + " ", attributes: [.font: boldFont, .foregroundColor: UIColor(named: "AccentColor") ?? UIColor.white])
        let unitText = NSAttributedString(string: "km", attributes: [.font: thin2Font, .foregroundColor: UIColor(named: "AccentColor") ?? UIColor.white])

        let fullTexts = NSMutableAttributedString()
        fullTexts.append(numberText)
        fullTexts.append(unitText)
        labelNumber.attributedText = fullTexts
    }

    // MARK: — Setup Graph
    func setupGraph() {
        let barValues: [CGFloat] = setupBarValues()
        let dayLabels: [String] = setupDayLabels()

        let barColor = UIColor(red: 0xAD/255, green: 0xF8/255, blue: 0x45/255, alpha: 1)
        let maxValue = barValues.max() ?? 200
        let maxDisplayHeight: CGFloat = 200

        // Horizontal grid lines
        let numberOfLines = 5
        for i in 0...numberOfLines {
            let line = UIView()
            line.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            line.translatesAutoresizingMaskIntoConstraints = false
            contentViewGraph.addSubview(line)
            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(equalTo: contentViewGraph.leadingAnchor, constant: 25),
                line.trailingAnchor.constraint(equalTo: contentViewGraph.trailingAnchor),
                line.heightAnchor.constraint(equalToConstant: 1),
                line.bottomAnchor.constraint(equalTo: contentViewGraph.bottomAnchor, constant: -50 - (CGFloat(i) / CGFloat(numberOfLines)) * maxDisplayHeight)
            ])
        }

        // Stack view for bars
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .bottom
        stack.spacing = 24
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentViewGraph.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentViewGraph.leadingAnchor, constant: 40),
            stack.topAnchor.constraint(equalTo: contentViewGraph.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: contentViewGraph.bottomAnchor, constant: -50)
        ])
        let stackWidth = CGFloat(barValues.count) * 30 + CGFloat(barValues.count - 1) * 24
        stack.widthAnchor.constraint(equalToConstant: stackWidth).isActive = true

        // Y-axis labels
        for i in 0...5 {
            let label = UILabel()
            label.textColor = .white.withAlphaComponent(0.5)
            label.font = UIFont.systemFont(ofSize: 12)
            let value = Int((CGFloat(5 - i) / 5) * maxValue)
            label.text = "\(value)"
            label.translatesAutoresizingMaskIntoConstraints = false
            contentViewGraph.addSubview(label)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: contentViewGraph.leadingAnchor, constant: 8),
                label.centerYAnchor.constraint(equalTo: contentViewGraph.centerYAnchor, constant: CGFloat(i * 40) - 100)
            ])
        }

        // Bars and day labels
        for (index, value) in barValues.enumerated() {
            let barContainer = UIView()
            barContainer.translatesAutoresizingMaskIntoConstraints = false
            barContainer.widthAnchor.constraint(equalToConstant: 30).isActive = true

            let normalizedHeight = (value / maxValue) * maxDisplayHeight
            let bar = UIView()
            bar.backgroundColor = barColor
            bar.layer.cornerRadius = 8
            bar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bar.translatesAutoresizingMaskIntoConstraints = false
            barContainer.addSubview(bar)

            NSLayoutConstraint.activate([
                bar.bottomAnchor.constraint(equalTo: barContainer.bottomAnchor, constant: 30),
                bar.centerXAnchor.constraint(equalTo: barContainer.centerXAnchor),
                bar.widthAnchor.constraint(equalToConstant: 30),
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

        scrollViewGraph.contentSize.width = stackWidth + 40
        contentViewGraph.frame.size.width = scrollViewGraph.contentSize.width
    }

    // MARK: — Setup bar and day labels (for week scrolling)
    private func setupBarValues() -> [CGFloat] {
        return [
            50, 120, 75, 90, 160, 130, 200,
            40, 180, 110, 70, 150, 90, 210,
            60, 140, 195, 80, 170, 125
        ]
    }

    private func setupDayLabels() -> [String] {
        return [
            "S","M","T","W","T","F","S",
            "M","T","W","T","F","S","M",
            "T","W","T","F","S","M"
        ]
    }
}

// MARK: — UICollectionView extension
extension DistanceViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return distanceTrends.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrendsCollectionViewCell
        let item = distanceTrends[indexPath.row]
        cell.configureCell(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 90)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: — UIScrollViewDelegate for week label
extension DistanceViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollViewGraph else { return }

        let barWidth: CGFloat = 30
        let barSpacing: CGFloat = 24
        let weekWidth = (barWidth + barSpacing) * CGFloat(daysPerWeek)
        let weekIndex = Int(scrollView.contentOffset.x / weekWidth)
        let totalWeeks = Int(ceil(Double(setupBarValues().count) / Double(daysPerWeek)))
        let currentWeek = max(0, min(weekIndex, totalWeeks - 1))

        updateWeekLabel(for: currentWeek)
    }

    private func updateWeekLabel(for index: Int) {
        if let weekDates = getWeekDates(for: index) {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            let start = formatter.string(from: weekDates.start)
            let end = formatter.string(from: weekDates.end)
            weekRangeLabel.text = "\(start) - \(end)"
        }
    }

    private func getWeekDates(for index: Int) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        let today = Date()
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start else { return nil }

        let start = calendar.date(byAdding: .weekOfYear, value: index, to: startOfWeek)!
        let end = calendar.date(byAdding: .day, value: daysPerWeek - 1, to: start)!
        return (start, end)
    }
}

