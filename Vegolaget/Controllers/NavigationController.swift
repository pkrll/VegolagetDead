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
    self.navigationBar.barTintColor = UIColor.whiteColor()
    self.navigationBar.tintColor = UserInterface.greenColor
    self.navigationBar.titleTextAttributes = [
      NSForegroundColorAttributeName: UserInterface.greenColor,
      NSFontAttributeName: Font.Roboto.withStyle(.Regular, size: 18.0)!
    ]
    self.navigationBar.backIndicatorImage = UIImage(named: "arrow")
    self.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arrow")
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.Default
  }
  
}
