//
//  DataController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import CoreData

typealias CoreDataCompletionHandler = (success: Bool, data: [AnyObject]?, error: NSError?) -> Void

class DataController: NSObject {
    
    private lazy var queue: dispatch_queue_t = {
        return dispatch_queue_create("DataControllerSerialQueue", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0))
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(Constants.Application.name, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named after the bundle identifier in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application, creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(Constants.Application.name + ".sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Deletes the store upon error. Will create a new store when launched again...
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: Constants.Application.identifier, code: 9999, userInfo: dict)

            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            NSLog("Deleting it...")
            
            let fileManager = NSFileManager.defaultManager()
            do {
                try fileManager.removeItemAtURL(url)
            } catch {
                print("\(error)")
            }
            
            return nil
        }
        
        return coordinator
    }()
    
    private lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        var managedObjectContext: NSManagedObjectContext?
        if let coordinator = self.persistentStoreCoordinator {
            managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            managedObjectContext!.persistentStoreCoordinator = coordinator
        }
        
        return managedObjectContext
    }()
    /**
     *  Attempts to commit unsaved changes to registered objects to the receiver’s parent store.
     *  - Parameter completionHandler: Callback function.
     */
    func save(completionHandler: CoreDataCompletionHandler?) {
        // Make sure the managed object context exists
        guard let managedObjectContext = self.managedObjectContext else {
            completionHandler?(success: false, data: nil, error: self.error(.ManagedObjectContext, reason: "Could not save context."))
            return
        }
        
        if managedObjectContext.hasChanges {
            print("Saving context...")
            do {
                try managedObjectContext.save()
                completionHandler?(success: true, data: nil, error: nil)
            } catch {
                completionHandler?(success: false, data: nil, error: error as NSError)
            }
        }
    }
    
    func insertItems(items: [AnyObject], toEntity: String) {
//        dispatch_async(self.queue) {
//            let items = items.filter({ (item: Item) -> Bool in
//                return self.doesObjectExist(item.id, entityName: toEntity)
//            })
//            
//            for item in items {
//            }
//        }
    }
    
    func loadItems(fromEntity entity: String?, withPredicate predicate: NSPredicate?, completionHandler: CoreDataCompletionHandler?) {
        dispatch_async(self.queue) {
            guard let managedObjectContext = self.managedObjectContext, entity = entity else {
                completionHandler?(success: false, data: nil, error: self.error(.ManagedObjectContext, reason: "Could not load data."))
                return
            }
            
            let request = NSFetchRequest(entityName: entity)
            // Filter out unwanted items
            if let predicate = predicate {
                request.predicate = predicate
            }
            
            do {
                if let results = try managedObjectContext.executeFetchRequest(request) as? [NSManagedObject] {
                    // This fixes an issue in iPhone 5 devices (not simulated devices, weirdly) where the method would cause a memory leak.
                    let data = results.map { $0 }
                    completionHandler?(success: true, data: data, error: nil)
                }
            } catch let error as NSError {
                completionHandler?(success: false, data: nil, error: error)
            }
        }
    }
    
    func reset(entity: String, completionHandler: CoreDataCompletionHandler?) {
        dispatch_async(self.queue) {
            guard let managedObjectContext = self.managedObjectContext else {
                completionHandler?(success: false, data: nil, error: self.error(.ManagedObjectContext, reason: "Could not reset."))
                return
            }
            let request = NSFetchRequest(entityName: entity)
            
            do {
                let results = try managedObjectContext.executeFetchRequest(request) as! [NSManagedObject]
                for result in results {
                    managedObjectContext.deleteObject(result)
                }
            } catch let error as NSError {
                completionHandler?(success: false, data: nil, error: error)
            }
            
            self.save(completionHandler)
        }
    }
    
}

// MARK: - Private Methods
private extension DataController {
    
    func doesObjectExist(id: Int, entityName: String) -> Bool {
        guard let managedObjectContext = self.managedObjectContext else {
            return false
        }
        
        let predicate = NSPredicate(format: "id = %i", id)
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        let count = managedObjectContext.countForFetchRequest(fetchRequest, error: nil)
        
        return count > 0
    }
    /**
     *  Returns an error object.
     */
    func error(type: CoreDataError, reason: String) -> NSError {
        var error: NSError
        
        switch type {
            case .ManagedObjectContext:
                error = NSError(
                    domain: Constants.Application.identifier,
                    code: 9999,
                    userInfo: [NSLocalizedDescriptionKey: type.rawValue, NSLocalizedFailureReasonErrorKey: reason ]
                )
        }
        
        return error
    }
    
}

