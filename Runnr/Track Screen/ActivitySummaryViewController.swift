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
    
    var isMapInitialized: Bool = false
    var isNewActivity : Bool = false


    let topGradientView = UIView()
    
    private let userLocation = UserLocationManager()
    private var activityData = DataSource.shared.getCurrentActivity()
    private var routeCoordinates = DataSource.shared.getCurrentActivityCoordinates()

    override func viewDidLoad() {
        super.viewDidLoad()
                        
        setGlassEffect(for: self.buttonBack, withImage: "chevron.backward")
        
        self.labelActivityHeading.text = activityData?.activityTitle
        
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
                    let CLcoordinates = self.convertToCLLocationCoordinate2D(for: self.routeCoordinates)
                    
                    mapManager.path = self.convertCoordinatesToGMSMutablePath(from: CLcoordinates)
                    mapManager.routeLine.path = mapManager.path
                    mapManager.setRouteLineStyle()
                    
    //                GMSCoordinateBounds() consider like it creates an imaginary rectangle such that it covers every coordinate
    //                the list of coordinates are being set using bounds = bounds.includingCoordinate(coordinate)
                    var bounds = GMSCoordinateBounds()
    //                to pass the entire track you need to loop through it
                    CLcoordinates.forEach { coordinate in
                        bounds = bounds.includingCoordinate(coordinate)
                    }
                    
    //                here we are now adjusting map such that it cover the entire track
                    mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 70))

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
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if self.isNewActivity {
                if let analysisVC = self.presentingViewController {
                    if let navController = analysisVC.presentingViewController {
                        self.dismiss(animated: false) {
                            analysisVC.dismiss(animated: false) {
                                navController.dismiss(animated: true)
                            }
                        }
                    }
                }
            } else {
                self.dismiss(animated: true)
            }
    }
    
    func convertToCLLocationCoordinate2D(for coordinates: [ActivityRouteCoordinates]) -> [CLLocationCoordinate2D] {
                
        var coordinates: [CLLocationCoordinate2D] = []
        for coordinate in routeCoordinates {
            let gmsCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            coordinates.append(gmsCoordinate)
        }
        
        return coordinates
    }
    
    func convertCoordinatesToGMSMutablePath(from coordinates: [CLLocationCoordinate2D]) -> GMSMutablePath {
        let path = GMSMutablePath()
        
        for coordinate in coordinates {
            path.add(coordinate)
        }
        
        return path
    }

}
