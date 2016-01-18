//
//  LoadingView.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
/**
 *  This view will indicate for the user when a process is loading.
 */
class LoadingView: UIView {
  
  var spinner: UIActivityIndicatorView?
  var label: UILabel?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func startProgress() {
    self.backgroundColor = UIColor.blackColor()
    self.alpha = 0.75
    
    let bounds = self.bounds
    let autoresizingMask: UIViewAutoresizing = [
      .FlexibleRightMargin,
      .FlexibleLeftMargin,
      .FlexibleBottomMargin,
      .FlexibleTopMargin
    ]
    
    let labelHeight: Double = 22.0
    let labelWidth: Double = Double(bounds.width - 22.0)
    let centerX: Double = Double(bounds.width / 2)
    let centerY: Double = Double(bounds.height / 2)
    
    self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    self.spinner!.frame = CGRect(
      x: centerX - Double(self.spinner!.frame.width / 2),
      y: centerY - Double(self.spinner!.frame.height - 20),
      width: Double(self.spinner!.frame.width),
      height: Double(self.spinner!.frame.height)
    )
    self.spinner?.autoresizingMask = autoresizingMask
    self.addSubview(self.spinner!)
    self.spinner?.startAnimating()
    
    self.label = UILabel(
      frame: CGRect(x:
        centerX - (labelWidth / 2),
        y: centerY + 20,
        width: labelWidth,
        height: labelHeight
      )
    )
    self.label?.backgroundColor = UIColor.clearColor()
    self.label?.textColor = UIColor.whiteColor()
    self.label?.text = "Laddar..."
    self.label?.textAlignment = NSTextAlignment.Center
    self.label?.autoresizingMask = autoresizingMask
    self.addSubview(self.label!)
  }
  
  func stopProgress() {
    if self.superview != nil {
      self.removeFromSuperview()
    }
  }
  
}
