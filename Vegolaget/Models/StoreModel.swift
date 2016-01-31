//
//  StoreModel.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 22/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class StoreModel: Model {
  
  let storeID: Int
  
  init(storeID: Int) {
    self.storeID = storeID
    super.init()
    self.coreDataEntity = CoreDataEntities.Store
    self.coreDataPredicate = NSPredicate(format: "id = %i", storeID)
    self.endPoint = APIEndPoint.Store.withId(storeID)
  }
  
  override func didLoadFromCoreData(data: [AnyObject]) -> [Item] {
    var items = [Store]()
    
    if let stores = data as? [StoreManagedObject] {
      for store in stores {
        
        let json = JSON([
          "id": store.id,
          "name": store.name,
          "address": store.address,
          "postalCode": store.postalCode,
          "city": store.city,
          "county": store.county,
          "openHours": store.openHours
        ])
        
        let item = self.createItem(json) as! Store
        items.append(item)
      }
    }
    
    print(items)

    return items
  }
  
  override func createItem(json: JSON) -> Item {
    return Store(data: json)
  }
  
}