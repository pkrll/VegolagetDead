//
//  ProductModel.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class ProductModel: Model {

    init(locationID: Int) {
        super.init()
        self.coreDataEntity = .Location
        self.endPoint = APIEndPoint.Product.withId(locationID)
    }

    override func saveData(data: [Item]) {
        var locations = [Location]()
        var stores = [Store]()
        // The API returns a Store object, but we want to create two different objects out of it.
        for item in data {
            if item is Location {
                locations.append(item as! Location)
            } else {
                stores.append(item as! Store)
            }
        }
        
        self.dataController.insertAndUpdateItems(locations, inEntity: CoreDataEntities.Location.rawValue)
        self.dataController.insertAndUpdateItems(stores, inEntity: CoreDataEntities.Store.rawValue)
    }
    
    override func didLoadFromCoreData(data: [AnyObject]) -> [Item] {
        var locations = [Location]()

        if let items = data as? [ItemManagedObject] {
            for item in items {
                if item is LocationManagedObject {
                    let json = JSON([
                            "id": item.id,
                            "name": item.name,
                            "locationID": (item as! LocationManagedObject).locationID
                        ])
                    let location = self.createItem(json) as! Location
                    locations.append(location)
                }
            }
            
        }
        
        return locations
    }
 
    override func parseResponseData(data: NSData?) -> [Item] {
        var list = [Item]()
        
        if let data = data {
            let data = JSON(data: data)
            
            for (_, json): (String, JSON) in data {
                let location = Location(data: json)
                list.append(location)
                
                let store = Store(data: json)
                list.append(store)
            }
        }
        
        return list
    }

    override func createItem(json: JSON) -> Item {
        return Location(data: json)
    }
    
    override func willPassDataToDelegate(data: [Item]) {
        let data = data.filter { $0 is Location }
        super.willPassDataToDelegate(data)
    }
    
}