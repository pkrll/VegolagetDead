//
//  Store.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class Store: Item {
    
    let locationID: NSNumber
    let address: String
    let postalCode: String
    let city: String
    let county: String
    let phone: String
    var openHours: [DateTime]
    let rawOpenHours: String
    
    override init(data: JSON) {
        self.locationID = data["locationID"].intValue
        self.address = data["address"].stringValue.capitalizedString
        self.postalCode = data["postalCode"].stringValue
        self.city = data["city"].stringValue.capitalizedString
        self.county = data["county"].stringValue.capitalizedString
        self.phone = data["phone"].stringValue
        self.openHours = []
        // Parse open hours
        let openHours = data["openHours"].stringValue
        if openHours.isEmpty == false {
            let array = openHours.componentsSeparatedByString("!")
            for date in array {
                let dateComponents = date.componentsSeparatedByString(";")
                if dateComponents.count > 0 {
                    let date = dateComponents[0]
                    let hour = dateComponents[1]
                    self.openHours.append(DateTime(date: date, time: hour))
                }
            }
            
            self.openHours.sortInPlace { $0.0.date < $0.1.date }
        }
        
        self.rawOpenHours = openHours
        
        super.init(data: data)
    }
    
}
