import UIKit
import MapKit

class CreateRunEventViewController: UIViewController {

    public var club: Club?
    
    public var clubDetails: Club? {
        get { club }
        set { club = newValue }
    }

    // IBOutlets kept for compatibility but not required for layout
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var eventDescTextView: UITextView!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var startTimeField: UITextField!
    @IBOutlet weak var endTimeField: UITextField!
    @IBOutlet weak var startLocField: UITextField!
    @IBOutlet weak var endLocField: UITextField!
    @IBOutlet weak var sameStartSwitch: UISwitch!
    
    @IBOutlet weak var pollQuestionField: UITextField!
    @IBOutlet weak var pollOption1Field: UITextField!
    @IBOutlet weak var pollOption2Field: UITextField!

    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!

    // Header bar
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)

    // MARK: - Programmatic UI
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    // Cards
    private let detailsCard = UIView()
    private let scheduleCard = UIView()
    private let locationCard = UIView()
    private let pollCard = UIView()

    // Inputs (programmatic)
    private let nameField = UITextField()
    private let descTextView = UITextView()

    private let datePicker = UIDatePicker()
    private let startTimePicker = UIDatePicker()
    private let endTimePicker = UIDatePicker()

    private let startLocationField = UITextField()
    private let endLocationField = UITextField()
    private let sameAsStartSwitch = UISwitch()

    private let pollQuestion = UITextField()
    private let pollOption1 = UITextField()
    private let pollOption2 = UITextField()

    private let postButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    // MapKit properties
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    private var activeTextField: UITextField?

    // Suggestions UI
    private let suggestionsTableView = UITableView()
    private var suggestionsHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Run Event"
        view.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.08, alpha: 1.0)
        view.overrideUserInterfaceStyle = .dark
        
        buildHeaderBar()

        view.isOpaque = true
        view.backgroundColor = UIColor.black
        scrollView.backgroundColor = UIColor.black
        scrollView.isOpaque = true
        contentStack.isOpaque = false

        setupScrollAndStack()
        buildDetailsSection()
        buildScheduleSection()
        buildLocationSection()
        buildPollSection()
        buildFooterButtons()

        // Bridge programmatic controls to IBOutlets if XIB connections exist
        eventNameField = eventNameField ?? nameField
        eventDescTextView = eventDescTextView ?? descTextView
        dateField = dateField ?? makeTextFieldForPicker(datePicker)
        startTimeField = startTimeField ?? makeTextFieldForPicker(startTimePicker)
        endTimeField = endTimeField ?? makeTextFieldForPicker(endTimePicker)
        startLocField = startLocField ?? startLocationField
        endLocField = endLocField ?? endLocationField
        sameStartSwitch = sameStartSwitch ?? sameAsStartSwitch
        pollQuestionField = pollQuestionField ?? pollQuestion
        pollOption1Field = pollOption1Field ?? pollOption1
        pollOption2Field = pollOption2Field ?? pollOption2
        buttonSave = buttonSave ?? postButton
        buttonCancel = buttonCancel ?? cancelButton

        sameAsStartSwitch.addTarget(self, action: #selector(sameStartToggled(_:)), for: .valueChanged)
        
        setupSuggestionsTableView()
        setupSearchCompleter()
        setupTextFieldDelegates()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func buildHeaderBar() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = UIColor.black
        headerView.isOpaque = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "New Run Event"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        closeButton.layer.cornerRadius = 18
        closeButton.clipsToBounds = true
        closeButton.addTarget(self, action: #selector(cancelTapped(_:)), for: .touchUpInside)

        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(closeButton)

        let topAnchorRef = view.safeAreaLayoutGuide.topAnchor

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchorRef),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56),

            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 4),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            closeButton.heightAnchor.constraint(equalToConstant: 36),

            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 4)
        ])
    }

    private func setupSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }

    private func setupTextFieldDelegates() {
        startLocationField.delegate = self
        endLocationField.delegate = self
        
        // Add targets for text changes
        startLocationField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        endLocationField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    private func setupSuggestionsTableView() {
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        suggestionsTableView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        suggestionsTableView.separatorColor = UIColor(white: 0.3, alpha: 1.0)
        suggestionsTableView.layer.cornerRadius = 12
        suggestionsTableView.clipsToBounds = true
        suggestionsTableView.isHidden = true
        suggestionsTableView.translatesAutoresizingMaskIntoConstraints = false
        suggestionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
        
        view.addSubview(suggestionsTableView)
        
        // We will update the top anchor dynamically based on which text field is active
        suggestionsHeightConstraint = suggestionsTableView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            suggestionsTableView.leadingAnchor.constraint(equalTo: locationCard.leadingAnchor, constant: 14),
            suggestionsTableView.trailingAnchor.constraint(equalTo: locationCard.trailingAnchor, constant: -14),
            suggestionsHeightConstraint!
        ])
    }

    // MARK: - Section Builders
    private func setupScrollAndStack() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 16

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
    }

    private func buildDetailsSection() {
        let header = sectionHeader(title: "Event Details")
        styleCard(detailsCard)

        styleTextField(nameField, placeholder: "Event Name")

        descTextView.text = "Add details about the run..."
        descTextView.textColor = .secondaryLabel
        descTextView.font = .systemFont(ofSize: 15)
        descTextView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        descTextView.layer.cornerRadius = 12
        descTextView.isOpaque = true
        descTextView.isScrollEnabled = false
        descTextView.textContainerInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        descTextView.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [nameField, descTextView])
        stack.axis = .vertical
        stack.spacing = 10

        detailsCard.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: detailsCard.topAnchor, constant: 14),
            stack.leadingAnchor.constraint(equalTo: detailsCard.leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: detailsCard.trailingAnchor, constant: -14),
            stack.bottomAnchor.constraint(equalTo: detailsCard.bottomAnchor, constant: -14),
            descTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 90)
        ])

        contentStack.addArrangedSubview(header)
        contentStack.setCustomSpacing(6, after: header)
        contentStack.addArrangedSubview(detailsCard)
    }

    private func buildScheduleSection() {
        let header = sectionHeader(title: "Schedule")
        styleCard(scheduleCard)

        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        startTimePicker.preferredDatePickerStyle = .compact
        startTimePicker.datePickerMode = .time
        endTimePicker.preferredDatePickerStyle = .compact
        endTimePicker.datePickerMode = .time

        let dateRow = row(title: "Date", trailing: datePicker)
        let startRow = row(title: "Start Time", trailing: startTimePicker)
        let endRow = row(title: "End Time", trailing: endTimePicker)

        let v = UIStackView(arrangedSubviews: [dateRow, divider(), startRow, divider(), endRow])
        v.axis = .vertical
        v.spacing = 0

        scheduleCard.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: scheduleCard.topAnchor),
            v.leadingAnchor.constraint(equalTo: scheduleCard.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: scheduleCard.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: scheduleCard.bottomAnchor)
        ])

        scheduleCard.isOpaque = true

        contentStack.addArrangedSubview(header)
        contentStack.setCustomSpacing(6, after: header)
        contentStack.addArrangedSubview(scheduleCard)
    }

    private func buildLocationSection() {
        let header = sectionHeader(title: "Location")
        styleCard(locationCard)

        styleTextField(startLocationField, placeholder: "Starting point")
        styleTextField(endLocationField, placeholder: "Ending point")
        endLocationField.keyboardType = .default
        endLocationField.isUserInteractionEnabled = true
        endLocationField.isEnabled = true
        endLocationField.addTarget(self, action: #selector(beginEditing(_:)), for: .editingDidBegin)

        let sameRow = UIStackView()
        sameRow.axis = .horizontal
        sameRow.alignment = .center
        sameRow.spacing = 10

        let sameLabel = UILabel()
        sameLabel.text = "Same as Start"
        sameLabel.textColor = .secondaryLabel
        sameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        sameRow.addArrangedSubview(sameLabel)
        sameRow.addArrangedSubview(sameAsStartSwitch)

        locationCard.addSubview(startLocationField)
        locationCard.addSubview(endLocationField)
        locationCard.addSubview(sameRow)

        let v = UIStackView(arrangedSubviews: [startLocationField, endLocationField, sameRow])
        v.axis = .vertical
        v.spacing = 10

        locationCard.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: locationCard.topAnchor, constant: 14),
            v.leadingAnchor.constraint(equalTo: locationCard.leadingAnchor, constant: 14),
            v.trailingAnchor.constraint(equalTo: locationCard.trailingAnchor, constant: -14),
            v.bottomAnchor.constraint(equalTo: locationCard.bottomAnchor, constant: -14)
        ])

        contentStack.addArrangedSubview(header)
        contentStack.setCustomSpacing(6, after: header)
        contentStack.addArrangedSubview(locationCard)

        sameAsStartSwitch.addTarget(self, action: #selector(handleSameAsStartChanged), for: .valueChanged)

        locationCard.isOpaque = true
    }

    private func buildPollSection() {
        let header = sectionHeader(title: "Poll")
        styleCard(pollCard)

        styleTextField(pollQuestion, placeholder: "Are you coming?")
        styleTextField(pollOption1, placeholder: "Yes")
        styleTextField(pollOption2, placeholder: "No")

        let v = UIStackView(arrangedSubviews: [pollQuestion, pollOption1, pollOption2])
        v.axis = .vertical
        v.spacing = 10

        pollCard.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: pollCard.topAnchor, constant: 14),
            v.leadingAnchor.constraint(equalTo: pollCard.leadingAnchor, constant: 14),
            v.trailingAnchor.constraint(equalTo: pollCard.trailingAnchor, constant: -14),
            v.bottomAnchor.constraint(equalTo: pollCard.bottomAnchor, constant: -14)
        ])

        // Add pencil icon on right side of poll header
        let pollHeaderRow = UIStackView()
        pollHeaderRow.axis = .horizontal
        pollHeaderRow.alignment = .center
        pollHeaderRow.distribution = .fill
        pollHeaderRow.spacing = 8

        let editIcon = UIImageView(image: UIImage(systemName: "pencil"))
        editIcon.tintColor = .white
        editIcon.setContentHuggingPriority(.required, for: .horizontal)

        pollHeaderRow.addArrangedSubview(header)
        pollHeaderRow.addArrangedSubview(editIcon)

        contentStack.addArrangedSubview(pollHeaderRow)
        contentStack.setCustomSpacing(6, after: pollHeaderRow)
        contentStack.addArrangedSubview(pollCard)

        pollCard.isOpaque = true
    }

    private func buildFooterButtons() {
        let h = UIStackView()
        h.axis = .horizontal
        h.spacing = 12
        h.distribution = .fillEqually

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor(white: 0.15, alpha: 1)
        cancelButton.layer.cornerRadius = 22
        cancelButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        cancelButton.addTarget(self, action: #selector(cancelTapped(_:)), for: .touchUpInside)

        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(.black, for: .normal)
        postButton.backgroundColor = .accent
        postButton.layer.cornerRadius = 22
        postButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        postButton.addTarget(self, action: #selector(postTapped(_:)), for: .touchUpInside)

        h.addArrangedSubview(cancelButton)
        h.addArrangedSubview(postButton)

        postButton.addTarget(self, action: #selector(createNewEvent), for: .touchUpInside)
        
        contentStack.addArrangedSubview(h)
    }
    
    private func formatTime12Hour(_ date: Date) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone.current
        df.dateFormat = "h:mm a"
        return df.string(from: date)
    }

    @objc func createNewEvent() {
        let startTimeString = formatTime12Hour(startTimePicker.date)
        let endTimeString = formatTime12Hour(endTimePicker.date)
        
        let newEvent = ClubEvents(clubID: self.club?.clubID,
                                  eventName: self.nameField.text,
                                  eventDescription: self.descTextView.text,
                                  eventDate: self.datePicker.date,
                                  startTime: startTimeString,
                                  endTime: endTimeString,
                                  startLocation: self.startLocationField.text,
                                  endLocation: self.endLocationField.text,
                                  isCompleted: false)
        
        Task {
            await insertNewClubEvent(event: newEvent)
        }
    }

    // MARK: - Helpers
    private func sectionHeader(title: String) -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.alignment = .center
        container.spacing = 10

        let label = UILabel()
        label.text = title.uppercased()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .semibold)

        container.addArrangedSubview(label)
        return container
    }

    private func row(title: String, trailing: UIView) -> UIView {
        let row = UIView()

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        trailing.translatesAutoresizingMaskIntoConstraints = false

        row.addSubview(titleLabel)
        row.addSubview(trailing)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 14),
            titleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),

            trailing.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -14),
            trailing.centerYAnchor.constraint(equalTo: row.centerYAnchor),

            row.heightAnchor.constraint(equalToConstant: 56)
        ])

        return row
    }

    private func divider() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.2, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.heightAnchor.constraint(equalToConstant: 1)
        ])
        return v
    }

    private func styleCard(_ v: UIView) {
        v.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0)
        v.layer.cornerRadius = 16
        v.layer.masksToBounds = true
        v.isOpaque = true
    }

    private func styleTextField(_ tf: UITextField, placeholder: String? = nil) {
        tf.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        tf.textColor = .white
        tf.tintColor = .accent
        tf.layer.cornerRadius = 12
        tf.borderStyle = .none
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        tf.leftViewMode = .always
        tf.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor: UIColor.secondaryLabel])
        tf.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    private func makeTextFieldForPicker(_ picker: UIDatePicker) -> UITextField {
        let tf = UITextField()
        styleTextField(tf)
        tf.inputView = picker
        return tf
    }

    // MARK: - Actions
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func postTapped(_ sender: UIButton) { }

    @IBAction func sameStartToggled(_ sender: UISwitch) {
        if sender.isOn {
            endLocationField.text = startLocationField.text
        }
        endLocationField.isEnabled = !sender.isOn
        if !sender.isOn {
            endLocationField.becomeFirstResponder()
        }
    }

    @objc private func handleSameAsStartChanged() {
        endLocationField.isEnabled = !sameAsStartSwitch.isOn
        if sameAsStartSwitch.isOn { endLocationField.text = startLocationField.text }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func beginEditing(_ sender: UITextField) {
        // no-op, ensures control events are wired and field becomes first responder
    }
}

// MARK: - MapKit & TableView Delegates
extension CreateRunEventViewController: MKLocalSearchCompleterDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        activeTextField = textField
        if let text = textField.text, !text.isEmpty {
            searchCompleter.queryFragment = text
            updateSuggestionsPosition(below: textField)
        } else {
            searchResults = []
            suggestionsTableView.reloadData()
            hideSuggestions()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == startLocationField || textField == endLocationField {
            activeTextField = textField
            if let text = textField.text, !text.isEmpty {
                searchCompleter.queryFragment = text
                updateSuggestionsPosition(below: textField)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Delay hiding to allow table view selection to register
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.hideSuggestions()
        }
    }

    private func updateSuggestionsPosition(below textField: UITextField) {
        // Remove existing top anchor
        suggestionsTableView.constraints.forEach { constraint in
            if constraint.firstAttribute == .top {
                suggestionsTableView.removeConstraint(constraint)
            }
        }
        
        // Find the constraint in the view as well
        view.constraints.forEach { constraint in
            if (constraint.firstItem as? UIView) == suggestionsTableView && constraint.firstAttribute == .top {
                view.removeConstraint(constraint)
            }
        }

        let topAnchor = suggestionsTableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4)
        topAnchor.isActive = true
        view.layoutIfNeeded()
    }

    private func hideSuggestions() {
        suggestionsTableView.isHidden = true
        suggestionsHeightConstraint?.constant = 0
        view.layoutIfNeeded()
    }

    // MKLocalSearchCompleterDelegate
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        suggestionsTableView.reloadData()
        
        if !searchResults.isEmpty {
            suggestionsTableView.isHidden = false
            let height = min(CGFloat(searchResults.count * 44), 200.0)
            suggestionsHeightConstraint?.constant = height
            view.layoutIfNeeded()
        } else {
            hideSuggestions()
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer failed: \(error.localizedDescription)")
    }

    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
        let suggestion = searchResults[indexPath.row]
        
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .systemFont(ofSize: 14)
        cell.textLabel?.text = suggestion.title + " " + suggestion.subtitle
        
        let selectionView = UIView()
        selectionView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        cell.selectedBackgroundView = selectionView
        
        return cell
    }

    // UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let suggestion = searchResults[indexPath.row]
        let fullAddress = suggestion.title + (suggestion.subtitle.isEmpty ? "" : ", " + suggestion.subtitle)
        
        activeTextField?.text = fullAddress
        hideSuggestions()
        view.endEditing(true)
        
        if activeTextField == startLocationField && sameAsStartSwitch.isOn {
            endLocationField.text = fullAddress
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

