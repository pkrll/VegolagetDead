//
//  Weekday.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

enum WeekDay: Int {
    
    case Sunday = 1
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    
    var localized: String {
        var weekDay: String!
        
        switch (self) {
        case .Sunday:
            weekDay = "Söndag"
        case .Monday:
            weekDay = "Måndag"
        case .Tuesday:
            weekDay = "Tisdag"
        case .Wednesday:
            weekDay = "Onsdag"
        case .Thursday:
            weekDay = "Torsdag"
        case .Friday:
            weekDay = "Fredag"
        case .Saturday:
            weekDay = "Lördag"
        }
        
        return weekDay
    }
    
}
