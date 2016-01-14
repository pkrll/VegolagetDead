//
//  Month.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

enum Month: Int {
    
    case January = 1
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
    case October
    case November
    case December
    
    var localized: String {
        var month: String!
        
        switch (self) {
        case .January:
            month = "januari"
        case .February:
            month = "februari"
        case .March:
            month = "mars"
        case .April:
            month = "april"
        case .May:
            month = "maj"
        case .June:
            month = "juni"
        case .July:
            month = "juli"
        case .August:
            month = "augusti"
        case .September:
            month = "september"
        case .October:
            month = "oktober"
        case .November:
            month = "november"
        case .December:
            month = "december"
        }
        
        return month
    }
}