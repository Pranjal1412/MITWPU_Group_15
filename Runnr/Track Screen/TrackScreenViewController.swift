//
//  TrackScreenViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 26/10/25.
//

import UIKit
import GoogleMaps


class TrackScreenViewController: UIViewController {
    
    @IBOutlet weak var labelScreenTitle: UILabel!
    
    let userLocation = UserLocationManager()
    var isMapInitialized = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.overrideUserInterfaceStyle = .dark
        
        labelScreenTitle.sizeToFit()
        labelScreenTitle.text! = NSLocalizedString("Runnr", comment: "")
        labelScreenTitle.textColor = .accent

        userLocation.requestLocation()
        
    }

    override func viewDidLayoutSubviews() {
        let height = view.safeAreaInsets.bottom
        
        userLocation.onLocationUpdate = { coordinate in
            if self.isMapInitialized == false {
                self.initializeMaps(with : height, location : coordinate)
                self.isMapInitialized = true
            }
        }
        
        createStartButton()
    }
    
    func initializeMaps(with bottomInset: CGFloat, location coordinate: CLLocationCoordinate2D) {
        
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)
        
        let systemOS = UIDevice.current.systemVersion
        let mapView: GMSMapView!
        
        let topOffset = labelScreenTitle.frame.height + labelScreenTitle.frame.origin.y + 20.0
        
        if systemOS < "26" {
            mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 140, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - topOffset - bottomInset) , camera: camera)
        }
        
        else {
            mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 140, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - topOffset), camera: camera)
            
            print(bottomInset)
        }

        
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
        mapView.settings.scrollGestures = false
        mapView.settings.zoomGestures = false
        
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
        
        let destinationVC = SetGoalViewController()
        self.present(destinationVC, animated: true, completion: nil)
        
//        let destinationVC = LoginViewController()
//        destinationVC.modalPresentationStyle = .fullScreen
//        self.present(destinationVC, animated: true, completion: nil)
        
    }
}
