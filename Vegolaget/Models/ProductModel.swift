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
        self.coreDataEntity = .Location
        self.endPoint = APIEndPoint.Product.withId(locationID)
    }
    
    override func didLoadFromCoreData(data: [AnyObject]) -> [Item] {
        var items: [Stock] = []
        
//        if let locations = data as? [StockManagedObject] {
//            for location in locations {
//                let json = JSON([
//                    "id": location.id,
//                    "name": location.name,
//                    "locationID": location.locationID
//                    ])
//                let item = self.createItem(json) as! Location
//                items.append(item)
//            }
//        }
        
        return items
    }
 
    override func createItem(json: JSON) -> Item {
        return Stock(data: json)
    }
    
}