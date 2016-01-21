//
//  NSManagedObjectContext+saveContext.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 18/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import CoreData

extension NSManagedObjectContext {

  typealias saveContextsHandler = (success: Bool, error: NSError?) -> Void
  
  func saveContext(completionHandler: saveContextsHandler?) {
    self.performBlockAndWait { () -> Void in
      guard self.hasChanges else {
        completionHandler?(success: true, error: nil)
        return
      }
      // Attempt saving and then call parent context to save.
      do {
        try self.save()
        self.parentContext?.saveContext(completionHandler)
      } catch let error as NSError {
        completionHandler?(success: false, error: error)
      }
    }
  }

}