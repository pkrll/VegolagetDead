//
//  AppDelegate.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 11/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var coreDataHelper = CoreDataHelper()

  func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    self.checkApplicationSettings()
    
    if #available(iOS 9.0, *) {
      let key = launchOptions?.filter { $0.0 == UIApplicationLaunchOptionsKey.shortcutItem }.first?.1 as? String
      return self.handleShortcutAction(key)
    }
    
    return true
  }

}
