//
//  AppDelegate+shortcut.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 22/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

extension AppDelegate {
  
  @available(iOS 9.0, *)
  func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
    completionHandler(self.handleShortcutAction(shortcutItem.type))
  }
  
  @available(iOS 9.0, *)
  func handleShortcutAction(shortcutItemKey: String?) -> Bool {
    guard let shortcutItemKey = shortcutItemKey, let action = ApplicationShortcutType(rawValue: shortcutItemKey) else {
      return false
    }
    
    return self.launchWithAction(action)
  }
  
  func launchWithAction(shortcutType: ApplicationShortcutType) -> Bool {
    guard let tabBarController = self.window?.rootViewController as? UITabBarController else {
      return false
    }
    
    var index = 0
    
    switch shortcutType {
      case .Nearby:
        index = 2
      case .Search:
        index = 1
    }

    tabBarController.selectedIndex = index

    return true
  }
  
}