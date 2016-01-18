//
//  CoreDataStack.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 18/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
//  Somewhat inspired by: https://developer.apple.com/library/mac/samplecode/Earthquakes/Listings/Swift_Earthquakes_CoreDataStackManager_swift.html
//
import Foundation
import CoreData
/**
 *  Singleton controller to manage the main Core Data stack for the application. It vends a persistent store coordinator, the managed object model, and a URL for the persistent store.
 */
class CoreDataStack: NSObject {
  /**
   *  Returns the shared core data stack manager object for the process.
   */
  static let sharedManager = CoreDataStack()
  
  private let storeName = Constants.Application.name
  
  // MARK: - Public methods
  
  func newPrivateQueueContext() -> NSManagedObjectContext? {
    guard let mainQueueContext = self.mainQueueContext else {
      return nil
    }
    
    let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    context.parentContext = mainQueueContext
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    
    return context
  }
  
  func getMainQueueContext() -> NSManagedObjectContext? {
    return self.mainQueueContext
  }
  
  // MARK: - Queue Properties
  
  private lazy var mainQueueContext: NSManagedObjectContext? = { [unowned self] in
    guard let parentContext = self.parentContext else {
      return nil
    }
    
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    context.parentContext = parentContext
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    
    return context
  }()
  
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
  
  private lazy var storeFileName: String = { [unowned self] in
    return self.storeName + ".sqlite"
  }()
  
  private lazy var storeURL: NSURL = {
    let URLs = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return URLs.last!.URLByAppendingPathComponent(self.storeFileName)
  }()
  
  private lazy var managedObjectModel: NSManagedObjectModel = { [unowned self] in
    let URL = NSBundle.mainBundle().URLForResource(self.storeName, withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: URL)!
  }()
  
  private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = { [unowned self] in
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    do {
      let options = [
        NSMigratePersistentStoresAutomaticallyOption: true,
        NSInferMappingModelAutomaticallyOption: true
      ]
      
      try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.storeURL, options: options)
    } catch {
      // Deletes the store upon error. Will create a new store when launched again.
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
      
      dict[NSUnderlyingErrorKey] = error as NSError
      let wrappedError = NSError(domain: Constants.Application.identifier, code: 9999, userInfo: dict)
      
      NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      NSLog("Deleting it...")
      do {
        try NSFileManager.defaultManager().removeItemAtURL(self.storeURL)
      } catch {
        print(error)
      }
      
      return nil
    }
    
    return coordinator
  }()

}