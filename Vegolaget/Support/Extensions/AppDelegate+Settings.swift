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
    let defaults = UserDefaults.standard
    
    if defaults.bool(forKey: "resetData") {
      self.coreDataHelper.reset()
      defaults.set(false, forKey: "resetData")
      defaults.setValue(nil, forKey: "lastUpdate")
    }
  }
  
}
