//
//  ActivityDetailViewController.swift
//  Runnr
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit
import GoogleMaps

class ActivitySummaryViewController: UIViewController {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonShowAnalysis: UIButton!
    @IBOutlet weak var labelActivityHeading: UILabel!
    
    var isMapInitialized: Bool = false
    let userLocation = UserLocationManager()
    var activityData : MyRunActivity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if #available(iOS 26.0, *) {
            buttonBack.configuration = .glass()
            buttonBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            buttonBack.tintColor = .white
        } else {
            buttonBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            buttonBack.frame.origin.x = 100.0
            buttonBack.tintColor = .white
        }
        
        buttonShowAnalysis.layer.cornerRadius = buttonShowAnalysis.frame.height / 2.0
        labelActivityHeading.text = activityData?.runTitle
        
        userLocation.locationManager.startUpdatingLocation()
        userLocation.onLocationUpdate = { location in
            
            if self.isMapInitialized == false {
                
                let mapManager = MapManager()
                let topOffset = self.labelActivityHeading.frame.origin.y + self.labelActivityHeading.frame.height + 20.0
                let mapView = mapManager.initializeMaps(withX: 0.0, withY: topOffset,
                                                       withWidth: self.view.frame.width,
                                                       withHeight: self.view.frame.height - topOffset,
                                                       location: location.coordinate)
                
                mapView.settings.scrollGestures = true
                mapView.settings.zoomGestures = true
                mapView.settings.rotateGestures = true
                
                mapManager.path = self.convertCoordinatesToPath(from: self.activityData?.routeCoordinates ?? [])
                mapManager.routeLine.path = mapManager.path
                mapManager.setRouteLineStyle()
                
//                GMSCoordinateBounds() consider like it creates an imaginary rectangle such that it covers every coordinate
//                the list of coordinates are being set using bounds = bounds.includingCoordinate(coordinate)
                var bounds = GMSCoordinateBounds()
//                to pass the entire track you need to loop through it
                self.activityData?.routeCoordinates.forEach { coordinate in
                    bounds = bounds.includingCoordinate(coordinate)
                }

                
//                here we are now adjusting map such that it cover the entire track
                mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 70))
                
                self.view.addSubview(mapView)
                self.view.bringSubviewToFront(self.buttonShowAnalysis)
                self.userLocation.locationManager.stopUpdatingLocation()
                self.isMapInitialized = true
            }
            
        }
        
//        print(activityData?.runTitle)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        if let presenter = self.presentingViewController {
            self.dismiss(animated: false) {
                presenter.dismiss(animated: false, completion: nil)
            }

        }
                
    }
    
    @IBAction func showAnalysisOfRunPressed(_ sender: UIButton) {
        
        let destinationVC = ActivityAnalysisViewController()
        destinationVC.activityData = self.activityData
        self.present(destinationVC, animated: true)
    }
    
    
    func convertCoordinatesToPath(from coordinates: [CLLocationCoordinate2D]) -> GMSMutablePath {
        let path = GMSMutablePath()
            for coordinate in coordinates {
                path.add(coordinate)
            }
            return path
    }
}
