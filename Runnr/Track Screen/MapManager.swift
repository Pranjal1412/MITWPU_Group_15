//
//  MapManager.swift
//  Runnr
//
//  Created by SDC-USER on 09/12/25.
//

import GoogleMaps
import UIKit

class MapManager {
    
    private var mapView = GMSMapView()
    var routeLine = GMSPolyline()
    var path = GMSMutablePath()
    var startMarker = GMSMarker()
//    var endMarker = GMSMarker()
    
    func initializeMaps(withX valueOfX: CGFloat = 0.0, withY valueOfY: CGFloat = 0.0,
                        withWidth width: CGFloat, withHeight height: CGFloat,
                        location coordinate: CLLocationCoordinate2D,) -> GMSMapView {
        
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: valueOfX, y: valueOfY, width: width, height: height), camera: camera)
        
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
        
        return mapView
    }
    
    func userLocationMarkerSetting(isEnabled: Bool) {
        mapView.isMyLocationEnabled = isEnabled
        mapView.settings.myLocationButton = isEnabled
    }
    
    func setRouteLineStyle() {
        self.routeLine.strokeColor = UIColor.accent
        self.routeLine.strokeWidth = 5.0
        self.routeLine.geodesic = true
        self.routeLine.map = mapView
    }
    
    func addStartMarker(at coordinate: CLLocationCoordinate2D) {
        startMarker = GMSMarker(position: coordinate)
//        startMarker.title = "Start"
        startMarker.icon = UIImage(systemName: "figure.run.circle.fill")
        startMarker.map = mapView
    }
    


    
//    func resizedSymbol(_ systemName: String, size: CGFloat, color: UIColor) -> UIImage? {
//        let config = UIImage.SymbolConfiguration(pointSize: size, weight: .regular)
//
//        return UIImage(systemName: systemName, withConfiguration: config)?.withTintColor(color, renderingMode: .alwaysOriginal)
//    }
    
//    func addEndMarker(at coordinate: CLLocationCoordinate2D) {
//        endMarker = GMSMarker(position: coordinate)
//        startMarker.title = "Start"
//        endMarker.icon = GMSMarker.markerImage(with: .red)
//        endMarker.map = mapView
//    }
}

// MARK: - to be deleted

//        let systemOS = UIDevice.current.systemVersion
//
//        if systemOS < "26" {
//            mapView = GMSMapView.map(withFrame: CGRect(x: leadingInset, y: topOffset, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (topOffset + bottomInset)) , camera: camera)
//        }
//
//        else {
//            mapView = GMSMapView.map(withFrame: CGRect(x: leadingInset, y: topOffset, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - topOffset), camera: camera)
//
//        }

//        mapView = GMSMapView.map(withFrame: CGRect(x: leadingInset, y: topOffset, width: UIScreen.main.bounds.width - (leadingInset + trailingInset), height: UIScreen.main.bounds.height - (topOffset + bottomInset)) , camera: camera)
