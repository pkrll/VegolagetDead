//
//  UIColor+drawImage.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

extension UIColor{
  
  var drawImage: UIImage {
    let rect = CGRect(x: 0,y: 0,width: 1,height: 1)
    UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
    self.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
  
}
