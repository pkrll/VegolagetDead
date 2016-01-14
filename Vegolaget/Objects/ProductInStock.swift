//
//  ProductInStock.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class ProductInStock: Product {
    
    let locationID: Int
    let detailName: String
    let price: Double
    let volume: Double
    let package: String
    let year: Int
    let alcohol: Double
    let organic: Bool
    
    override init(data: JSON) {
        self.locationID = data["locationID"].intValue
        self.detailName = data["detailName"].stringValue
        self.price = data["price"].doubleValue
        self.volume = data["volume"].doubleValue
        self.package = data["package"].stringValue
        self.year = data["year"].intValue
        self.alcohol = data["alcohol"].doubleValue
        self.organic = data["organic"].boolValue
        
        super.init(data: data)
    }
    
}
