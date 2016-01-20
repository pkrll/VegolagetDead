//
//  NSManagedObjectContext+saveContext.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 18/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import CoreData

typealias saveContextsHandler = (success: Bool, error: NSError?) -> Void

extension NSManagedObjectContext {
  
  func saveContext(completionHandler: saveContextsHandler?) {
    self.performBlockAndWait { () -> Void in
      // Attempt saving and then call parent context to save.
      if self.hasChanges {
        do {
          try self.save()
          self.parentContext?.saveContext(completionHandler)
        } catch let error as NSError {
          print(error)
          completionHandler?(success: false, error: error)
        }
      } else {
        completionHandler?(success: true, error: nil)
      }
      
    }
  }
  
}