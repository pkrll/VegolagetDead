//
//  NSObject+isOfClassType.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 17/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
extension NSObject {
  /**
   *  Check if the object is of the same class type as specified.
   */
  func isOfClassType<ClassType>(_ type: ClassType.Type) -> Bool {
    if self is ClassType {
      return true
    }
    
    return false
  }
  
}
