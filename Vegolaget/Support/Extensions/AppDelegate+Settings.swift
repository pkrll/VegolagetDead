//
//  AppDelegate+Settings.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 03/02/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

extension AppDelegate {

  func checkApplicationSettings() {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    if self.shouldResetData(defaults) {
      self.coreDataHelper.reset()
      defaults.setBool(false, forKey: "resetData")
    }
  }
  
  private func shouldResetData(defaults: NSUserDefaults) -> Bool {
    return defaults.boolForKey("resetData")
  }
  
}
