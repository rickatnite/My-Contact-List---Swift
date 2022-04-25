//
//  MapPoint.swift
//  My Contact List
//
//  Created by E Roche on 4/25/22.
//

import Foundation
import MapKit

class MapPoint: NSObject, MKAnnotation {
    //MKAnnotation protocol specifies three properties used to describe the annotation - title, subtitle, and coordinate
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D { //read-only
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude) //handles the coordinate conversion to get annotation
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

