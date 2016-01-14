//
//  Product.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class Product: Item {
    
    let companyID: Int
    let status: String
    let type: String
    
    override init(data: JSON) {
        self.companyID = data["companyID"].intValue
        self.status = data["status"].stringValue
        self.type = data["type"].stringValue
        
        super.init(data: data)
    }
    
}
