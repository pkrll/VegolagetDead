//
//  StoresModel.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 15/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class StoresModel: Model {
  
  let locations: [Location]
  
  init(locations: [Location]) {
    self.locations = locations
    super.init()
    self.coreDataEntity = .Store
    self.endPoint = APIEndPoint.Store.City.string
  }
  
  override func saveData(data: [Item]) {
    if let entity = self.coreDataEntity?.rawValue {
      self.coreDataHelper.save(data, toEntity: entity)
    }
  }
  
  override func didLoadFromCoreData(data: [AnyObject]) -> [Item] {
    var items: [Store] = []
    
    if let stores = data as? [StoreManagedObject] {
      for store in stores {
        
        let json = JSON([
          "id": store.id,
          "name": store.name,
          "address": store.address,
          "postalCode": store.postalCode,
          "city": store.city,
          "county": store.county,
          "phone": store.phone,
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