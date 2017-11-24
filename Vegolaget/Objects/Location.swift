//
//  Location.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 15/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class Location: Item {
  
  let locationID: Int
  let storeID: Int
  let city: String
  
  override init(data: JSON) {
    var data = data
    self.locationID = data["locationID"].intValue
    self.storeID = data["storeID"].intValue
    self.city = data["city"].stringValue
    // The id of the location in the database should be a mix of the two, if there is no one
    if data["id"].intValue == 0 {
      data["id"] = JSON(integerLiteral: data["storeID"].intValue + data["locationID"].intValue)
    }
    
    super.init(data: data)
  }
  
}
