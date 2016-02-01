//
//  LoadingView.swift
//  VirtualTourist
//
//  Created by Jing Jia on 1/14/16.
//  Copyright © 2016 Jing Jia. All rights reserved.
//


import UIKit

class LoadingView: UIView {
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    weak var rootView: UIView!
    
    class func loadingView (rootView: UIView) -> LoadingView {
        let loadingView = NSBundle.mainBundle().loadNibNamed("LoadingView", owner: self, options: nil).first as! LoadingView
        
        loadingView.show(rootView)
        
        return loadingView
    }
    
    func show(rootView: UIView) {
        var frame = rootView.frame as CGRect
        frame.origin = CGPointZero;
        self.frame = frame;
        
        rootView.addSubview(self)
        
        self.rootView = rootView
        
        self.spinner.startAnimating();
    }
    
    func hide() {
        if isDescendantOfView(rootView) {
            self.spinner.stopAnimating()
            self.removeFromSuperview()
        }
    }
}
