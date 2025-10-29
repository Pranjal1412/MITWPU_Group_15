//
//  TrackScreenViewController.swift
//  Runnr
//
//  Created by Pranjal Shinde on 26/10/25.
//

import UIKit
import MapKit

class TrackScreenViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        createStartButton()
        
        let initialLocation = CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868)
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: initialLocation, span: span)
        mapView.setRegion(region, animated: true)
        
        mapView.mapType = .mutedStandard

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
        print("Start Pressed!")
    }
}


