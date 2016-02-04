//
//  Settings.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 04/02/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

struct Settings {
  
  static func valueForKey(key: String) -> AnyObject? {
    return NSUserDefaults.standardUserDefaults().valueForKey(key)
  }
  
  static func set(Value value: AnyObject, forKey key: String) {
    NSUserDefaults.standardUserDefaults().setValue(value, forKey: key)
  }
  
}