//
//  TempModel.swift
//  Runnr
//
//  Created by SDC-USER on 09/12/25.
//

import Foundation
import CoreLocation

struct TempModel {
    var distance: CGFloat
    var time: String
    var routeCoordinates: [CLLocationCoordinate2D]
}

var activity: [TempModel] = []
