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
    
    override init(data: JSON) {
        self.locationID = data["locationID"].intValue
        super.init(data: data)
    }
    
}


class Stock: Item {
    
    let locationID: Int
    let storeID: Int

    override init(data: JSON) {
        self.locationID = data["locationID"].intValue
        self.storeID = data["storeID"].intValue
        super.init(data: data)
    }
    
}