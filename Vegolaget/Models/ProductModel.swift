//
//  ProductModel.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class ProductModel: Model {

    init(locationID: Int) {
        super.init()
        self.coreDataEntity = .Store
        self.endPoint = APIEndPoint.Product.withId(locationID)
    }
    
    override func didLoadFromCoreData(data: [AnyObject]) -> [Item] {
        var items: [Store] = []
        
        if let stores = data as? [StoresManagedObject] {
            for store in stores {
                let json = JSON(
                    [
                        "id": store.id,
                        "name": store.name,
                        "locationID": store.locationID
                    ]
                )
                
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