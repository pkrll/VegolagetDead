//
//  NSManagedObjectContext+saveContext.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 18/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import CoreData

extension NSManagedObjectContext {

  typealias saveContextsHandler = (_ success: Bool, _ error: NSError?) -> Void
  
  func saveContext(_ completionHandler: saveContextsHandler?) {
    self.performAndWait { () -> Void in
      guard self.hasChanges else {
        completionHandler?(true, nil)
        return
      }
      // Attempt saving and then call parent context to save.
      do {
        try self.save()
        self.parent?.saveContext(completionHandler)
      } catch let error as NSError {
        completionHandler?(false, error)
      }
    }
  }

}
