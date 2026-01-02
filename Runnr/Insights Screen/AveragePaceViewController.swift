import UIKit

class AveragePaceViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var weekRangeLabel: UILabel!
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var segmentControlAveragePace: UISegmentedControl!
    @IBOutlet weak var labelAveragePace: UILabel!
    @IBOutlet weak var collectionViewPace: UICollectionView!
    
    private let daysPerWeek = 7
    private var weeklyBarValues: [[CGFloat]] = []
    private var weeklyDayLabels: [[String]] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollViewMain.alwaysBounceVertical = false
        scrollViewMain.bounces = false
        navigationItem.title = "Average Pace"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 22, weight: .bold)
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        // Enable main scroll view
        scrollViewMain.translatesAutoresizingMaskIntoConstraints = false
        scrollViewMain.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollViewMain.contentLayoutGuide.widthAnchor).isActive = true
        scrollViewMain.contentSize.width = view.frame.width
        
        navigationItem.hidesBackButton = false
        
        // Register NIB
        let nib = UINib(nibName: "TrendsCollectionViewCell", bundle: nil)
        collectionViewPace.register(nib, forCellWithReuseIdentifier: "cell")
        
        // Set data source and delegate
        collectionViewPace.dataSource = self
        collectionViewPace.delegate = self
        
        // Layout for vertical collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionViewPace.collectionViewLayout = layout
        segmentControlAveragePace.layer.borderWidth = 0.5
        segmentControlAveragePace.layer.borderColor = UIColor.accent.cgColor
        segmentControlAveragePace.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)

        scrollView.contentSize.width = view.frame.width
        contentView.frame.size.width = scrollView.contentSize.width

        setupGraph()
        settingLabelStyle()
        
        // Initialize week label for first week
        updateWeekLabel(for: 0)
    }
    
    func settingLabelStyle() {
        
        let mediumFont = UIFont(name: "SFProText-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        let thinFont = UIFont(name: "SFProText-Light", size: 10) ?? UIFont.systemFont(ofSize: 10)
        let titleText = NSAttributedString(string: "Average Pace" + " ", attributes: [.font: mediumFont, .foregroundColor: UIColor.white])
        let unitsText = NSAttributedString(string: "(min/km)", attributes: [.font: thinFont, .foregroundColor: UIColor.white])

        let fullText = NSMutableAttributedString()
        fullText.append(titleText)
        fullText.append(unitsText)

        labelAveragePace.attributedText = fullText
        
        let boldFont = UIFont(name: "SFProText-Bold", size: 32) ?? UIFont.systemFont(ofSize: 32, weight: .bold)
        let thin2Font = UIFont(name: "SFProText-Light", size: 15) ?? UIFont.systemFont(ofSize: 15)
        let numberText = NSAttributedString(string: "7:90" + " ", attributes: [.font: boldFont, .foregroundColor:UIColor(named: "AccentColor") ?? UIColor.white])
        let unitText = NSAttributedString(string: "min/km", attributes: [.font: thin2Font, .foregroundColor:UIColor(named: "AccentColor") ?? UIColor.white])

        let fullTexts = NSMutableAttributedString()
        fullTexts.append(numberText)
        fullTexts.append(unitText)

        labelNumber.attributedText = fullTexts
        
    }

    func setupGraph() {

        let barValues: [CGFloat] = [
            50, 120, 75, 90, 160, 130, 200,
            40, 180, 110, 70, 150, 90, 210,
            60, 140, 195, 80, 170, 125,230,
            450, 250, 165, 280, 190, 135,220
        ]

        let dayLabels = [
            "S","M","T","W","T","F","S",
            "M","T","W","T","F","S","M",
            "T","W","T","F","S","M","T",
            "W","T","F","S","M","T","W"
        ]

        let barColor = UIColor(red: 0xAD/255, green: 0xF8/255, blue: 0x45/255, alpha: 1)

        // MARK: — AUTO RESIZE BASED ON MAX VALUE
        let maxValue = barValues.max() ?? 200
        let maxDisplayHeight: CGFloat = 200  // max bar height on-screen

        // MARK: — HORIZONTAL GRID LINES
        let numberOfLines = 5
        for i in 0...numberOfLines {
            let line = UIView()
            line.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            line.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(line)

            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
                line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
                line.heightAnchor.constraint(equalToConstant: 1),
                line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                             constant: -50 - (CGFloat(i) / CGFloat(numberOfLines)) * maxDisplayHeight)
            ])
        }

        // MARK: — STACK VIEW FOR BARS
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .bottom
        stack.spacing = 24
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
        ])

        let stackWidth = CGFloat(barValues.count) * 30 + CGFloat(barValues.count - 1) * 24
        stack.widthAnchor.constraint(equalToConstant: stackWidth).isActive = true

        // MARK: — Y-AXIS LABELS
        let intervals = 5
        for i in 0...intervals {
            let label = UILabel()
            label.textColor = .white.withAlphaComponent(0.5)
            label.font = UIFont.systemFont(ofSize: 12)

            let value = Int((CGFloat(intervals - i) / CGFloat(intervals)) * maxValue)
            label.text = "\(value)"

            label.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(label)

            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor,
                                               constant: CGFloat(i * 40) - 100)
            ])
        }

        // MARK: — BARS
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

        scrollView.contentSize.width = stackWidth + 40
        contentView.frame.size.width = scrollView.contentSize.width
    }
    
    override func viewDidLayoutSubviews() {
        scrollViewMain.contentSize.height = collectionViewPace.frame.height + collectionViewPace.frame.origin.y + 100
    }
    
}

// MARK: — UICollectionView
extension AveragePaceViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return averagePaceTrends.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! TrendsCollectionViewCell
        let item = averagePaceTrends[indexPath.row]
        cell.configureCell(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 90)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: — UIScrollViewDelegate for updating week label
extension AveragePaceViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
        
        let barWidth: CGFloat = 30
        let barSpacing: CGFloat = 24
        let weekWidth = (barWidth + barSpacing) * CGFloat(daysPerWeek)
        
        // ADDITION: Use the center of the visible area to determine the active week
        // This ensures the label changes when you are halfway through the transition
        let midPointX = scrollView.contentOffset.x + (scrollView.frame.width / 2)
        let weekIndex = Int(midPointX / weekWidth)
        
        let totalBars = setupBarValues().count
        let totalWeeks = Int(ceil(Double(totalBars) / Double(daysPerWeek)))
        
        // Clamp the index between 0 and the last week index
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
    
    private func setupBarValues() -> [CGFloat] {
        return [
            50, 120, 75, 90, 160, 130, 200,
            40, 180, 110, 70, 150, 90, 210,
            60, 140, 195, 80, 170, 125,230,
            450, 250, 165, 280, 190, 135,220
        ]
    }
}

