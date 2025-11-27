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
    
    let userLocation = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.overrideUserInterfaceStyle = .dark
        
        labelScreenTitle.sizeToFit()
        labelScreenTitle.text! = NSLocalizedString("Runnr", comment: "")
        labelScreenTitle.textColor = .accent
        
    }

    override func viewDidLayoutSubviews() {
        let height = view.safeAreaInsets.bottom
        initializeMaps(with : height)
        createStartButton()
    }
    
    func initializeMaps(with bottomInset: CGFloat) {
        let camera = GMSCameraPosition.camera(withLatitude: 18.52, longitude: 73.81, zoom: 15.0)
        
        let mapView : GMSMapView!
        let systemOS = UIDevice.current.systemVersion
        
//        print(mainVC.getTabbarHeight())
//        print(UIScreen.main.bounds.height)
//
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
        
        let rootController = RunStartedViewController(nibName: "RunStartedViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: rootController)
        
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.isHidden = true
        
        self.present(navigationController, animated: true, completion: nil)
    }
}
