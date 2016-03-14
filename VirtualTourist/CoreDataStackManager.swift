//
//  CoreDataStackManager.swift
//  FavoriteActors
//
//  Created by Jason on 3/10/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import CoreData

/**
 * The CoreDataStackManager contains the code that was previously living in the 
 * AppDelegate in Lesson 3. Apple puts the code in the AppDelegate in many of their
 * Xcode templates. But they put it in a convenience class like this in sample code
 * like the "Earthquakes" project.
 *
 */

private let SQLITE_FILE_NAME = "VirtualTourist.sqlite"

class CoreDataStackManager {
    
    
    // MARK: - Shared Instance
    
    /**
     *  This class variable provides an easy way to get access
     *  to a shared instance of the CoreDataStackManager class.
     */
    class func sharedInstance() -> CoreDataStackManager {
        struct Static {
            static let instance = CoreDataStackManager()
        }
    
        return Static.instance
    }
    
    // MARK: - The Core Data stack. The code has been moved, unaltered, from the AppDelegate.
    
    lazy var applicationDocumentsDirectory: NSURL = {
        
        print("Instantiating the applicationDocumentsDirectory property")
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.

        print("Instantiating the managedObjectModel property")
        
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    /**
     * The Persistent Store Coordinator is an object that the Context uses to interact with the underlying file system. Usually
     * the persistent store coordinator object uses an SQLite database file to 
    
    the managed objects. But it is possible to
     * configure it to use XML or other formats. 
     *
     * Typically you will construct your persistent store manager exactly like this. It needs two pieces of information in order
     * to be set up:
     *
     * - The path to the sqlite file that will be used. Usually in the documents directory
     * - A configured Managed Object Model. See the next property for details.
     */
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        
        print("Instantiating the persistentStoreCoordinator property")
        
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(SQLITE_FILE_NAME)
        
        print("sqlite path: \(url.path!)")
        
        var error: NSError? = nil
         var failureReason = "There was an error creating or loading the application's saved data."

        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {

      //  } catch var error1 as NSError {
        //    error = error1
          //  coordinator = nil
            // Report any error we got.
           // let dict = NSMutableDictionary()
         //   dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
          //  dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
         //   dict[NSUnderlyingErrorKey] = error
          //  error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            
      //   error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as? [NSObject : AnyObject])
            
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()

        }
        
        return coordinator
        }()
    
   // lazy var managedObjectContext: NSManagedObjectContext? = {
        
       // print("Instantiating the managedObjectContext property")
        
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        //let coordinator = self.persistentStoreCoordinator
      //  if coordinator == nil {
    //        return nil
        //}
      //  var managedObjectContext = NSManagedObjectContext(concurrencyType:.MainQueueConcurrencyType)
     //   managedObjectContext.persistentStoreCoordinator = coordinator
      //  return managedObjectContext
    //    }()
    //
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    class func saveManagedObjectContext(managedObjectContext:NSManagedObjectContext)->Bool{
        do {
            try managedObjectContext.save()
            return true
        } catch _ {
            return false
        }
    }
    
    func saveContext() {
     //   print("context has changes to save: \(managedObjectContext.hasChanges)")
        dispatch_async(dispatch_get_main_queue()){
      if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
       }
        }
    }
    
    func delete(object:PhotoModel) {
        self.managedObjectContext.deleteObject(object)
    }
}