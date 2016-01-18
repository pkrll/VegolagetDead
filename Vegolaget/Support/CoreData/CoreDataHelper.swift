//
//  CoreDataHelper.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 18/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import CoreData

typealias HelperLoadCompletionHandler = (success: Bool, data: [AnyObject]?, error: NSError?) -> Void
typealias HelperSaveCompletionHandler = (success: Bool, error: NSError?) -> Void

class CoreDataHelper {
  
  private lazy var manager: CoreDataStack = {
    return CoreDataStack.sharedManager
  }()

  func save(items: [CoreDataHelperItem], toEntity: String) {
    guard let context = self.manager.newPrivateQueueContext() else {
      return
    }
    
    for item in items {
      let attributes = item.attributes()
      var entityItem = self.load(toEntity, itemWithID: (item as! Item).id) as? NSManagedObject
      // Nil means it does not exist, so insert a new one
      if entityItem == nil {
        entityItem = NSEntityDescription.insertNewObjectForEntityForName(toEntity, inManagedObjectContext: context)
      }
      // Set the entity object's values depending on the Core Data Helper Item's properties.
      for (key, value) in attributes {
        if entityItem!.respondsToSelector(Selector(key)) {
          entityItem!.setValue(value, forKey: key)
        }
      }
    }
    
    context.saveContexts { (success, error) -> Void in
      print(success)
      print(error)
    }
  }
  
  func load(fromEntity entity: String, withPredicate: NSPredicate?, completionHandler: HelperLoadCompletionHandler) {
    guard let context = self.manager.getMainQueueContext() else {
      completionHandler(success: false, data: nil, error: nil)
      return
    }
    
    context.performBlock { () -> Void in
      var error: NSError?
      var results = [NSManagedObject]?()
      var success = false
      let request = NSFetchRequest(entityName: entity)
      // Filter out unwanted items
      if let predicate = withPredicate {
        request.predicate = predicate
      }
      
      do {
        results = try context.executeFetchRequest(request) as? [NSManagedObject]
        success = true
      } catch let loadError as NSError {
        error = loadError
      }
      
      dispatch_async(dispatch_get_main_queue()) {
        completionHandler(success: success, data: results, error: error)
      }
    }
  }

}

private extension CoreDataHelper {
  
  func load(fromEntity: String, itemWithID: Int) -> AnyObject? {
    guard let context = self.manager.getMainQueueContext() else {
      return nil
    }
    var results = [AnyObject]?()
    let request = NSFetchRequest(entityName: fromEntity)
    let predicate = NSPredicate(format: "id = %i", itemWithID)
    request.predicate = predicate
    request.fetchLimit = 1
    
    do {
      results = try context.executeFetchRequest(request)
    } catch  {
      print(error)
    }
    
    return results?.first
  }
  
}
