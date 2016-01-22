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

  func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    if #available(iOS 9.0, *) {
      let key = launchOptions?.filter { $0.0 == UIApplicationLaunchOptionsShortcutItemKey }.first?.1 as? String
      return self.handleShortcutAction(key)
    }
    
    return true
  }

}