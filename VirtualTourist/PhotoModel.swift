//
//  PhotoModel.swift
//  VirtualTourist
//
//  Created by Jing Jia on 1/14/16.
//  Copyright © 2016 Jing Jia. All rights reserved.
//

import CoreData
import UIKit

class PhotoModel: NSManagedObject {
    
    struct Keys {
        static let Title = "title"
        static let URL   = "url_m"
    }
    
    @NSManaged var pin       : PinModel
    @NSManaged var title     : String
    @NSManaged var url       : String
    @NSManaged var identifier: String
    
    var image: UIImage? {
        get {
            return FlickrClient.Caches.imageCache.imageWithIdentifier(identifier)
        }
        
        set {
            FlickrClient.Caches.imageCache.storeImage(newValue, withIdentifier: identifier)
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        // Core Data
        let entity =  NSEntityDescription.entityForName("PhotoModel", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        identifier = NSUUID().UUIDString
        url = dictionary[Keys.URL] as! String
        title = dictionary[Keys.Title] as! String
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
        
        FlickrClient.Caches.imageCache.storeImage(nil, withIdentifier: identifier)
    }
    
}
