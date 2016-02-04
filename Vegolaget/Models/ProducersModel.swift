//
//  ProducersModel.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 13/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class ProducersModel: Model {
  
  override init() {
    super.init()
    self.coreDataEntity = .Producer
    self.endPoint = APIEndPoint.producer()
  }
  
  override func loadData() {
    if let lastUpdate = Settings.valueForKey("lastUpdate") as? NSDate where DateTime.daysSince(lastUpdate) < 2 {
      super.loadData()
    } else {
      self.refreshData()
    }
  }
  
  override func saveData(data: [Item]) {
    super.saveData(data)
    Settings.set(Value: NSDate(), forKey: "lastUpdate")
  }
  
  override func didLoadFromCoreData(data: [AnyObject]) -> [Item] {
    var items: [Producer] = []
    
    if let producers = data as? [ProducerManagedObject] {
      for producer in producers {
        let json = JSON(
          [
            "id": producer.id,
            "name": producer.name,
            "country": producer.country,
            "tag": producer.tag,
            "vegan": producer.vegan,
            "doesBeer": producer.doesBeer,
            "doesWine": producer.doesWine,
            "doesLiquor": producer.doesLiquor
          ]
        )
        
        let item = self.createItem(json) as! Producer
        items.append(item)
      }
    }
    
    return items
  }
  
  override func createItem(json: JSON) -> Item {
    return Producer(data: json)
  }
  
  override func willPassDataToDelegate(data: [Item]) {
    var data = data
    // The model will, for various reasons, fetch all three categories (wine, beer, liquor) at once. This will make sure only the correct category show upon first fetch, depending on the predicate set in the different sub classes of Producers Model.
    // * Only when fetched via the API.
    if let predicate = self.coreDataPredicate {
      data = data.filter { predicate.evaluateWithObject($0) }
    }
    
    super.willPassDataToDelegate(data)
  }
  
}