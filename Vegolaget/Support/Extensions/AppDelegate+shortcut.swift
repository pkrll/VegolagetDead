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
  func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    completionHandler(self.handleShortcutAction(shortcutItem.type))
  }
  
  @available(iOS 9.0, *)
  func handleShortcutAction(_ shortcutItemKey: String?) -> Bool {
    guard let shortcutItemKey = shortcutItemKey, let action = AppShortcutType(rawValue: shortcutItemKey) else {
      return false
    }
    
    return self.launchWithAction(action)
  }
  
  @available(iOS 9.0, *)
  fileprivate func launchWithAction(_ shortcutType: AppShortcutType) -> Bool {
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
