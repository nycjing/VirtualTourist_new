//
//  AnnotationModel.swift
//  VirtualTourist
//
//  Created by Jing Jia on 1/14/16.
//  Copyright © 2016 Jing Jia. All rights reserved.
//

import MapKit
import CoreData

class AnnotationModel: NSObject, MKAnnotation {
    var coordinate   : CLLocationCoordinate2D
    var pin          : PinModel? {
        didSet {
            coordinate = pin!.coordinate
        }
    }
    
    init(annotation: PinModel) {
        self.coordinate = annotation.coordinate
        self.pin = annotation
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
