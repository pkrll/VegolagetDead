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
  let store: Store?
  
  init(store: Store) {
    self.store = store
    self.storeID = store.id
    super.init()
    self.coreDataEntity = CoreDataEntities.Store
    self.coreDataPredicate = NSPredicate(format: "id = %i", self.storeID)
    self.endPoint = APIEndPoint.store(withId: store.id)
  }
  
  init(storeID: Int) {
    self.store = nil
    self.storeID = storeID
    super.init()
    self.coreDataEntity = CoreDataEntities.Store
    self.coreDataPredicate = NSPredicate(format: "id = %i", storeID)
    self.endPoint = APIEndPoint.store(withId: storeID)
  }
  
  override func loadData() {
    guard let store = self.store else {
      super.loadData()
      return
    }
    
    self.willPassDataToDelegate([store])
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

    return items
  }
  
  override func createItem(json: JSON) -> Item {
    return Store(data: json)
  }
  
}