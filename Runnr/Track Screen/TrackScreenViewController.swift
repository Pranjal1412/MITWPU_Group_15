//
//  TrackScreenViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 26/10/25.
//

import UIKit
import GoogleMaps

class TrackScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeMaps()
        createStartButton()
        view.overrideUserInterfaceStyle = .dark

    }

    func initializeMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: 18.52, longitude: 73.81, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 140, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 140), camera: camera)
        
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
        
        mapView.settings.rotateGestures = false
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = false
        
//        mapView.layer.shadowColor = UIColor.black.cgColor
//        mapView.layer.shadowRadius = 20.0
//        mapView.layer.shadowOpacity = 0.5
//        mapView.layer.shadowOffset = CGSize(width: 4, height: -1)
        
        view.addSubview(mapView)
    }
    
    func createStartButton() {
        let startButton = UIButton()
        
        startButton.frame = CGRect(x: (UIScreen.main.bounds.width - 150)/2.0,
                                   y: (UIScreen.main.bounds.height - 150)/2.0,
                                   width: 150, height: 150)
        startButton.backgroundColor = .accent
        
        startButton.setTitle(NSLocalizedString("START", comment: ""), for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        startButton.layer.cornerRadius = startButton.bounds.height / 2.0
        
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        view.addSubview(startButton)
    }
    
    @objc func startButtonPressed() {
        print("Start Pressed!")
        
        let RunStartedVC = RunStartedViewController(nibName: "RunStartedViewController", bundle: nil)
        RunStartedVC.modalPresentationStyle = .fullScreen
        self.present(RunStartedVC, animated: true, completion: nil)
    }
}
