//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Jing Jia on 1/14/16.
//  Copyright © 2016 Jing Jia. All rights reserved.
//

import UIKit

class FlickrClient: NSObject {
    var session         : NSURLSession
    var downloadTask    : NSURLSessionDataTask?
    var getImageDataTask: NSURLSessionTask?
    
    var methodArguments = [
        "method"        : flickrParameters.methodName,
        "api_key"       : flickrParameters.APIKey,
        "safe_search"   : flickrParameters.safeSearch,
        "extras"        : flickrParameters.extras,
        "format"        : flickrParameters.dataFormat,
        "nojsoncallback": flickrParameters.noJSONCallback,
        "per_page"      : "40"
    ]
    
    typealias CompletionHander = (result: AnyObject!, error: NSError?) -> Void
    
    override init() {
        session = NSURLSession.sharedSession()
        downloadTask = NSURLSessionDataTask()
        
        super.init()
    }
    
    // MARK: - Shared Instance
    class func sharedInstance() -> FlickrClient {
        
        struct singleton {
            static var sharedInstance = FlickrClient()
        }
        
        return singleton.sharedInstance
    }
    
    // MARK: - Shared Image Cache
    struct Caches {
        static let imageCache = ImageCache()
    }
    
    // MARK: - Helpers
    
    class func errorForMessage(message: String) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey : message]
        
        return NSError(domain: "Flickr Error", code: 1, userInfo: userInfo)
    }
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: CompletionHander) {
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
        }
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    func escapedParameters(parameters: [String:AnyObject]) -> String {
        var urlVars = [String]()
        
        for (key, value) in parameters {
            let stringValue = "\(value)"
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    // MARK: - All purpose tasks
    
    func task(request: NSURLRequest, completionHandler: (result: NSData!, error: NSError?) -> Void) -> NSURLSessionDataTask
    {
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                completionHandler(result: nil, error: error)
            } else {
                completionHandler(result: data, error: nil)
            }
        }
        
        task.resume()
        
        return task
    }
    
    func taskForImage(request: NSURLRequest, completionHandler: (imageData: NSData?, error: NSError?) ->  Void) -> NSURLSessionTask
    {
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                completionHandler(imageData: nil, error: error)
            } else {
                completionHandler(imageData: data, error: nil)
            }
        }
        
        task.resume()
        
        return task
    }
}


extension FlickrClient {
    struct flickrParameters {
        static let baseURL        = "https://api.flickr.com/services/rest/"
        static let methodName     = "flickr.photos.search"
        static let APIKey         = "2a3ad6f0c32a6a984c67d0a68a30c3b8"
        static let extras         = "url_m"
        static let dataFormat     = "json"
        static let safeSearch     = "1"
        static let noJSONCallback = "1"
    }
    
    struct flickrKeys {
        static let photo  = "photo"
        static let photos = "photos"
    }
    
}



struct Constants {
    // MARK: API Key
    static let ApiKey : String = "2a3ad6f0c32a6a984c67d0a68a30c3b8"
    static let ApiSecret : String = "a2fb8f411ad316e5"
    
    // MARK: URLs
    static let BaseURLSecure : String = "https://api.flickr.com/services/rest/"
    static let BaseURLImage : String = "https://farm"
}

// MARK: - Methods
struct Methods {
    static let Api_Key = "api_key"
    static let Accuracy = "11"
    static let Nojsoncallback = "nojsoncallback"
    static let FlickrMethod = "flickr.photos.search"
    static let Format = "json"
    static let PhotoLimit = "21"
    
}





