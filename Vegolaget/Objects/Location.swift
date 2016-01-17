//
//  Location.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 15/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class Location: Item {

    let locationID: Int
    let storeID: Int
    let city: String
    
    override init(var data: JSON) {
        data["id"] = data["storeID"]
        self.locationID = data["locationID"].intValue
        self.storeID = data["storeID"].intValue
        self.city = data["city"].stringValue.capitalizedString
        super.init(data: data)
    }
    
}