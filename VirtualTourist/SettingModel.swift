//
//  SettingModel.swift
//  VirtualTourist
//
//  Created by Jing Jia on 1/14/16.
//  Copyright © 2016 Jing Jia. All rights reserved.
//

import MapKit

class SettingModel: NSObject {
    var defaults : NSUserDefaults
    var region   : MKCoordinateRegion! {
        get {
            if let regionDict = defaults.objectForKey("region") as? [String:CLLocationDegrees] {
                return MKCoordinateRegion(dictionary:regionDict)
            } else {
                return nil
            }
        }
        
        set {
            if let region = newValue as MKCoordinateRegion? {
                self.setValue(region.dictionary(), forKey: "region")
            }
        }
    }
    
    deinit {
        self.defaults.synchronize()
    }
    
    override init() {
        self.defaults = NSUserDefaults.standardUserDefaults()
        
        super.init()
    }
    
    override func setNilValueForKey(key: String) {
        synchronized(self, closure: {
            self.defaults.removeObjectForKey(key)
            self.defaults.synchronize()
        })
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        synchronized(self, closure: {
            self.defaults.setValue(value, forKey: key)
            self.defaults.synchronize()
        })
    }
    
    func synchronized(lock: AnyObject, closure:() -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
}
