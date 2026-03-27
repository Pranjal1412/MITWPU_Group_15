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
    @IBOutlet weak var labelActivityHeading: UILabel!
    
    var isNewActivity : Bool = false
    var isMapInitialized: Bool = false

    let topGradientView = UIView()
    
    private let userLocation = UserLocationManager()
    private var activityData = DataSource.shared.getCurrentActivity()
    private var routeCoordinates = DataSource.shared.getCurrentActivityCoordinates()

    override func viewDidLoad() {
        super.viewDidLoad()
                        
        setGlassEffect(for: self.buttonBack, withImage: "chevron.backward")
        
        self.labelActivityHeading.text = activityData?.activity?.activityTitle
        
        self.userLocation.locationManager.startUpdatingLocation()
        self.userLocation.onLocationUpdate = { location in
            
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
                
                Task {
                    if let decodedPath = GMSPath(fromEncodedPath: self.activityData!.activity!.mapCoordinatesPolyline!),
                       let mutablePath = decodedPath.mutableCopy() as? GMSMutablePath {
                        mapManager.path = mutablePath
                        mapManager.routeLine.path = mutablePath
                        mapManager.setRouteLineStyle()
                    }
                    
    //                GMSCoordinateBounds() consider like it creates an imaginary rectangle such that it covers every coordinate
    //                the list of coordinates are being set using bounds = bounds.includingCoordinate(coordinate)
                    if let path = GMSPath(fromEncodedPath: self.activityData!.activity!.mapCoordinatesPolyline!) {
                        
                        var bounds = GMSCoordinateBounds()
                        for i in 0..<path.count() {
                            bounds = bounds.includingCoordinate(path.coordinate(at: i))
                        }
                        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 70))
                    }
                }
                
                self.topGradientView.frame.size.height = 100
                self.topGradientView.frame.size.width = mapView.frame.size.width
                self.topGradientView.frame.origin.y = mapView.frame.origin.y - 10
                self.topGradientView.frame.origin.x = mapView.frame.origin.x
                addTopGradient(to: self.topGradientView)
                
                self.view.addSubview(mapView)
                self.view.addSubview(self.topGradientView)

                self.userLocation.locationManager.stopUpdatingLocation()
                self.isMapInitialized = true
            }
        }
        
    }

    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
