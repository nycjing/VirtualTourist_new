//
//  FlickrClientExtensions.swift
//  VirtualTourist
//
//  Created by Jing Jia on 1/14/16.
//  Copyright © 2016 Jing Jia. All rights reserved.
//

import Foundation

extension FlickrClient {
    
    func searchPhotoNearPin(pin: PinModel, completionHandler:(success: Bool, error: NSError?) -> Void) {
        methodArguments["bbox"] = pin.searchedCoordinateString()
        
        let urlString = flickrParameters.baseURL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        downloadTask = self.task(request){data, error in
            if nil != error {
                completionHandler(success: false, error: error)
            } else {
                FlickrClient.parseJSONWithCompletionHandler(data) {result, error in
                    if nil != error {
                        completionHandler(success: false, error: error)
                    } else {
                        if let photosDictionary = result.valueForKey(flickrKeys.photos) as? NSDictionary {
                            if let pageCount = photosDictionary["pages"] as? Int {
                                var totalPhotosVal = 0
                                if let totalPhotos = photosDictionary["total"] as? String {
                                    totalPhotosVal = (totalPhotos as NSString).integerValue
                                }
                                
                                if totalPhotosVal > 0 {
                                    var pageMax:Int = 400 / Int((self.methodArguments["per_page"])!)!
                                    pageMax = min(pageCount, pageMax)
                                    let randomPage = Int(arc4random_uniform(UInt32(pageMax))) + 1
                                    self.searchPhotosWithPageNumber(randomPage) {images, error in
                                        if nil != error {
                                            completionHandler(success: false, error: error!)
                                        } else {
                                            print(randomPage)
                                            pin.storePhotosFromArray(images!) {finished in
                                                if finished {
                                                    completionHandler(success: true, error: nil)
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                let contentError = FlickrClient.errorForMessage("Can't find key 'photo' in \(photosDictionary)")
                                completionHandler(success: false, error: contentError)
                            }
                        } else {
                            let contentError = FlickrClient.errorForMessage("Can't find key 'photos' in \(result)")
                            completionHandler(success: false, error: contentError)
                        }
                    }
                }
            }
        }
    }
    
    func searchPhotosWithPageNumber(pageNumber: Int, completionHandler:(images: [[String: AnyObject]]?, error: NSError?) -> Void)
    {
        methodArguments["page"] = "\(pageNumber)"
        let urlString = flickrParameters.baseURL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        downloadTask = self.task(request){data, error in
            if nil != error {
                completionHandler(images: nil, error: error)
            } else {
                FlickrClient.parseJSONWithCompletionHandler(data) {result, error in
                    if nil != error {
                        completionHandler(images: nil, error: error)
                    } else {
                        if let photosDictionary = result.valueForKey(flickrKeys.photos) as? NSDictionary {
                            if let photoArray = photosDictionary.valueForKey(flickrKeys.photo) as? [[String: AnyObject]] {
//                                print(photoArray)
  //                              print(pageNumber)
                                completionHandler(images: photoArray, error: nil)
                            } else {
                                completionHandler(images: nil, error: FlickrClient.errorForMessage("Cannot parse JSON"))
                            }
                        } else {
                            completionHandler(images: nil, error: FlickrClient.errorForMessage("Cannot parse JSON"))
                        }
                    }
                }
            }
        }
    }
    
    func imageDataForPhotoModel(photoModel: PhotoModel, completionHandler:(imageData: NSData?, error: NSError?) -> Void) {
        if let url = NSURL(string: photoModel.url) as NSURL! {
            let request = NSURLRequest(URL: url)
            getImageDataTask = self.taskForImage(request) {result, error in
                if nil == error {
                    completionHandler(imageData: result, error: nil)
                } else {
                    completionHandler(imageData: nil, error: error)
                }
            }
        } else {
            let noURLError = "There is no URL for image"
            completionHandler(imageData: nil, error: FlickrClient.errorForMessage(noURLError))
        }
    }
    
    func cancel() {
        if nil != downloadTask {
            downloadTask!.cancel()
        }
    }
}