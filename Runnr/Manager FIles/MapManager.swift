//
//  MapManager.swift
//  Runnr
//
//  Created by SDC-USER on 09/12/25.
//

import GoogleMaps
import UIKit

class MapManager {

    var mapView = GMSMapView()
    var routeLine = GMSPolyline()
    var path = GMSMutablePath()
    var startMarker = GMSMarker()
//    var endMarker = GMSMarker()

    func initializeMaps(withX valueOfX: CGFloat = 0.0, withY valueOfY: CGFloat = 0.0,
                        withWidth width: CGFloat, withHeight height: CGFloat,
                        location coordinate: CLLocationCoordinate2D, ) -> GMSMapView {

        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)

//        following code is deprecated
//        mapView = GMSMapView.map(withFrame: CGRect(x: valueOfX, y: valueOfY, width: width, height: height), camera: camera)

        let options = GMSMapViewOptions()
        options.frame = CGRect(x: valueOfX, y: valueOfY, width: width, height: height)
        options.camera = camera

        mapView = GMSMapView(options: options)

        do {
           if let mapstyleURL = Bundle.main.url(forResource: "GoogleMapStyle", withExtension: "json") {
               mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: mapstyleURL)
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
