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
        self.coreDataEntity = .Category
        self.endPoint = APIEndPoint.Categories.Root.string
    }
    
    override func didLoadFromCoreData(data: [AnyObject]) -> [Item] {
        var items: [Category] = []
        
        if let categories = data as? [CategoryManagedObject] {
            for category in categories {
                let json = JSON(
                    [
                        "id": category.id,
                        "tag": category.tag,
                        "name": category.name,
                        "title": category.title,
                        "count": category.count
                    ]
                )
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