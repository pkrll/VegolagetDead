//
//  Producer.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 13/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class Producer: Item {
  
  let country: String
  let status: String
  let notes: String
  let tag: String
  let doesWine: Bool
  let doesBeer: Bool
  let doesLiquor: Bool
  
  lazy var isVegan: Bool = {
    return (self.status == "Vegan Friendly")
  }()
  
  override init(data: JSON) {
    self.country = data["country"].stringValue
    self.status = data["status"].stringValue
    self.notes = data["notes"].stringValue
    self.tag = data["tag"].stringValue
    self.doesWine = data["doesWine"].boolValue
    self.doesBeer = data["doesBeer"].boolValue
    self.doesLiquor = data["doesLiquor"].boolValue
    
    super.init(data: data)
  }
  
}