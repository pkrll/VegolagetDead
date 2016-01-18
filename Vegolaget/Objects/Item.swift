//
//  Item.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class Item: CoreDataHelperItem {
  
  let id: Int
  let name: String
  
  init(data: JSON) {
    self.id = data["id"].intValue
    self.name = data["name"].stringValue.capitalizedString
    
    super.init()
  }

}
