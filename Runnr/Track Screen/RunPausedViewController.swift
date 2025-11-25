//
//  RunPausedViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 18/11/25.
//

import UIKit
import GoogleMaps

class RunPausedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        view.overrideUserInterfaceStyle = .dark
    
        initializeMaps()
        view.bringSubviewToFront(<#T##view: UIView##UIView#>)
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
        mapView.alpha = 0.5
        
        mapView.settings.rotateGestures = false
        mapView.settings.scrollGestures = false
        mapView.settings.zoomGestures = false
        
//        mapView.layer.shadowColor = UIColor.black.cgColor
//        mapView.layer.shadowRadius = 20.0
//        mapView.layer.shadowOpacity = 0.5
//        mapView.layer.shadowOffset = CGSize(width: 4, height: -1)
        
        view.addSubview(mapView)

    }
    
}
