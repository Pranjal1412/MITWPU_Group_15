//
//  RunPausedViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 18/11/25.
//

import UIKit
import GoogleMaps

class RunPausedViewController: UIViewController {

    @IBOutlet weak var viewSummary: UIView!
    @IBOutlet weak var buttonResume: UIButton!
    @IBOutlet weak var buttonEndRun: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        view.overrideUserInterfaceStyle = .dark
    
        initializeMaps()
        settingButtonStyle()
        view.bringSubviewToFront(viewSummary)
        
    }

    func initializeMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: 18.52, longitude: 73.81, zoom: 15.0)
        
        let mapView : GMSMapView!

        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) , camera: camera)
        
        do {
           if let MapstyleURL = Bundle.main.url(forResource: "GoogleMapStyle", withExtension: "json") {
               mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: MapstyleURL)
           } else {
               NSLog("Unable to find GoogleMapStyle.json")
           }
       } catch {
           NSLog("One or more of the map styles failed to load. \(error)")
       }
        
        mapView.mapType = .normal
        mapView.alpha = 0.3
        
        mapView.settings.rotateGestures = false
        mapView.settings.scrollGestures = false
        mapView.settings.zoomGestures = false
        
//        mapView.layer.shadowColor = UIColor.black.cgColor
//        mapView.layer.shadowRadius = 20.0
//        mapView.layer.shadowOpacity = 0.5
//        mapView.layer.shadowOffset = CGSize(width: 4, height: -1)
        
        view.addSubview(mapView)

    }
 
    func settingButtonStyle() {
        buttonEndRun.layer.cornerRadius = buttonEndRun.frame.height / 2
        buttonResume.layer.cornerRadius = buttonResume.frame.height / 2
        
        buttonEndRun.layer.borderWidth = 0.5
        buttonEndRun.layer.borderColor = UIColor.accent.cgColor
        
        buttonEndRun.imageEdgeInsets = UIEdgeInsets(top: 32, left: 35, bottom: 32, right: 35)
        buttonResume.imageEdgeInsets = UIEdgeInsets(top: 32, left: 35, bottom: 32, right: 35)
    }
    
    @IBAction func resumeButtonPressed(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func EndRunButtonPressed(_ sender: UIButton) {
    
        let alert = UIAlertController(title: "End Run", message: "Are you sure you want to end this run?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let end = UIAlertAction(title: "End Anyway", style: .destructive, handler: { _ in
            print("Settings tapped")
            
            let destinationVC = SaveActivityViewController()
            destinationVC.modalPresentationStyle = .fullScreen
            
            self.navigationController?.present(destinationVC, animated: true, completion: nil)
            
        })
        
        alert.overrideUserInterfaceStyle = .dark
        alert.addAction(end)
        
        present(alert, animated: true , completion: nil)
        
    }
    
    
}
