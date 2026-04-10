import UIKit

class CreateRunEventViewController: UIViewController, UITextViewDelegate {

    // MARK: - IBOutlets
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        eventDescTextView.delegate = self
        
        buttonSave.layer.cornerRadius = 12
        buttonCancel.layer.cornerRadius = buttonCancel.frame.height / 2
        
        let cancelConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        buttonCancel.setImage(UIImage(systemName: "multiply", withConfiguration: cancelConfig), for: .normal)
        
        let saveConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        buttonSave.setImage(UIImage(systemName: "checkmark", withConfiguration: saveConfig), for: .normal)
        
        eventDescTextView.layer.borderWidth = 1
        eventDescTextView.layer.borderColor = UIColor.darkGray.cgColor
        eventDescTextView.layer.cornerRadius = 10
        
        // Add styling logic for aesthetics
        for tf in [eventNameField, dateField, startTimeField, endTimeField, startLocField, endLocField, pollQuestionField, pollOption1Field, pollOption2Field] {
            tf?.layer.cornerRadius = 8
            tf?.layer.borderWidth = 0.5
            tf?.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    // MARK: - IBActions
    @IBAction func cancelTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Discard Changes", message: "Do you want to discard your current changes?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let discardAction = UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(discardAction)
        self.present(alertController, animated: true)
    }

    @IBAction func postTapped(_ sender: UIButton) {
        // Collect data from IBOutlets and post it.
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        self.dismiss(animated: true)
    }
    
    @IBAction func sameStartToggled(_ sender: UISwitch) {
        if sender.isOn {
            endLocField.text = startLocField.text
            endLocField.isEnabled = false
            endLocField.alpha = 0.5
        } else {
            endLocField.isEnabled = true
            endLocField.alpha = 1.0
            endLocField.text = ""
        }
    }
}
