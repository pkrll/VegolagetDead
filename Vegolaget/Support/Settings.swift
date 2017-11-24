//
//  Settings.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 04/02/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

struct Settings {
  
  static func valueForKey(_ key: String) -> AnyObject? {
    return UserDefaults.standard.value(forKey: key) as AnyObject
  }
  
  static func set(Value value: AnyObject, forKey key: String) {
    UserDefaults.standard.setValue(value, forKey: key)
  }
  
}
