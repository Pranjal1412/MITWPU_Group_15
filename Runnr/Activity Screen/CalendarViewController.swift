import UIKit
import FSCalendar

protocol CalendarViewControllerDelegate: AnyObject {
    func didSelectDate(_ date: Date)
    func didClearFilter()
}

class CalendarViewController: UIViewController {
    
    weak var delegate: CalendarViewControllerDelegate?
    var activityDates: [Date] = []
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let dragHandle = UIView()
    private let clearButton = UIButton(type: .system)
    private let calendar = FSCalendar()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupContainer()
        setupDragHandle()
        setupTitleLabel()
        setupCalendar()
        setupClearButton()
        setupDismissTap()
    }
    
    private func setupDismissTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    private func setupContainer() {
        containerView.backgroundColor = UIColor(named: "BackgroundColor") ?? UIColor.systemBackground
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.isUserInteractionEnabled = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55)
        ])
    }
    
    private func setupDragHandle() {
        dragHandle.backgroundColor = UIColor.systemGray4
        dragHandle.layer.cornerRadius = 2.5
        dragHandle.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dragHandle)
        
        NSLayoutConstraint.activate([
            dragHandle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            dragHandle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dragHandle.widthAnchor.constraint(equalToConstant: 36),
            dragHandle.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
    
    private func setupTitleLabel() {
        let thinFont = UIFont(name: "SFProText-Thin", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .thin)
        let boldFont = UIFont(name: "SFProText-Bold", size: 22) ?? UIFont.boldSystemFont(ofSize: 22)
        
        let thinText = NSAttributedString(string: "Filter by ", attributes: [.font: thinFont])
        let boldText = NSAttributedString(string: "Date", attributes: [.font: boldFont])
        let full = NSMutableAttributedString()
        full.append(thinText)
        full.append(boldText)
        titleLabel.attributedText = full
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dragHandle.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20)
        ])
    }
    
    private func setupCalendar() {
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = false
        calendar.scrollDirection = .horizontal
        calendar.pagingEnabled = true
        calendar.today = Date()
        calendar.placeholderType = .none
        
        // MARK: Appearance
        let appearance = calendar.appearance
        
        // Header (Month + Year)
        appearance.headerTitleColor = .white
        appearance.headerTitleFont = UIFont(name: "SFProText-Bold", size: 17) ?? UIFont.boldSystemFont(ofSize: 17)
        appearance.headerMinimumDissolvedAlpha = 0.0
        
        // Weekday labels
        appearance.weekdayTextColor = .systemGray
        appearance.weekdayFont = UIFont(name: "SFProText-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .medium)
        
        // Default date number color
        appearance.titleDefaultColor = .white
        appearance.titleFont = UIFont(name: "SFProText-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        
        // Today's date highlight
        appearance.todayColor = UIColor(hex: "adf845").withAlphaComponent(0.3)
        appearance.titleTodayColor = UIColor(hex: "adf845")
        
        // Selected date
        appearance.selectionColor = UIColor(hex: "adf845").withAlphaComponent(0.4)
        appearance.titleSelectionColor = UIColor(hex: "adf845")
        
        // No dots
        appearance.eventDefaultColor = .clear
        appearance.eventSelectionColor = .clear
        
        // Background
        calendar.backgroundColor = .clear
        calendar.calendarHeaderView.backgroundColor = .clear
        calendar.calendarWeekdayView.backgroundColor = .clear
        
        containerView.addSubview(calendar)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            calendar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            calendar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            calendar.heightAnchor.constraint(equalToConstant: 320)
        ])
    }
    
    private func setupClearButton() {
        clearButton.setTitle("Clear Filter", for: .normal)
        clearButton.titleLabel?.font = UIFont(name: "SFProText-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        clearButton.setTitleColor(.systemRed, for: .normal)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.addTarget(self, action: #selector(clearFilter), for: .touchUpInside)
        containerView.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            clearButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 8),
            clearButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            clearButton.bottomAnchor.constraint(lessThanOrEqualTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Animations
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        view.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5) {
            self.containerView.transform = .identity
            self.view.alpha = 1
        }
    }
    
    func animateDismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            self.view.alpha = 0
        }) { _ in
            self.dismiss(animated: false)
        }
    }
    
    @objc private func dismissSelf() {
        animateDismiss()
    }
    
    @objc private func clearFilter() {
        delegate?.didClearFilter()
        animateDismiss()
    }
}

// MARK: - FSCalendarDelegate

extension CalendarViewController: FSCalendarDelegate {
    
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        delegate?.didSelectDate(date)
        animateDismiss()
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date.distantPast
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}

// MARK: - FSCalendarDataSource

extension CalendarViewController: FSCalendarDataSource {
    
    func calendar(
        _ calendar: FSCalendar,
        numberOfEventsFor date: Date
    ) -> Int {
        return 0
    }
}

// MARK: - FSCalendarDelegateAppearance

extension CalendarViewController: FSCalendarDelegateAppearance {
    
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleDefaultColorFor date: Date
    ) -> UIColor? {
        
        let hasActivity = activityDates.contains {
            Calendar.current.isDate($0, inSameDayAs: date)
        }
        
        return hasActivity ? UIColor(hex: "adf845") : nil
    }
    
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleSelectionColorFor date: Date
    ) -> UIColor? {
        
        let hasActivity = activityDates.contains {
            Calendar.current.isDate($0, inSameDayAs: date)
        }
        
        return hasActivity ? UIColor(hex: "adf845") : nil
    }
}

// MARK: - UIGestureRecognizerDelegate

extension CalendarViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        return !containerView.frame.contains(touch.location(in: view))
    }
}
