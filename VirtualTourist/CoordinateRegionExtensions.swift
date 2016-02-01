//
//  CoordinateRegionExtensions.swift
//  VirtualTourist
//
//  Created by Jing Jia on 1/16/16.
//  Copyright © 2016 Jing Jia. All rights reserved.
//

import MapKit

extension MKCoordinateRegion {
    init(dictionary: [String:CLLocationDegrees]) {
        self.center = CLLocationCoordinate2D(latitude: dictionary["latitude"]!, longitude: dictionary["longitude"]!)
        self.span = MKCoordinateSpan(latitudeDelta: dictionary["latitudeDelta"]!, longitudeDelta: dictionary["longitudeDelta"]!)
    }
    
    func dictionary() -> [String:CLLocationDegrees] {
        return [
            "latitude" : self.center.latitude,
            "longitude" : self.center.longitude,
            "latitudeDelta" : self.span.latitudeDelta,
            "longitudeDelta" : self.span.longitudeDelta
        ];
    }
    
}
