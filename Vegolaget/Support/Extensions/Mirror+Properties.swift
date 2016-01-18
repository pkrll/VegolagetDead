//
//  Mirror+Properties.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 18/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

extension Mirror {
  /**
   *  Returns all properties with their values of an object (along with properties defiend in its super classes).
   *  - Returns: A dictionary consisting of properties and their values.
   */
  func properties() -> [String: AnyObject] {
    var properties = [String: AnyObject]()
    
    for property in self.children {
      if let name = property.label {
        properties[name] = property.value as? AnyObject
      }
    }
    // Get the parent attributes too
    if let superClass = self.superclassMirror() {
      for (name, value) in superClass.properties() {
        properties[name] = value
      }
    }
    
    return properties
  }
  
}