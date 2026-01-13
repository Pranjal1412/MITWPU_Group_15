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
    @IBOutlet weak var viewChoose: UIView!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var buttonCloseAndBack: UIButton!
    @IBOutlet weak var buttonAddFriend: UIButton!
    @IBOutlet weak var stackDuration: UIStackView!
    @IBOutlet weak var stackGameStart: UIStackView!
    @IBOutlet weak var stackChoose: UIStackView!
    @IBOutlet weak var stackName: UIStackView!
    @IBOutlet weak var viewChooseColour: UIView!
    @IBOutlet weak var viewGameDetails: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonRed: UIButton!
    @IBOutlet weak var buttonCyan: UIButton!
    @IBOutlet weak var buttonMint: UIButton!
    @IBOutlet weak var buttonDropDown: UIButton!
    
    @IBOutlet weak var labelYourSport: UILabel!
    override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            setupMenu()
            view.backgroundColor = UIColor(named: "modalBackground")
        }
        
    private func setupUI() {
        overrideUserInterfaceStyle = .dark
        viewName.layer.cornerRadius = 15
        viewName.layer.borderWidth = 1
        viewName.layer.borderColor = UIColor.white.cgColor
        viewChoose.layer.cornerRadius = 15
        viewChoose.layer.borderWidth = 1
        viewChoose.layer.borderColor = UIColor.white.cgColor
        nextButton.layer.cornerRadius = 45
        let today = Date()
            datePicker.minimumDate = today
            if let nextYear = Calendar.current.date(byAdding: .year, value: 1, to: today) {
                datePicker.maximumDate = nextYear
            }
        buttonCloseAndBack.setImage(UIImage(systemName: "multiply"), for: .normal)
        buttonRed.isHidden = true
        buttonCyan.isHidden = true
        buttonMint.isHidden = true
        stackName.isHidden = false
        stackChoose.isHidden = false
        stackGameStart.isHidden = false
        datePicker.isHidden = false
        stackDuration.isHidden = false
        buttonAddFriend.isHidden = false
        buttonDropDown.isHidden = false
        nextButton.setTitle("Next", for: .normal)
        labelTitle.text = "Set your Game"
        viewGameDetails.backgroundColor = .accent
        viewChooseColour.backgroundColor = .gray
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
    
    @IBAction func buttonNext(_ sender: UIButton) {
        if nextButton.title(for: .normal) == "Next" {
            guard let name = textFieldName.text, !name.isEmpty else {
                        showAlert(message: "Please enter a game name")
                        return
                    }
    //        guard let gameSelection = textFieldGameSelection.text, !gameSelection.isEmpty else {
    //            showAlert(message: "Please select a game")
    //            return
    //        }

            stackName.isHidden = true
            stackChoose.isHidden = true
            stackGameStart.isHidden = true
            datePicker.isHidden = true
            stackDuration.isHidden = true
            buttonAddFriend.isHidden = true
            buttonDropDown.isHidden = true
            labelTitle.text = "Choose your Colour"
            buttonRed.isHidden = false
            buttonCyan.isHidden = false
            buttonMint.isHidden = false
            viewChooseColour.backgroundColor = .accent
            viewGameDetails.backgroundColor = .gray
            nextButton.setTitle("Start Game", for: .normal)
            buttonCloseAndBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        }
        else {
            
            if let presenter = self.presentingViewController {
                self.dismiss(animated: true) {
                    let destinationVC = BattleRunViewController()
                    destinationVC.modalPresentationStyle = .fullScreen
                    presenter.present(destinationVC, animated: true, completion: nil)
                }

            }

        }
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
        
        if buttonCloseAndBack.currentImage == UIImage(systemName: "multiply") {
            self.dismiss(animated: true, completion: nil)
        }
        else if buttonCloseAndBack.currentImage == UIImage(systemName: "chevron.backward") {
            setupUI()
        }

    }
    func setupMenu() {

        let run = UIAction(title: "Running") { _ in
            self.labelYourSport.text="Running"
            self.labelYourSport.textColor = .white
        }

        let walk = UIAction(title: "Walking") { _ in
            self.labelYourSport.text="Walking"
            self.labelYourSport.textColor = .white

        }

        let cycle = UIAction(title: "Hiking") { _ in
            self.labelYourSport.text="Hiking"
            self.labelYourSport.textColor = .white

        }

        buttonDropDown.menu = UIMenu(children: [run, walk, cycle])
        buttonDropDown.showsMenuAsPrimaryAction = true
        self.buttonDropDown.setTitleColor(.accent, for: .normal)
    }
 
    @IBAction func colorSelection(_ sender: UIButton) {
        let colorButtons = [buttonMint, buttonCyan, buttonRed]
            
            // 2. Loop through all buttons to reset them to a "deselected" state
            colorButtons.forEach { button in
                button?.tag = 0
                button?.layer.borderWidth = 0.0
                button?.layer.cornerRadius = 0 // Or your default radius
            }
            
            // 3. Select only the button that was tapped
            sender.tag = 1
            sender.layer.borderWidth = 4.0
            sender.layer.borderColor = UIColor.white.cgColor
            sender.layer.cornerRadius = 15
            sender.layer.masksToBounds = true
    }
}
