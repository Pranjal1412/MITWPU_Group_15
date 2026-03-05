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
    @IBOutlet weak var buttonMoreOptions: UIButton!
    
    var showAlert : Bool = false
    var isMapInitialized: Bool = false

    let topGradientView = UIView()
    
    private let userLocation = UserLocationManager()
    private var activityData = DataSource.shared.getCurrentActivity()
    private var routeCoordinates = DataSource.shared.getCurrentActivityCoordinates()

    override func viewDidLoad() {
        super.viewDidLoad()
                        
        setGlassEffect(for: self.buttonBack, withImage: "chevron.backward")
        setGlassEffect(for: self.buttonMoreOptions, withImage: "ellipsis")
        
        self.buttonShowAnalysis.layer.cornerRadius = buttonShowAnalysis.frame.height / 2.0
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

                self.view.bringSubviewToFront(self.buttonShowAnalysis)
                self.userLocation.locationManager.stopUpdatingLocation()
                self.isMapInitialized = true
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.showAlert {
            let alert = UIAlertController(title: String(localized: "Congratulations!"), message: "You have earned \(activityData!.basePoints! + activityData!.skillPoints!) points. Claim them now!", preferredStyle: .alert)
            let claimPointsAction = UIAlertAction(title: String(localized: "Claim Points"), style: .default)
        
            alert.addAction(claimPointsAction)
            
            self.present(alert, animated: true , completion: nil)
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func showAnalysisOfRunPressed(_ sender: UIButton) {
        
        let destinationVC = ActivityAnalysisViewController()
        destinationVC.activityData = self.activityData
        self.present(destinationVC, animated: true)
    }
    
    @IBAction func didTapOnMoreOptions(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share Activity", style: .default)
        let deleteAction = UIAlertAction(title: "Delete Activity", style: .destructive) { _ in
            if self.activityData != nil {
                self.deleteActivityAlert(userActivity: (self.activityData!))
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
     
    func deleteActivityAlert(userActivity : UserActivity) {
         let alert = UIAlertController(title: "Delete Activity", message: "Are you sure you want to delete this activity?", preferredStyle: .alert)
         
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
             Task {
                 await deleteUserActivity(activityID: userActivity.activityID!, mapImageURL: userActivity.mapImageURL!)
                 self.dismiss(animated: true)
             }
         }
         
         alert.addAction(cancelAction)
         alert.addAction(deleteAction)
         
         present(alert, animated: true, completion: nil)

     }
  
//    func convertCoordinatesToPath(from coordinates: [CLLocationCoordinate2D]) -> GMSMutablePath {
//        let path = GMSMutablePath()
//            for coordinate in coordinates {
//                path.add(coordinate)
//            }
//            return path
//    }
    
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
