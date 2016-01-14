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

    private var locationID: Int
    
    init(locationID: Int) {
        self.locationID = locationID
        super.init()
        self.endPoint = APIEndPoint.Product.withId(self.locationID)
    }
    
    override func createItem(json: JSON) -> Item {
        return Store(data: json)
    }
    
}