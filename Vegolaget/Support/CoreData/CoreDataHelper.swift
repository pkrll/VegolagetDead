//
//  CoreDataHelper.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 18/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import CoreData

class CoreDataHelper {
  
  // MARK: - Public Type Aliases
  
  internal typealias HelperLoadCompletionHandler = (success: Bool, data: [AnyObject]?, error: NSError?) -> Void
  
  internal typealias HelperSaveCompletionHandler = (success: Bool, error: NSError?) -> Void
  
  // MARK: - Private Properties
  
  /**
   *  The shared instance of the Core Data Stack.
   */
  private lazy var stack: CoreDataStack = {
    return CoreDataStack.sharedManager
  }()

  // MARK: - Public Methods
  
  /**
   *  Save to or update objects.
   *  - Parameters:
   *    - items: An array consisting of the objects to be saved. The items must be a subclass of *CoreDataHelperItem* and have the same attributes as the entity.
   *    - toEntity: The entity of the objects.
   */
  func save(items: [CoreDataHelperItem], toEntity: String) {
    guard let context = self.stack.newBackgroundQueueContext() else {
      return
    }
    print("Saving or updating \(items.count) objects.")
    context.performBlock { () -> Void in
      for item in items {
        var saves = false
        // Attempts to retrieve the item
        var entityItem = self.load(fromEntity: toEntity, inManagedObjectContext: context, itemWithID: (item as! Item).id) as? NSManagedObject
        // Nil means it does not exist, so insert a new one
        if entityItem == nil {
          saves = true
          entityItem = NSEntityDescription.insertNewObjectForEntityForName(toEntity, inManagedObjectContext: context)
        }
        // Retrieves the attributes (properties) of the current item being looped over. The attributes will be compared to the NS Managed Object item's attributes.
        let attributes = item.attributes()
        print("Insert a new object? \(saves) : \(object_getClass(item))")
        for (key, value) in attributes {
          // Ignore attributes not present in the entity. Though, the Core Data Helper Item objects must have a value for all of the entities non-optional attributes.
          if entityItem!.respondsToSelector(Selector(key)) {
            entityItem!.setValue(value, forKey: key)
          }
        }
      }
      
      context.saveContext { (success: Bool, error) -> Void in
        if success {
          print("Saved \(object_getClass(items.first!))")
        } else {
          print(error)
        }

      }
    }
  }
  /**
   *  Fetch items from the Core Data store.
   *  - Parameters:
   *    - fromEntity: The entity to load from.
   *    - withPredicate: A predicate.
   *    - completionHandler: The callback.
   */
  func load(fromEntity entity: String, withPredicate: NSPredicate?, completionHandler: HelperLoadCompletionHandler) {
    guard let context = self.stack.getMainQueueContext() else {
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
      
//      dispatch_async(dispatch_get_main_queue()) {
        print("Loading \(results?.count) objects.")
        completionHandler(success: success, data: results, error: error)
//      }
    }
  }

}
// MARK: - Private Methods
private extension CoreDataHelper {
  /**
   *  Loads a single item.
   *  - Parameters:
   *    - fromEntity: An entity.
   *    - inManagedObjectContext: A managed object context.
   *    - itemWithID: The id of the item.
   *  - Returns: An object of any type.
   */
  func load(fromEntity entity: String, inManagedObjectContext: NSManagedObjectContext, itemWithID id: Int) -> AnyObject? {
    var results = [AnyObject]?()
    let request = NSFetchRequest(entityName: entity)
    let predicate = NSPredicate(format: "id = %i", id)
    request.predicate = predicate
    request.fetchLimit = 1

    do {
      results = try inManagedObjectContext.executeFetchRequest(request)
    } catch  {
      print(error)
    }

    return results?.first
  }

}
