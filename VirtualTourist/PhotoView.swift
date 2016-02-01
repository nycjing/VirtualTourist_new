//
//  PhotoView.swift
//  VirtualTourist
//
//  Created by Jing Jia on 1/14/16.
//  Copyright © 2016 Jing Jia. All rights reserved.
//

import MapKit
import UIKit

let kVTCellsPerRow = 3.0;

class PhotosView: OTMView {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var photosCollectionView: UICollectionView!
    @IBOutlet var newCollectionButton: UIButton!
    @IBOutlet var noImagesLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let flowLayout = photosCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let availableWidthForCells = CGRectGetWidth(photosCollectionView.frame) - (flowLayout.sectionInset.left + flowLayout.sectionInset.right) - flowLayout.minimumInteritemSpacing * 2
        let cellWidth = availableWidthForCells / 3;
        
        flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth)
    }
    
    func showNoImagesLabel(needHide: Bool) {
        noImagesLabel.hidden = needHide
    }
    
}
