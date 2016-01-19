//
//  NavigationController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class NavigationController: UINavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationBar.barTintColor = Constants.UserInterface.greenColor
    self.navigationBar.tintColor = UIColor.whiteColor()
    self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
}
