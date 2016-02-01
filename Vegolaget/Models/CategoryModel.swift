//
//  CategoryModel.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class CategoryModel: Model {
  
  override init() {
    super.init()
    self.coreDataSortKeys = ["id"]
    self.coreDataEntity = .Category
    self.endPoint = APIEndPoint.Category.Root.string
  }
  
  override func didLoadFromCoreData(data: [AnyObject]) -> [Item] {
    var items: [Category] = []
    
    if let categories = data as? [CategoryManagedObject] {
      for category in categories {
        let json = JSON([
          "id": category.id as Int,
          "tag": category.tag as String,
          "name": category.name as String,
          "title": category.title as String,
          "count": category.count as Int
          ])
        let item = self.createItem(json) as! Category
        items.append(item)
      }
    }
    
    return items
  }
  
  override func createItem(json: JSON) -> Item {
    return Category(data: json)
  }
  
}