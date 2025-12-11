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
    
    func initializeMaps(withBottomInset bottomInset: CGFloat = 0.0, withTopOffset topOffset: CGFloat = 0.0,
                        withLeadingInset leadingInset: CGFloat = 0.0, withTrailingInset trailingInset: CGFloat = 0.0,
                        location coordinate: CLLocationCoordinate2D,) -> GMSMapView {
        
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)
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

        mapView = GMSMapView.map(withFrame: CGRect(x: leadingInset, y: topOffset, width: UIScreen.main.bounds.width - (leadingInset + trailingInset), height: UIScreen.main.bounds.height - (topOffset + bottomInset)) , camera: camera)
        
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
    
//    func mapBehavior(isEnabled: Bool) {
//        mapView.settings.rotateGestures = isEnabled
//        mapView.settings.scrollGestures = isEnabled
//        mapView.settings.zoomGestures = isEnabled
//    }
    
    func userLocationMarkerSetting(isEnabled: Bool) {
        mapView.isMyLocationEnabled = isEnabled
        mapView.settings.myLocationButton = isEnabled
    }
    
    func setRouteLineStyle() {
        self.routeLine.strokeColor = UIColor.accent
        self.routeLine.strokeWidth = 8.0
        self.routeLine.geodesic = true
        self.routeLine.map = mapView
    }
}
