//
//  CoreDataHelperItem.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 18/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
/**
 *  Items to be used in the Core Data Helper must subclass this class.
 */
class CoreDataHelperItem: NSObject {
  /**
   *  Returns all properties of the class (including super classes).
   *  - Note: Core Data Helper will use these in place for the attributes' names for the core data model.
   */
  func attributes() -> [String: AnyObject] {
    return Mirror(reflecting: self).properties()
  }

}