//
//  CoreDataStack.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 18/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
//  Somewhat inspired by: http://pawanpoudel.svbtle.com/fixing-core-data-concurrency-violations
//
import Foundation
import CoreData
/**
 *  Singleton controller to manage the main Core Data stack for the application. It vends a persistent store coordinator, the managed object model, and a URL for the persistent store.
 */
class CoreDataStack: NSObject {
  
  // MARK: - Public Properties
  
  /**
   *  Returns the shared instance of the Core Data Stack.
   */
  static let sharedManager = CoreDataStack()
  /**
   *  Set true before using the store coordinator to remove it and start with a fresh one.
   */
  var shouldResetStoreCoordinator: Bool = false {
    didSet {
      print("Reset store coordinator")
    }
  }
  
  // MARK: - Public Methods
  
  /**
   *  Creates a new private queue context.
   *  - Note: Asynchronous from the UI. Use for background tasks, such as writing to disk.
   */
  func newBackgroundQueueContext() -> NSManagedObjectContext? {
    guard let mainQueueContext = self.mainQueueContext else {
      return nil
    }
    
    let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    context.parentContext = mainQueueContext
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    
    return context
  }
  /**
   *  Returns the main queue context.
   *  - Note: Should be accessed only from the UI.
   */
  func getMainQueueContext() -> NSManagedObjectContext? {
    return self.mainQueueContext
  }
  
  // MARK: - Queue Properties
  
  /**
  *  The main queue context.
  */
  private lazy var mainQueueContext: NSManagedObjectContext? = { [unowned self] in
    guard let parentContext = self.parentContext else {
      return nil
    }
    
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    context.parentContext = parentContext
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    
    return context
  }()
  /**
   *  The parent context.
   *  - Note: The main queue context will use this context as the parent.
   */
  private lazy var parentContext: NSManagedObjectContext? = { [unowned self] in
    guard let coordinator = self.persistentStoreCoordinator else {
      return nil
    }
    
    let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    context.persistentStoreCoordinator = coordinator
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    
    return context
  }()
  
  // MARK: - Setup Methods
  
  /**
   *  Name of the Core Data store.
   */
  private let storeName = Application.name
  /**
   *  Name of the Core Data store file.
   */
  private lazy var storeFileName: String = { [unowned self] in
    return self.storeName + ".sqlite"
  }()
  /**
   *  URL to the Core Data store file.
   */
  private lazy var storeURL: NSURL = {
    let URLs = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return URLs.last!.URLByAppendingPathComponent(self.storeFileName)
  }()
  
  private lazy var managedObjectModel: NSManagedObjectModel = { [unowned self] in
    let URL = NSBundle.mainBundle().URLForResource(self.storeName, withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: URL)!
  }()
  
  private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = { [unowned self] in
    if self.shouldResetStoreCoordinator {
      do {
        try self.removePersistentStoreCoordinator()
      } catch {
        print(error)
      }
      
      self.shouldResetStoreCoordinator = false
    }
    
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    do {
      let options = [
        NSMigratePersistentStoresAutomaticallyOption: true,
        NSInferMappingModelAutomaticallyOption: true
      ]
      
      try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.storeURL, options: options)
    } catch {
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
      
      dict[NSUnderlyingErrorKey] = error as NSError
      let wrappedError = NSError(domain: Application.identifier, code: 9999, userInfo: dict)
      
      NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      NSLog("Deleting it...")
      do {
        try self.removePersistentStoreCoordinator()
      } catch {
        print(error)
      }
      
      return nil
    }
    
    return coordinator
  }()
  
  func removePersistentStoreCoordinator() throws {
    try NSFileManager.defaultManager().removeItemAtURL(self.storeURL)
  }

}
