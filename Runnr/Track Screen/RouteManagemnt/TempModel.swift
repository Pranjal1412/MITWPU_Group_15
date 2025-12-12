//
//  TempModel.swift
//  Runnr
//
//  Created by SDC-USER on 09/12/25.
//

import Foundation
import CoreLocation
import GoogleMaps

struct TempModel {
    var distance: CGFloat
    var time: String
    var routeCoordinates: GMSMutablePath
    var activityStarted: Bool
}

var activity: [TempModel] = []
