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
  
  let locationID: Int
  
  init(locationID: Int) {
    self.locationID = locationID
    super.init()
    self.coreDataEntity = .Location
    self.coreDataPredicate = NSPredicate(format: "locationID = %i", self.locationID)
    self.endPoint = APIEndPoint.storesWithProductInStock(withLocationId: locationID)
  }
  
  override func saveData(data: [Item]) {
    var locations = [Location]()
    var stores = [Store]()
    // Save both the Stores and Locations object.
    for item in data {
      if item is Location {
        locations.append(item as! Location)
      } else {
        stores.append(item as! Store)
      }
    }
    
    self.coreDataHelper.save(locations, toEntity: Entities.Location.rawValue)
    self.coreDataHelper.save(stores, toEntity: Entities.Store.rawValue)
  }
  
  override func didLoadFromCoreData(data: [AnyObject]) -> [Item] {
    var list = [Location]()
    
    if let items = data as? [ItemManagedObject] {
      for item in items {
        if item is LocationManagedObject {
          let json = JSON([
            "id": item.id,
            "locationID": (item as! LocationManagedObject).locationID,
            "storeID": (item as! LocationManagedObject).storeID,
            "city": (item as! LocationManagedObject).city,
            "name": (item as! LocationManagedObject).name
            ])
          let location = Location(data: json)
          list.append(location)
        }
      }
    }
    
    return list
  }
  
  override func parseResponseData(data: NSData?) -> [Item] {
    var list = [Item]()
    
    if let data = data {
      let data = JSON(data: data)
      
      for (_, value) in data {
        for (_, json): (String, JSON) in value {
          // The API returns a JSON object with the stores information, but we want to create two different objects out of it. Create both the Store object, but also the Location object from parts of the Store information that will be used by this model's controller.
          let location = Location(data: json)
          list.append(location)
          let store = Store(data: json)
          list.append(store)
        }
      }
    }
    
    return list
  }
  
  override func willPassDataToDelegate(data: [Item]) {
    // Only the Location objects should be passed on. Disregard the Store objects, as they now have been saved.
    let data = data.filter { $0 is Location }
    super.willPassDataToDelegate(data)
  }
  
}