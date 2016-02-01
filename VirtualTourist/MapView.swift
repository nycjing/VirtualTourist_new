//
//  MapView.swift
//  VirtualTourist
//
//  Created by Jing Jia on 1/14/16.
//  Copyright © 2016 Jing Jia. All rights reserved.
//


import UIKit
import MapKit

class MapView: UIView {
    
    
    @IBOutlet var mapView: MKMapView!
    
    var loadingViewShown : Bool = false
    var loadingView      : LoadingView!
    
    func showLoadingView() {
        showLoadingViewInView(self)
    }
    
    func showLoadingViewInView(view: UIView) {
        if !loadingViewShown {
            loadingView = LoadingView.loadingView(view)
            loadingViewShown = true
        }
    }
    
    func hideLoadingView() {
        if loadingViewShown {
            loadingView.hide()
            loadingView = nil
            loadingViewShown = false
        }
    }
    
}
