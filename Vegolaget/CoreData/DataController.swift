//
//  DataController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
/*import Foundation
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
            } catch let error as NSError {
                completionHandler?(success: false, data: nil, error: error as NSError)
            }
        }
    }
    
    func insertAndUpdateItems(items: [AnyObject], inEntity entity: String) {

            let newItems = items.filter {
                return self.doesObjectExist(($0 as! Item).id, entityName: entity) == false
            }
            // Already added items should be updated.
            let oldItems = items.filter {
                return self.doesObjectExist(($0 as! Item).id, entityName: entity) == true
            }
            print("Inserting \(newItems.count) objects")
            print("Updating \(oldItems.count) objects")
            
            if newItems.count > 0 {
                for item in newItems {
                    self.insertItem(item, toEntity: entity)
                }
            }
            
            if oldItems.count > 0 {
                for item in oldItems {
                    self.updateItem(item, inEntity: entity)
                }
            }
        dispatch_async(self.queue) {
            self.save(nil)
        }
    }
    
    func insertItems(items: [AnyObject], toEntity: String) {
        dispatch_async(self.queue) {
            let items = items.filter {
                self.doesObjectExist(($0 as! Item).id, entityName: toEntity) == false
            }
            
            print("Saving \(items.count) objects")
            
            if items.count > 0 {
                for item in items {
                    self.insertItem(item, toEntity: toEntity)
                }
                
                self.save(nil)
            }
        }
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

private extension DataController {
    
    
    
    
    func updateItem(item: AnyObject, inEntity entity: String) {
        if let object = self.fetchObjectWithId(item.id, inEntity: entity) as? ItemManagedObject, let item = item as? Item {
            object.id = item.id
            object.name = item.name
            
            if object.isOfClassType(StoreManagedObject.self) && item.isOfClassType(Store.self) {
                (object as! StoreManagedObject).address = (item as! Store).address
                (object as! StoreManagedObject).postalCode = (item as! Store).postalCode
                (object as! StoreManagedObject).city = (item as! Store).city
                (object as! StoreManagedObject).county = (item as! Store).county
                (object as! StoreManagedObject).phone = (item as! Store).phone
                (object as! StoreManagedObject).openHours = (item as! Store).rawOpenHours
            } else if object.isOfClassType(LocationManagedObject.self) && item.isOfClassType(Location.self) {
                (object as! LocationManagedObject).locationID = (item as! Location).locationID
                (object as! LocationManagedObject).storeID = (item as! Location).storeID
                (object as! LocationManagedObject).city = (item as! Location).city
            } else if object.isOfClassType(ProductManagedObject) && item.isOfClassType(Product.self) {
                
            } else if object.isOfClassType(ProducerManagedObject) && item.isOfClassType(Producer.self) {
                
            } else if object.isOfClassType(Category) && item.isOfClassType(Category.self) {
                
            }

        }

    }
    
    func insertItem(item: AnyObject, toEntity: String) {
        guard let managedObjectContext = self.managedObjectContext else {
            return
        }
        
        let object = NSEntityDescription.insertNewObjectForEntityForName(toEntity, inManagedObjectContext: managedObjectContext) as? ItemManagedObject

        if item is ProductInStock {
            let item = item as! ProductInStock
            object?.setValue(item.id, forKey: "id")
            object?.setValue(item.companyID, forKey: "companyID")
            object?.setValue(item.locationID, forKey: "locationID")
            object?.setValue(item.name, forKey: "name")
            object?.setValue(item.detailName, forKey: "detailName")
            object?.setValue(item.type, forKey: "type")
            object?.setValue(item.price, forKey: "price")
            object?.setValue(item.volume, forKey: "volume")
            object?.setValue(item.package, forKey: "package")
            object?.setValue(item.year, forKey: "year")
            object?.setValue(item.alcohol, forKey: "alcohol")
            object?.setValue(item.organic, forKey: "organic")
        } else if item is Product {
            let item = item as! Product
            object?.setValue(item.id, forKey: "id")
            object?.setValue(item.name, forKey: "name")
            object?.setValue(item.type, forKey: "type")
            object?.setValue(item.status, forKey: "status")
            object?.setValue(item.companyID, forKey: "companyID")
        } else if item is Producer {
            let item = item as! Producer
            object?.setValue(item.id, forKey: "id")
            object?.setValue(item.name, forKey: "name")
            object?.setValue(item.country, forKey: "country")
            object?.setValue(item.notes, forKey: "notes")
            object?.setValue(item.tag, forKey: "tag")
            object?.setValue(item.status, forKey: "status")
            object?.setValue(item.doesWine, forKey: "doesWine")
            object?.setValue(item.doesBeer, forKey: "doesBeer")
            object?.setValue(item.doesLiquor, forKey: "doesLiquor")
        } else if item is Location {
            let item = item as! Location
            object?.setValue(item.id, forKey: "id")
            object?.setValue(item.locationID, forKey: "locationID")
            object?.setValue(item.storeID, forKey: "storeID")
            object?.setValue(item.name, forKey: "name")
            object?.setValue(item.city, forKey: "city")
        } else if item is Store {
            let item = item as! Store
            object?.setValue(item.id, forKey: "id")
            object?.setValue(item.name, forKey: "name")
            object?.setValue(item.address, forKey: "address")
            object?.setValue(item.postalCode, forKey: "postalCode")
            object?.setValue(item.city, forKey: "city")
            object?.setValue(item.county, forKey: "county")
            object?.setValue(item.phone, forKey: "phone")
            object?.setValue(item.rawOpenHours, forKey: "openHours")
        } else if item is Category {
            let item = item as! Category
            object?.setValue(item.id, forKey: "id")
            object?.setValue(item.tag, forKey: "tag")
            object?.setValue(item.name, forKey: "name")
            object?.setValue(item.title, forKey: "title")
            object?.setValue(item.count, forKey: "count")
        }
    }
    
    func doesObjectExist(id: Int, entityName: String) -> Bool {
        if let _ = self.fetchObjectWithId(id, inEntity: entityName) as? ItemManagedObject {
            return true
        }

        return false
    }
    
    func fetchObjectWithId(id: Int, inEntity entity: String) -> AnyObject? {
        guard let managedObjectContext = self.managedObjectContext else {
            return nil
        }
        
        let result: AnyObject?
        let request = NSFetchRequest(entityName: entity)
        let predicate = NSPredicate(format: "id = %i", id)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let results = try managedObjectContext.executeFetchRequest(request)
            result = (results.count > 0) ? results[0] : nil
        } catch  {
            return nil
        }
        
        return result
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
    */