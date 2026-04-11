import UIKit
import SwiftUI

class CreateRunEventViewController: UIViewController {

    public var club: Club?
    
    public var clubDetails: Club? {
        get { club }
        set { club = newValue }
    }

    // Keep IBOutlets just in case to prevent crashes from xib connects
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide existing views from nib
        self.view.subviews.forEach { $0.isHidden = true }
        self.view.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.08, alpha: 1.0)
        
        let hostingController = UIHostingController(rootView: CreateRunEventView(dismissAction: { [weak self] in
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            self?.dismiss(animated: true)
        }))
        
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    // Existing actions
    @IBAction func cancelTapped(_ sender: UIButton) { }
    @IBAction func postTapped(_ sender: UIButton) { }
    @IBAction func sameStartToggled(_ sender: UISwitch) { }
}

struct PollOptionItem: Identifiable {
    let id = UUID()
    var title: String
    var icon: String
}

struct CreateRunEventView: View {
    var dismissAction: () -> Void
    
    @State private var eventName: String = ""
    @State private var eventDetails: String = ""
    
    @State private var date: Date = Date()
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(3600)
    
    @State private var startingPoint: String = ""
    @State private var endingPoint: String = ""
    @State private var sameAsStart: Bool = false
    
    @State private var pollQuestion: String = ""
    
    @State private var pollOptions: [PollOptionItem] = [
        PollOptionItem(title: "Yes", icon: "checkmark.circle.fill"),
        PollOptionItem(title: "Maybe", icon: "questionmark.circle.fill"),
        PollOptionItem(title: "No", icon: "xmark.circle.fill")
    ]
    
    let darkGray = Color(red: 0.12, green: 0.12, blue: 0.12)
    let almostBlack = Color(red: 0.08, green: 0.08, blue: 0.08)
    let accentGreen = Color(red: 0.68, green: 0.97, blue: 0.27)
    let textGray = Color(red: 0.6, green: 0.6, blue: 0.6)

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    dismissAction()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color(white: 0.2))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text("New Run Event")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .offset(x: -20)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // EVENT DETAILS
                    SectionView(title: "EVENT DETAILS", icon: "doc.text") {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Image(systemName: "pencil")
                                    .foregroundColor(textGray)
                                    .font(.system(size: 14))
                                TextField("Event Name", text: $eventName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            }
                            .padding()
                            
                            Divider().background(Color(white: 0.25))
                            
                            ZStack(alignment: .topLeading) {
                                if eventDetails.isEmpty {
                                    Text("Add details about the run...")
                                        .foregroundColor(textGray)
                                        .font(.system(size: 16))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 16)
                                }
                                TextEditor(text: $eventDetails)
                                    .foregroundColor(.white)
                                    .scrollContentBackground(.hidden)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minHeight: 100)
                            }
                        }
                        .background(darkGray)
                        .cornerRadius(12)
                    }
                    
                    // SCHEDULE
                    SectionView(title: "SCHEDULE", icon: "calendar.badge.clock") {
                        VStack(alignment: .leading, spacing: 0) {
                            ScheduleRow(icon: "calendar", title: "Date", color: accentGreen) {
                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .labelsHidden()
                                    .colorScheme(.dark)
                                    .accentColor(accentGreen)
                            }
                            Divider().background(Color(white: 0.25)).padding(.leading, 40)
                            ScheduleRow(icon: "clock", title: "Start Time", color: accentGreen) {
                                DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .colorScheme(.dark)
                                    .accentColor(accentGreen)
                            }
                            Divider().background(Color(white: 0.25)).padding(.leading, 40)
                            ScheduleRow(icon: "clock.fill", title: "End Time", color: accentGreen) {
                                DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .colorScheme(.dark)
                                    .accentColor(accentGreen)
                            }
                        }
                        .background(darkGray)
                        .cornerRadius(12)
                    }
                    
                    // LOCATION
                    SectionView(title: "LOCATION", icon: "mappin.and.ellipse") {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Image(systemName: "location.north.fill")
                                    .foregroundColor(textGray)
                                    .rotationEffect(.degrees(45))
                                    .frame(width: 24)
                                TextField("Starting point", text: $startingPoint)
                                    .foregroundColor(.white)
                                    .onChange(of: startingPoint) { newValue in
                                        if sameAsStart {
                                            endingPoint = newValue
                                        }
                                    }
                            }
                            .padding()
                            
                            Divider().background(Color(white: 0.25)).padding(.leading, 40)
                            
                            HStack {
                                Image(systemName: "flag.fill")
                                    .foregroundColor(textGray)
                                    .frame(width: 24)
                                TextField("Ending point", text: $endingPoint)
                                    .foregroundColor(sameAsStart ? textGray : .white)
                                    .disabled(sameAsStart)
                            }
                            .padding()
                            
                            Divider().background(Color(white: 0.25)).padding(.leading, 40)
                            
                            HStack {
                                Text("Same as Start")
                                    .foregroundColor(.white)
                                Spacer()
                                Toggle("", isOn: $sameAsStart)
                                    .labelsHidden()
                                    .tint(accentGreen)
                                    .scaleEffect(0.9)
                                    .onChange(of: sameAsStart) { isSame in
                                        if isSame {
                                            endingPoint = startingPoint
                                        } else {
                                            endingPoint = ""
                                        }
                                    }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                        .background(darkGray)
                        .cornerRadius(12)
                    }
                    
                    // POLL
                    SectionView(title: "POLL", icon: "chart.bar.fill") {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 12) {
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(textGray)
                                TextField("Are you coming?", text: $pollQuestion)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            
                            ForEach(pollOptions.indices, id: \.self) { index in
                                Divider().background(Color(white: 0.25)).padding(.leading, 44)
                                PollOptionRow(option: $pollOptions[index], iconColor: accentGreen) {
                                    pollOptions.remove(at: index)
                                }
                            }
                            
                            Divider().background(Color(white: 0.25)).padding(.leading, 44)
                            
                            Button(action: {
                                pollOptions.append(PollOptionItem(title: "", icon: "circle"))
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(accentGreen)
                                    Text("+ Add Option")
                                        .foregroundColor(accentGreen)
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                        .background(darkGray)
                        .cornerRadius(12)
                        // Trigger animation when array changes length
                        .animation(.easeInOut, value: pollOptions.count)
                    }
                    
                    // Bottom Buttons
                    VStack(spacing: 16) {
                        Button(action: {
                            // Gather data into an event structure or submit to presenter here.
                            dismissAction()
                        }) {
                            Text("Create Event")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(accentGreen)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            dismissAction()
                        }) {
                            Text("Save as Draft")
                                .font(.system(size: 14))
                                .foregroundColor(textGray)
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 20)
            }
        }
        .background(almostBlack.edgesIgnoringSafeArea(.all))
        // Dismiss keyboard on tap
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct SectionView<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    let accentGreen = Color(red: 0.68, green: 0.97, blue: 0.27)
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(accentGreen)
                    .font(.system(size: 14, weight: .bold))
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(1.0)
            }
            .padding(.leading, 2)
            
            content
        }
    }
}

struct ScheduleRow<Content: View>: View {
    let icon: String
    let title: String
    let color: Color
    let pickerContent: Content
    
    init(icon: String, title: String, color: Color, @ViewBuilder pickerContent: () -> Content) {
        self.icon = icon
        self.title = title
        self.color = color
        self.pickerContent = pickerContent()
    }

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            pickerContent
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

struct PollOptionRow: View {
    @Binding var option: PollOptionItem
    let iconColor: Color
    var removeAction: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: option.icon)
                .foregroundColor(iconColor)
                .frame(width: 24)
            TextField("Option", text: $option.title)
                .foregroundColor(.white)
            Spacer()
            Button(action: removeAction) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(Color(red: 0.8, green: 0.2, blue: 0.2))
                    .font(.system(size: 22))
            }
        }
        .padding()
    }
}

