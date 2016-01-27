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
  
  var description: String {
    var month: String!
    
    switch (self) {
      case .January:
        month = "January"
      case .February:
        month = "February"
      case .March:
        month = "March"
      case .April:
        month = "April"
      case .May:
        month = "May"
      case .June:
        month = "June"
      case .July:
        month = "July"
      case .August:
        month = "August"
      case .September:
        month = "September"
      case .October:
        month = "October"
      case .November:
        month = "November"
      case .December:
        month = "December"
    }
    
    return month
  }
}