//
//  PinModel.swift
//  VirtualTourist
//
//  Created by Jing Jia on 1/14/16.
//  Copyright © 2016 Jing Jia. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class PinModel: NSManagedObject {
    
    struct Keys {
        static let Photos = "photos"
    }
    
    @NSManaged var latitude  : CLLocationDegrees
    @NSManaged var longitude : CLLocationDegrees
    @NSManaged var photos    : [PhotoModel]
    
    var coordinate:CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set(value) {
            latitude = value.latitude
            longitude = value.longitude
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(coordinate:CLLocationCoordinate2D, context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("PinModel", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.coordinate = coordinate
    }
    
    func addPhoto(photoModel:PhotoModel) {
        if deleted {
            return
        }
        
        let photos = self.mutableSetValueForKey(Keys.Photos)
        photos.addObject(photoModel)
        photoModel.pin = self
    }
    
    func storePhotosFromArray(array: [[String : AnyObject]], completionHandler: (finished: Bool) -> Void) {
        for photoArray in array {
            let photoModel = PhotoModel(dictionary: photoArray, context: CoreDataStackManager.sharedInstance().managedObjectContext)
            self.addPhoto(photoModel)
        }
        
        CoreDataStackManager.sharedInstance().saveContext()
        
        completionHandler(finished: true)
    }
   
    
    let flickrBOUNDING_BOX_HALF_WIDTH  = 5.0
    let flickrBOUNDING_BOX_HALF_HEIGHT = 5.0
    

        
        func searchedCoordinateString() -> String {
            let coordinate = self.coordinate
            let latitude = coordinate.latitude
            let longitude = coordinate.longitude
            
            return "\(longitude - flickrBOUNDING_BOX_HALF_WIDTH), \(latitude - flickrBOUNDING_BOX_HALF_HEIGHT), \(longitude + flickrBOUNDING_BOX_HALF_WIDTH), \(latitude + flickrBOUNDING_BOX_HALF_HEIGHT)"
        }
        


}
