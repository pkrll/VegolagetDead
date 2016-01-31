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
  let vegan: Int
  let tag: String
  let doesWine: Bool
  let doesBeer: Bool
  let doesLiquor: Bool
  
  lazy var isVegan: Bool = {
    return (self.vegan == 1)
  }()
  
  override init(data: JSON) {
    self.country = data["country"].stringValue
    self.vegan = data["vegan"].intValue
    self.tag = data["tag"].stringValue
    self.doesWine = data["doesWine"].boolValue
    self.doesBeer = data["doesBeer"].boolValue
    self.doesLiquor = data["doesLiquor"].boolValue
    
    super.init(data: data)
  }
  
}