//
//  CreateRunEventViewController.swift
//  Runnr
//
//  Created for Club Screen — replaces CreatePostViewController
//

import UIKit

// MARK: - Model

struct RunEvent {
    var name: String = ""
    var description: String = ""
    var date: Date = Date()
    var startTime: Date = Date()
    var endTime: Date = Date().addingTimeInterval(3600)
    var startLocation: String = ""
    var endLocation: String = ""
    var sameAsStart: Bool = false
    var pollQuestion: String = "Are you coming?"
    var pollOptions: [String] = ["Yes", "Maybe", "No"]
}

// MARK: - ViewController

class CreateRunEventViewController: UIViewController {

    // MARK: - State
    var clubDetails: Club?
    private var event = RunEvent()

    // MARK: - Palette (matches app dark theme)
    private enum Palette {
        static let bg          = UIColor(white: 0.06, alpha: 1)
        static let card        = UIColor(white: 0.12, alpha: 1)
        static let separator   = UIColor(white: 0.2, alpha: 1)
        static let accent      = UIColor.accent
        static let accentDim   = UIColor.accent.withAlphaComponent(0.15)
        static let textPrimary = UIColor.white
        static let textSecond  = UIColor(white: 0.55, alpha: 1)
        static let fieldBg     = UIColor(white: 0.09, alpha: 1)
        static let rowHeight: CGFloat = 52
    }

    // MARK: - UI Roots
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.keyboardDismissMode = .interactive
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private lazy var contentStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private lazy var stickyBar: UIView = {
        let v = UIView()
        v.backgroundColor = Palette.bg
        v.translatesAutoresizingMaskIntoConstraints = false
        let top = UIView()
        top.backgroundColor = Palette.separator
        top.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(top)
        NSLayoutConstraint.activate([
            top.topAnchor.constraint(equalTo: v.topAnchor),
            top.leadingAnchor.constraint(equalTo: v.leadingAnchor),
            top.trailingAnchor.constraint(equalTo: v.trailingAnchor),
            top.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        return v
    }()

    // MARK: - Header (cover photo removed)

    // MARK: - Section 1: Event Details
    private lazy var eventNameField: UITextField = makeTextField(placeholder: " Morning Run Club", icon: "pencil")
    private lazy var eventDescTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 15)
        tv.textColor = Palette.textSecond
        tv.text = "Add details about the run…"
        tv.isScrollEnabled = false
        tv.delegate = self
        tv.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // MARK: - Section 2: Schedule
    private lazy var dateRow     = makeScheduleRow(icon: "calendar",       label: "Date",       value: formattedDate(event.date))
    private lazy var startRow    = makeScheduleRow(icon: "clock",          label: "Start Time", value: formattedTime(event.startTime))
    private lazy var endRow      = makeScheduleRow(icon: "clock.fill",     label: "End Time",   value: formattedTime(event.endTime))

    // MARK: - Section 3: Location
    private lazy var startLocField = makeTextField(placeholder: "Starting point", icon: "location.fill")
    private lazy var endLocField   = makeTextField(placeholder: "Ending point",   icon: "flag.fill")
    private lazy var sameStartSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = Palette.accent
        sw.addTarget(self, action: #selector(sameAsStartToggled(_:)), for: .valueChanged)
        return sw
    }()

    // MARK: - Section 4: Poll
    private lazy var pollQuestionField = makeTextField(placeholder: "Are you coming?", icon: "questionmark.circle")
    private lazy var pollOptionsStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.bg
        setupNavBar()
        setupScrollView()
        buildUI()
        setupKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Nav Bar
    private func setupNavBar() {
        let cancelBtn = UIButton(type: .system)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        cancelBtn.layer.cornerRadius = 22.5
        cancelBtn.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        setGlassEffect(for: cancelBtn, withImage: "xmark")

        let titleLabel = UILabel()
        titleLabel.text = "New Run Event"
        titleLabel.font = UIFont(name: "SFProText-Semibold", size: 25)
            ?? .systemFont(ofSize: 25, weight: .semibold)
        titleLabel.textColor = Palette.textPrimary

        let headerBar = UIView()
        headerBar.backgroundColor = Palette.bg
        headerBar.translatesAutoresizingMaskIntoConstraints = false
        [cancelBtn, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            headerBar.addSubview($0)
        }
        NSLayoutConstraint.activate([
            cancelBtn.leadingAnchor.constraint(equalTo: headerBar.leadingAnchor, constant: 16),
            cancelBtn.centerYAnchor.constraint(equalTo: headerBar.centerYAnchor, constant: 10),
            cancelBtn.widthAnchor.constraint(equalToConstant: 45),
            cancelBtn.heightAnchor.constraint(equalToConstant: 45),
            titleLabel.centerXAnchor.constraint(equalTo: headerBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerBar.centerYAnchor, constant: 10),
            headerBar.heightAnchor.constraint(equalToConstant: 64)
        ])
        view.addSubview(headerBar)
        NSLayoutConstraint.activate([
            headerBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Separator line
        let line = UIView()
        line.backgroundColor = Palette.separator
        line.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(line)
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 10),
            line.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 0.5)
        ])

        self.headerBarBottomY = headerBar
    }

    private var headerBarBottomY: UIView?

    // MARK: - ScrollView Setup
    private var stickyBarBottomConstraint: NSLayoutConstraint!

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        // Sticky bottom bar
        view.addSubview(stickyBar)
        stickyBarBottomConstraint = stickyBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        guard let headerBar = headerBarBottomY else { return }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 1),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: stickyBar.topAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -36),

            stickyBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickyBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stickyBarBottomConstraint,
            stickyBar.heightAnchor.constraint(equalToConstant: 96)
        ])
    }

    // MARK: - Build Full UI
    private func buildUI() {
        // Section 1 — Event Details
        let h1 = makeSectionHeader("EVENT DETAILS", icon: "doc.text")
        contentStack.addArrangedSubview(h1)
        contentStack.setCustomSpacing(6, after: h1)
        let detailsCard = makeCard()
        let descContainer = UIView()
        descContainer.translatesAutoresizingMaskIntoConstraints = false
        let descLine = UIView()
        descLine.backgroundColor = Palette.separator
        descLine.translatesAutoresizingMaskIntoConstraints = false
        descContainer.addSubview(descLine)
        descContainer.addSubview(eventDescTextView)
        NSLayoutConstraint.activate([
            descLine.topAnchor.constraint(equalTo: descContainer.topAnchor),
            descLine.leadingAnchor.constraint(equalTo: descContainer.leadingAnchor, constant: 16),
            descLine.trailingAnchor.constraint(equalTo: descContainer.trailingAnchor),
            descLine.heightAnchor.constraint(equalToConstant: 0.5),
            eventDescTextView.topAnchor.constraint(equalTo: descLine.bottomAnchor),
            eventDescTextView.leadingAnchor.constraint(equalTo: descContainer.leadingAnchor),
            eventDescTextView.trailingAnchor.constraint(equalTo: descContainer.trailingAnchor),
            eventDescTextView.bottomAnchor.constraint(equalTo: descContainer.bottomAnchor),
            eventDescTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 90)
        ])
        addToCard(detailsCard, views: [
            wrapField(eventNameField),
            descContainer
        ])
        contentStack.addArrangedSubview(detailsCard)

        // Section 2 — Schedule
        let h2 = makeSectionHeader("SCHEDULE", icon: "calendar.badge.clock")
        contentStack.addArrangedSubview(h2)
        contentStack.setCustomSpacing(6, after: h2)
        let schedCard = makeCard()
        addToCard(schedCard, views: [
            makeRowWithSeparator(dateRow, addSep: true),
            makeRowWithSeparator(startRow, addSep: true),
            makeRowWithSeparator(endRow, addSep: false)
        ])
        contentStack.addArrangedSubview(schedCard)

        // Tap handlers for schedule rows
        dateRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDatePicker)))
        startRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showStartTimePicker)))
        endRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showEndTimePicker)))

        // Section 3 — Location
        let h3 = makeSectionHeader("LOCATION", icon: "mappin.and.ellipse")
        contentStack.addArrangedSubview(h3)
        contentStack.setCustomSpacing(6, after: h3)
        let locCard = makeCard()
        let sameRow = makeSwitchRow(label: "Same as Start", sw: sameStartSwitch)
        addToCard(locCard, views: [
            wrapField(startLocField),
            makeSeparatorView(),
            wrapField(endLocField),
            makeSeparatorView(),
            sameRow
        ])
        contentStack.addArrangedSubview(locCard)

        // Section 4 — Poll
        let h4 = makeSectionHeader("POLL", icon: "chart.bar.xaxis")
        contentStack.addArrangedSubview(h4)
        contentStack.setCustomSpacing(6, after: h4)
        let pollCard = makeCard()
        rebuildPollOptions()
        var addCfg = UIButton.Configuration.plain()
        addCfg.title = "+ Add Option"
        addCfg.image = UIImage(systemName: "plus.circle")
        addCfg.imagePadding = 6
        addCfg.baseForegroundColor = Palette.accent
        addCfg.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        let addOptionBtn = UIButton(configuration: addCfg)
        addOptionBtn.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        addOptionBtn.contentHorizontalAlignment = .left
        addOptionBtn.translatesAutoresizingMaskIntoConstraints = false
        addOptionBtn.heightAnchor.constraint(equalToConstant: 48).isActive = true
        addOptionBtn.addTarget(self, action: #selector(addPollOption), for: .touchUpInside)
        addToCard(pollCard, views: [
            wrapField(pollQuestionField),
            makeSeparatorView(),
            pollOptionsStack,
            makeSeparatorView(),
            addOptionBtn
        ])
        contentStack.addArrangedSubview(pollCard)

        // Bottom padding
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        contentStack.addArrangedSubview(spacer)

        // Build sticky bar
        buildStickyBar()
    }

    // MARK: - Sticky Bar
    private func buildStickyBar() {
        let createBtn = UIButton(type: .system)
        createBtn.setTitle("Create Event", for: .normal)
        createBtn.setTitleColor(.black, for: .normal)
        createBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        createBtn.backgroundColor = Palette.accent
        createBtn.layer.cornerRadius = 14
        createBtn.translatesAutoresizingMaskIntoConstraints = false
        createBtn.addTarget(self, action: #selector(createEventTapped), for: .touchUpInside)

        let draftBtn = UIButton(type: .system)
        draftBtn.setTitle("Save as Draft", for: .normal)
        draftBtn.setTitleColor(Palette.textSecond, for: .normal)
        draftBtn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        draftBtn.translatesAutoresizingMaskIntoConstraints = false
        draftBtn.addTarget(self, action: #selector(saveDraftTapped), for: .touchUpInside)

        stickyBar.addSubview(createBtn)
        stickyBar.addSubview(draftBtn)
        NSLayoutConstraint.activate([
            createBtn.topAnchor.constraint(equalTo: stickyBar.topAnchor, constant: 12),
            createBtn.leadingAnchor.constraint(equalTo: stickyBar.leadingAnchor, constant: 16),
            createBtn.trailingAnchor.constraint(equalTo: stickyBar.trailingAnchor, constant: -16),
            createBtn.heightAnchor.constraint(equalToConstant: 50),
            draftBtn.topAnchor.constraint(equalTo: createBtn.bottomAnchor, constant: 4),
            draftBtn.centerXAnchor.constraint(equalTo: stickyBar.centerXAnchor)
        ])
    }

    // MARK: - Poll helpers
    private func rebuildPollOptions() {
        pollOptionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (i, opt) in event.pollOptions.enumerated() {
            let row = makePollOptionRow(text: opt, index: i)
            pollOptionsStack.addArrangedSubview(row)
            if i < event.pollOptions.count - 1 {
                pollOptionsStack.addArrangedSubview(makeSeparatorView())
            }
        }
    }

    private func makePollOptionRow(text: String, index: Int) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.heightAnchor.constraint(equalToConstant: 48).isActive = true

        let bullet = UIImageView(image: UIImage(systemName: circleIcon(for: index)))
        bullet.tintColor = Palette.accent
        bullet.contentMode = .scaleAspectFit
        bullet.translatesAutoresizingMaskIntoConstraints = false

        let field = UITextField()
        field.text = text
        field.font = .systemFont(ofSize: 15)
        field.textColor = Palette.textPrimary
        field.tag = 1000 + index
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false

        let deleteBtn = UIButton(type: .system)
        deleteBtn.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        deleteBtn.tintColor = UIColor.systemRed.withAlphaComponent(0.8)
        deleteBtn.tag = index
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        deleteBtn.addTarget(self, action: #selector(deletePollOption(_:)), for: .touchUpInside)
        deleteBtn.isHidden = event.pollOptions.count <= 2  // keep min 2

        row.addSubview(bullet)
        row.addSubview(field)
        row.addSubview(deleteBtn)

        NSLayoutConstraint.activate([
            bullet.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            bullet.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            bullet.widthAnchor.constraint(equalToConstant: 20),
            bullet.heightAnchor.constraint(equalToConstant: 20),
            field.leadingAnchor.constraint(equalTo: bullet.trailingAnchor, constant: 12),
            field.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            field.trailingAnchor.constraint(equalTo: deleteBtn.leadingAnchor, constant: -8),
            deleteBtn.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            deleteBtn.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            deleteBtn.widthAnchor.constraint(equalToConstant: 24),
            deleteBtn.heightAnchor.constraint(equalToConstant: 24)
        ])
        return row
    }

    private func circleIcon(for index: Int) -> String {
        let icons = ["checkmark.circle.fill", "questionmark.circle.fill", "xmark.circle.fill"]
        return index < icons.count ? icons[index] : "circle.fill"
    }

    // MARK: - Actions
    @objc private func cancelTapped() {
        let alert = UIAlertController(title: "Discard Event?",
                                      message: "All changes will be lost.",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.dismiss(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Keep Editing", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func createEventTapped() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        // TODO: persist event to backend
        dismiss(animated: true)
    }

    @objc private func saveDraftTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        dismiss(animated: true)
    }

    @objc private func addPollOption() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        event.pollOptions.append("Option \(event.pollOptions.count + 1)")
        rebuildPollOptions()
    }

    @objc private func deletePollOption(_ sender: UIButton) {
        let idx = sender.tag
        guard event.pollOptions.count > 2, idx < event.pollOptions.count else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        event.pollOptions.remove(at: idx)
        rebuildPollOptions()
    }

    @objc private func sameAsStartToggled(_ sw: UISwitch) {
        event.sameAsStart = sw.isOn
        endLocField.isEnabled = !sw.isOn
        endLocField.alpha = sw.isOn ? 0.4 : 1.0
        if sw.isOn { endLocField.text = startLocField.text }
    }

    // MARK: - Date/Time Pickers
    @objc private func showDatePicker() {
        presentPicker(mode: .date, initial: event.date) { [weak self] d in
            self?.event.date = d
            self?.updateRowValueLabel(in: self!.dateRow, text: self!.formattedDate(d))
        }
    }

    @objc private func showStartTimePicker() {
        presentPicker(mode: .time, initial: event.startTime) { [weak self] t in
            self?.event.startTime = t
            self?.updateRowValueLabel(in: self!.startRow, text: self!.formattedTime(t))
        }
    }

    @objc private func showEndTimePicker() {
        presentPicker(mode: .time, initial: event.endTime) { [weak self] t in
            self?.event.endTime = t
            self?.updateRowValueLabel(in: self!.endRow, text: self!.formattedTime(t))
        }
    }

    private var pickerCompletion: ((Date) -> Void)?

    private func presentPicker(mode: UIDatePicker.Mode, initial: Date, completion: @escaping (Date) -> Void) {
        self.pickerCompletion = completion

        let sheet = UIViewController()
        sheet.view.backgroundColor = Palette.card

        let picker = UIDatePicker()
        picker.datePickerMode = mode
        picker.preferredDatePickerStyle = .wheels
        picker.date = initial
        picker.overrideUserInterfaceStyle = .dark
        picker.translatesAutoresizingMaskIntoConstraints = false

        let doneBar = UIView()
        doneBar.translatesAutoresizingMaskIntoConstraints = false
        doneBar.backgroundColor = Palette.card

        let doneBtn = UIButton(type: .system)
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        doneBtn.tintColor = Palette.accent
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        doneBtn.addTarget(self, action: #selector(pickerDone), for: .touchUpInside)

        let cancelBtn = UIButton(type: .system)
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        cancelBtn.tintColor = Palette.textSecond
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.addTarget(self, action: #selector(pickerCancel), for: .touchUpInside)

        doneBar.addSubview(cancelBtn)
        doneBar.addSubview(doneBtn)
        sheet.view.addSubview(doneBar)
        sheet.view.addSubview(picker)

        NSLayoutConstraint.activate([
            doneBar.topAnchor.constraint(equalTo: sheet.view.topAnchor),
            doneBar.leadingAnchor.constraint(equalTo: sheet.view.leadingAnchor),
            doneBar.trailingAnchor.constraint(equalTo: sheet.view.trailingAnchor),
            doneBar.heightAnchor.constraint(equalToConstant: 50),
            cancelBtn.leadingAnchor.constraint(equalTo: doneBar.leadingAnchor, constant: 16),
            cancelBtn.centerYAnchor.constraint(equalTo: doneBar.centerYAnchor),
            doneBtn.trailingAnchor.constraint(equalTo: doneBar.trailingAnchor, constant: -16),
            doneBtn.centerYAnchor.constraint(equalTo: doneBar.centerYAnchor),
            picker.topAnchor.constraint(equalTo: doneBar.bottomAnchor),
            picker.leadingAnchor.constraint(equalTo: sheet.view.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: sheet.view.trailingAnchor),
            picker.bottomAnchor.constraint(equalTo: sheet.view.bottomAnchor)
        ])

        sheet.modalPresentationStyle = .pageSheet
        if let sheetPresentation = sheet.sheetPresentationController {
            sheetPresentation.detents = [.medium()]
            sheetPresentation.prefersGrabberVisible = true
        }

        // Keep ref for Done action
        objc_setAssociatedObject(sheet, &AssociatedKeys.picker, picker, .OBJC_ASSOCIATION_RETAIN)
        present(sheet, animated: true)
        self.activePickerSheet = sheet
    }

    private var activePickerSheet: UIViewController?

    @objc private func pickerDone() {
        guard let sheet = activePickerSheet,
              let picker = objc_getAssociatedObject(sheet, &AssociatedKeys.picker) as? UIDatePicker else {
            activePickerSheet?.dismiss(animated: true)
            return
        }
        pickerCompletion?(picker.date)
        sheet.dismiss(animated: true)
        activePickerSheet = nil
    }

    @objc private func pickerCancel() {
        activePickerSheet?.dismiss(animated: true)
        activePickerSheet = nil
    }

    // MARK: - Keyboard
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                                name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                                name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ n: Notification) {
        guard let info = n.userInfo,
              let kbFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let dur = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        let overlap = kbFrame.height - view.safeAreaInsets.bottom
        UIView.animate(withDuration: dur) {
            self.stickyBarBottomConstraint.constant = -overlap
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ n: Notification) {
        guard let info = n.userInfo,
              let dur = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        UIView.animate(withDuration: dur) {
            self.stickyBarBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Formatters
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter(); f.dateStyle = .medium; f.timeStyle = .none; return f
    }()
    private let timeFormatter: DateFormatter = {
        let f = DateFormatter(); f.dateStyle = .none; f.timeStyle = .short; return f
    }()
    private func formattedDate(_ d: Date) -> String { dateFormatter.string(from: d) }
    private func formattedTime(_ d: Date) -> String { timeFormatter.string(from: d) }

    private func updateRowValueLabel(in row: UIView, text: String) {
        if let lbl = row.viewWithTag(999) as? UILabel { lbl.text = text }
    }
}

// MARK: - Associated Keys
private enum AssociatedKeys {
    static var picker = "picker"
}

// MARK: - Factory Helpers

private extension CreateRunEventViewController {

    func makeSectionHeader(_ title: String, icon: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let img = UIImageView(image: UIImage(systemName: icon))
        img.tintColor = Palette.accent
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 16).isActive = true
        img.heightAnchor.constraint(equalToConstant: 16).isActive = true

        let lbl = UILabel()
        lbl.text = title
        lbl.font = UIFont(name: "SFProText-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = Palette.textPrimary
        lbl.letterSpacing(1.2)
        lbl.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(img)
        container.addSubview(lbl)
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 28),
            img.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
            img.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            lbl.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 8),
            lbl.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        return container
    }

    func makeCard() -> UIView {
        let v = UIView()
        v.backgroundColor = Palette.card
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }

    func addToCard(_ card: UIView, views: [UIView]) {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor)
        ])
        // NOTE: Caller is responsible for adding card to contentStack
    }

    func makeTextField(placeholder: String, icon: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.font = .systemFont(ofSize: 15)
        tf.textColor = Palette.textPrimary
        tf.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                       attributes: [.foregroundColor: Palette.textSecond])
        let iconImg = UIImageView(image: UIImage(systemName: icon))
        iconImg.tintColor = Palette.textSecond
        iconImg.contentMode = .scaleAspectFit
        iconImg.frame = CGRect(x: 0, y: 0, width: 36, height: 20)
        tf.leftView = iconImg
        tf.leftViewMode = .always
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }

    func wrapField(_ field: UIView) -> UIView {
        let wrapper = UIView()
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        wrapper.addSubview(field)
        NSLayoutConstraint.activate([
            field.topAnchor.constraint(equalTo: wrapper.topAnchor),
            field.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 16),
            field.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -16),
            field.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
            field.heightAnchor.constraint(equalToConstant: Palette.rowHeight)
        ])
        return wrapper
    }

    func makeScheduleRow(icon: String, label: String, value: String) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.heightAnchor.constraint(equalToConstant: Palette.rowHeight).isActive = true
        row.isUserInteractionEnabled = true

        let img = UIImageView(image: UIImage(systemName: icon))
        img.tintColor = Palette.accent
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false

        let labelLbl = UILabel()
        labelLbl.text = label
        labelLbl.font = .systemFont(ofSize: 15)
        labelLbl.textColor = Palette.textPrimary
        labelLbl.translatesAutoresizingMaskIntoConstraints = false

        let valueLbl = UILabel()
        valueLbl.text = value
        valueLbl.font = .systemFont(ofSize: 15, weight: .medium)
        valueLbl.textColor = Palette.accent
        valueLbl.tag = 999
        valueLbl.translatesAutoresizingMaskIntoConstraints = false

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = Palette.textSecond
        chevron.contentMode = .scaleAspectFit
        chevron.translatesAutoresizingMaskIntoConstraints = false

        [img, labelLbl, valueLbl, chevron].forEach { row.addSubview($0) }
        NSLayoutConstraint.activate([
            img.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            img.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            img.widthAnchor.constraint(equalToConstant: 20),
            img.heightAnchor.constraint(equalToConstant: 20),
            labelLbl.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 12),
            labelLbl.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 9),
            chevron.heightAnchor.constraint(equalToConstant: 14),
            valueLbl.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -8),
            valueLbl.centerYAnchor.constraint(equalTo: row.centerYAnchor)
        ])
        return row
    }

    func makeSwitchRow(label: String, sw: UISwitch) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.heightAnchor.constraint(equalToConstant: Palette.rowHeight).isActive = true

        let lbl = UILabel()
        lbl.text = label
        lbl.font = .systemFont(ofSize: 15)
        lbl.textColor = Palette.textPrimary
        lbl.translatesAutoresizingMaskIntoConstraints = false

        sw.translatesAutoresizingMaskIntoConstraints = false

        row.addSubview(lbl)
        row.addSubview(sw)
        NSLayoutConstraint.activate([
            lbl.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            lbl.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            sw.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            sw.centerYAnchor.constraint(equalTo: row.centerYAnchor)
        ])
        return row
    }

    func makeSeparatorView() -> UIView {
        let v = UIView()
        v.backgroundColor = Palette.separator
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return v
    }

    func makeRowWithSeparator(_ row: UIView, addSep: Bool) -> UIView {
        if addSep {
            let wrapper = UIView()
            wrapper.translatesAutoresizingMaskIntoConstraints = false
            let sep = makeSeparatorView()
            wrapper.addSubview(row)
            wrapper.addSubview(sep)
            NSLayoutConstraint.activate([
                row.topAnchor.constraint(equalTo: wrapper.topAnchor),
                row.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
                row.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
                sep.topAnchor.constraint(equalTo: row.bottomAnchor),
                sep.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 16),
                sep.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
                sep.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor)
            ])
            return wrapper
        }
        return row
    }
}

// MARK: - UILabel helper
private extension UILabel {
    func letterSpacing(_ spacing: CGFloat) {
        if let text = self.text {
            let attrs = NSMutableAttributedString(string: text)
            attrs.addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: text.count))
            attributedText = attrs
        }
    }
}

// MARK: - UITextViewDelegate
extension CreateRunEventViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == eventDescTextView && textView.textColor == Palette.textSecond {
            textView.text = ""
            textView.textColor = Palette.textPrimary
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == eventDescTextView && textView.text.isEmpty {
            textView.text = "Add details about the run…"
            textView.textColor = Palette.textSecond
        }
    }
}

// MARK: - UITextFieldDelegate (poll options)
extension CreateRunEventViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag - 1000
        if tag >= 0 && tag < event.pollOptions.count {
            event.pollOptions[tag] = textField.text ?? ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

