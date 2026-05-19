//
//  ConnectDeviceViewController.swift
//  Runnr
//
//  Created by SDC-USER on 23/01/26.
//

import UIKit

class ConnectDeviceViewController: UIViewController {

    @IBOutlet weak var viewImageBackground: UIView!
    @IBOutlet weak var buttonConnectDevice: UIButton!
    @IBOutlet weak var buttonSkip: UIButton!
    @IBOutlet weak var imageWatch: UIImageView!
    @IBOutlet weak var viewImageSubBackground: UIView!

    let healthKitManager = HealthKitManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        settingUpElements()
    }

    func settingUpElements() {
        self.viewImageBackground.layer.cornerRadius = 50
        self.viewImageBackground.backgroundColor = .modalBackground
        self.viewImageBackground.layer.borderColor = UIColor.gray.cgColor
        self.viewImageBackground.layer.borderWidth = 1.5

        self.viewImageSubBackground.layer.cornerRadius = 50
        self.viewImageSubBackground.layer.borderColor = UIColor.accentColorLight.cgColor
        self.viewImageSubBackground.layer.borderWidth = 2
        self.viewImageSubBackground.layer.shadowColor = UIColor.accent.withAlphaComponent(0.3).cgColor
        self.viewImageSubBackground.layer.shadowOpacity = 0.5
        self.viewImageSubBackground.layer.shadowRadius = 50

        self.buttonConnectDevice.layer.cornerRadius = self.buttonConnectDevice.frame.height / 2
    }

    @IBAction func connectWatchClicked(_ sender: UIButton) {

        healthKitManager.requestPermission { granted in
            if granted {
                self.buttonConnectDevice.isEnabled = false
                self.buttonConnectDevice.setTitle("Connected", for: .disabled)
                self.buttonConnectDevice.backgroundColor = .darkGray
                self.dismiss(animated: true)
            }
        }

    }

}
