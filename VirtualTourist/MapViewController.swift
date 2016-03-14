//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Jing Jia on 11/30/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//

import UIKit
import MapKit
import CoreData

let flickrDelta         = 0.3
let flickrPinIdentifier = "pin"

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    var draggedPin: AnnotationModel?
    var settings = SettingModel()
    var rootView: MapView! {
        get {
            if isViewLoaded() && self.view.isKindOfClass(MapView) {
                return self.view as! MapView
            } else {
                return nil
            }
        }
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let mapView = rootView.mapView
        
        if let region = settings.region as MKCoordinateRegion? {
            mapView.setRegion(region, animated: true)
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            let fetchRequest = NSFetchRequest(entityName: "PinModel")
            if let pins = (try? self.sharedContext.executeFetchRequest(fetchRequest)) as? [PinModel] {
                for pin in pins {
                    let annotation = AnnotationModel(annotation: pin);
                    mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let mapView = rootView.mapView
        settings.region = mapView.region
        
        dispatch_async(dispatch_get_main_queue()) {
            mapView.removeAnnotations(mapView.annotations)
        }
    }
    
    @IBAction func onMapTapped(sender: UIGestureRecognizer) {
        
    
        let mapView = rootView.mapView
        let point = sender.locationInView(mapView)
        let coordinate = mapView.convertPoint(point, toCoordinateFromView: rootView.mapView)
        let annotation = AnnotationModel(coordinate: coordinate)
        //let annotation = MKPointAnnotation()
        //annotation.coordinate = coordinate
        
        
     //   ----------------
    //    if gestureRecognizer.state == UIGestureRecognizerState.Ended {
      //      let touchPoint = gestureRecognizer.locationInView(mapView)
       //     let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
      //      let annotation = MKPointAnnotation()
      //      annotation.coordinate = newCoordinates
            
     //       print(newCoordinates)
       //     mapView.addAnnotation(annotation)

        
        
        
    //    -----------------
        
        switch sender.state {
        case .Began:
            draggedPin = annotation
            mapView.addAnnotation(annotation)
            
            break
            
        case .Changed:
            mapView.removeAnnotation(draggedPin!)
            mapView.addAnnotation(annotation)
            draggedPin = annotation
            
            break
            
        case .Ended:
            //save pin to CoreData
            let point = sender.locationInView(mapView)
            let coordinate = mapView.convertPoint(point, toCoordinateFromView: rootView.mapView)
            let annotation = AnnotationModel(coordinate: coordinate)

            mapView.removeAnnotation(draggedPin!)
            mapView.addAnnotation(annotation)
            dispatch_async(dispatch_get_main_queue()) {
                let pin = PinModel(coordinate: coordinate, context: self.sharedContext)
                annotation.pin = pin
            CoreDataStackManager.sharedInstance().saveContext()
            //     CoreDataStackManager.saveManagedObjectContext(self.sharedContext)
                
                //prefetch photos from Flickr
                FlickrClient.sharedInstance().searchPhotoNearPin(pin) {success, error in
                    if nil != error {
                        print(error!.localizedDescription)
                    } else {
                        print("LOADED")
                    }
                }
            }
            
            break
            
        default:
            break
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        //present PhotosViewController
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("PhotosViewController") as! PhotosViewController
        destinationController.selectedPin = view.annotation as! AnnotationModel
        
        
        presentViewController(destinationController , animated: true, completion: nil)

        //dispatch_async(dispatch_get_main_queue()) {
         //   self.navigationController!.pushViewController(destinationController, animated: true)
       // }
    }
    
}





