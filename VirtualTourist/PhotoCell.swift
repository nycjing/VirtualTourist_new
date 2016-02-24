//
//  PhotoCell.swift
//  VirtualTourist
//
//  Created by Jing Jia on 11/30/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
       @IBOutlet weak var image: UIImageView!
    func fillWithImage(image:UIImage) {
        self.image.image = image
    }
}


