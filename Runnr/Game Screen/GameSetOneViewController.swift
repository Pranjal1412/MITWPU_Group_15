//
//  GameSetOneViewController.swift
//  Runnr
//
//  Created by Archit Kankaria on 05/01/26.
//

import UIKit

class GameSetOneViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var textFieldGameSelection: UITextField!
    @IBOutlet weak var viewChoose: UIView!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
        }
        
    private func setupUI() {
        overrideUserInterfaceStyle = .dark
        viewName.layer.cornerRadius = 15
        viewName.layer.borderWidth = 1
        viewName.layer.borderColor = UIColor.white.cgColor
        viewChoose.layer.cornerRadius = 15
        viewChoose.layer.borderWidth = 1
        viewChoose.layer.borderColor = UIColor.white.cgColor
        textFieldGameSelection.inputView = UIView() // This disables the keyboard
        textFieldGameSelection.tintColor = .clear   // This hides the blinking cursor
        nextButton.layer.cornerRadius = 45
        let today = Date()
            datePicker.minimumDate = today
            if let nextYear = Calendar.current.date(byAdding: .year, value: 1, to: today) {
                datePicker.maximumDate = nextYear
            }
}
    @IBAction func pickerDate(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        print(selectedDate)
    }
    
    @IBAction func pickerSlider(_ sender: UISlider) {
        let selectedValue = round(sender.value / 10) * 10
            sender.setValue(selectedValue, animated: true)
            print("Game Duration: \(Int(selectedValue))")
        }
    
    @IBAction func buttonAddFriend(_ sender: UIButton) {
        print("Button pressed")
    }
    
    @IBAction func buttonDropDown(_ sender: UIButton) {
        let options = ["Walking", "Running", "Hiking"]
            print("clicked")
            let actions = options.map { title in
                UIAction(title: title) { [weak self] action in
                    self?.textFieldGameSelection.text = action.title
                }
            }
            sender.menu = UIMenu(title: "Select Sport", children: actions)
            sender.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func buttonNext(_ sender: UIButton) {
        guard let name = textFieldName.text, !name.isEmpty else {
                    showAlert(message: "Please enter a game name")
                    return
                }
                
                guard let sport = textFieldGameSelection.text, !sport.isEmpty else {
                    showAlert(message: "Please select a game")
                    return
                }
        let destinationVC = GameSetTwoViewController()
        self.present(destinationVC, animated: true, completion: nil)
    }
    private func showAlert(message: String) {
            let alert = UIAlertController(title: "Missing Information", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            // Ensure the alert respects the dark theme
            alert.view.tintColor = UIColor(red: 0.68, green: 1.0, blue: 0.0, alpha: 1.0) // Your lime green color
            
            self.present(alert, animated: true, completion: nil)
        }
    @IBAction func buttonClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
