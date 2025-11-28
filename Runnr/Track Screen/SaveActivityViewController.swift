//
//  SaveActivityViewController.swift
//  Runnr
//
//  Created by SDC-USER on 27/11/25.
//

import UIKit

class SaveActivityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.overrideUserInterfaceStyle = .dark
        
        // Do any additional setup after loading the view.
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Delete Activity", message: "Are you sure you want to Delete this Activity?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIButton) {
        
        navigationController?.popToRootViewController(animated: false)
        
        
        
    }
    
    
}
