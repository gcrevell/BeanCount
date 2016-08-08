//
//  Location.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/8/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {
    let latitude: Double
    let longitude: Double
    let name: String
    let UID: String
    let city: String
    let state: String
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
