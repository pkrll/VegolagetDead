//
//  Store.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class Store: Item {

  let address: String
  let postalCode: String
  let city: String
  let county: String
  let phone: String
  let openHours: String
  var dateTime: [DateTime]

  override init(var data: JSON) {
    data["id"] = data["storeID"]
    self.address = data["address"].stringValue.capitalizedString
    self.postalCode = data["postalCode"].stringValue
    self.city = data["city"].stringValue.capitalizedString
    self.county = data["county"].stringValue.capitalizedString
    self.phone = data["phone"].stringValue
    self.openHours = data["openHours"].stringValue
    self.dateTime = []
    // Parse open hours
    if self.openHours.isEmpty == false {
      let array = self.openHours.componentsSeparatedByString("!")
      for date in array {
        let dateComponents = date.componentsSeparatedByString(";")
        if dateComponents.count > 0 {
          let date = dateComponents[0]
          let hour = dateComponents[1]
          self.dateTime.append(DateTime(date: date, time: hour))
        }
      }
      
      self.dateTime.sortInPlace { $0.0.date < $0.1.date }
    }
    
    super.init(data: data)
  }
  
}
