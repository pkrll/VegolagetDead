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
  
  internal typealias HelperLoadCompletionHandler = (_ success: Bool, _ data: [AnyObject]?, _ error: NSError?) -> Void
  
  internal typealias HelperSaveCompletionHandler = (_ success: Bool, _ error: NSError?) -> Void
  
  // MARK: - Private Properties
  
  /**
   *  The shared instance of the Core Data Stack.
   */
  fileprivate lazy var stack: CoreDataStack = {
    return CoreDataStack.sharedManager
  }()

  // MARK: - Public Methods
  
  /**
   *  Save to or update objects.
   *  - Parameters:
   *    - items: An array consisting of the objects to be saved. The items must be a subclass of *CoreDataHelperItem* and have the same attributes as the entity.
   *    - toEntity: The entity of the objects.
   */
  func save(_ items: [CoreDataHelperItem], toEntity: String) {
    guard let context = self.stack.newBackgroundQueueContext() else {
      return
    }
    print("Saving or updating \(items.count) objects.")
    context.perform { () -> Void in
      for item in items {
        // Attempts to retrieve the item
        var entityItem = self.load(fromEntity: toEntity, inManagedObjectContext: context, itemWithID: (item as! Item).id) as? NSManagedObject
        // Nil means it does not exist, so insert a new one
        if entityItem == nil {
          entityItem = NSEntityDescription.insertNewObject(forEntityName: toEntity, into: context)
        }
        // Retrieves the attributes (properties) of the current item being looped over. The attributes will be compared to the NS Managed Object item's attributes.
        let attributes = item.attributes()
        for (key, value) in attributes {
          // Ignore attributes not present in the entity. Though, the Core Data Helper Item objects must have a value for all of the entities non-optional attributes.
          if entityItem!.responds(to: Selector(key)) {
            entityItem!.setValue(value, forKey: key)
          }
        }
      }
      // TODO: - DOES NOT SAVE UPDATED/CHANGED OBJECTS.
      context.saveContext { (success: Bool, error) -> Void in
        if success {
          if let item = items.first {
            print("Saved \(object_getClass(item))")
          } else {
            print("Saved \(items)")
          }
        } else {
          print(error ?? "Error")
        }

      }
    }
  }
  /**
   *  Fetch items from the Core Data store.
   *  - Parameters:
   *    - fromEntity: The entity to load from.
   *    - withPredicate: A predicate.
   *    - sortByKeys: The sort keys.
   *    - completionHandler: The callback.
   */
  func load(fromEntity entity: String, withPredicate: NSPredicate?, sortByKeys: [String]?, completionHandler: @escaping HelperLoadCompletionHandler) {
    guard let context = self.stack.getMainQueueContext() else {
      completionHandler(false, nil, nil)
      return
    }
    
    context.perform { () -> Void in
      var error: NSError?
      var results = [NSManagedObject].init()
      var success = false
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
      // Filter out unwanted items
      if let predicate = withPredicate {
        request.predicate = predicate
      }

      if let sortByKey = sortByKeys {
        var sortDescriptors: [NSSortDescriptor]? = []
        
        for key in sortByKey {
          let descriptor = NSSortDescriptor(key: key, ascending: true)
          sortDescriptors?.append(descriptor)
        }
        
        request.sortDescriptors = sortDescriptors
      }
      
      do {
        results = try context.fetch(request) as! [NSManagedObject]
        success = true
      } catch let loadError as NSError {
        error = loadError
      }
      
      print("Loading \(results.count) objects.")
      completionHandler(success, results, error)
    }
  }

  func reset() {
    self.stack.shouldResetStoreCoordinator = true
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
    var results = [AnyObject].init()
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    let predicate = NSPredicate(format: "id = %i", id)
    request.predicate = predicate
    request.fetchLimit = 1

    do {
      results = try inManagedObjectContext.fetch(request)
    } catch  {
      print(error)
    }

    return results.first
  }

}
