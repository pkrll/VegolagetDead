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
    
    let address: String
    let postalCode: String
    let city: String
    let county: String
    let phone: String
    var openHours: [DateTime]
    
    override init(data: JSON) {
        self.address = data["address"].stringValue.capitalizedString
        self.postalCode = data["address3"].stringValue
        self.city = data["address4"].stringValue.capitalizedString
        self.county = data["address5"].stringValue.capitalizedString
        self.phone = data["phone"].stringValue
        self.openHours = []
        // Parse open hours
        let openHours = data["openHours"].stringValue
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

        super.init(data: data)

    }
    
}
