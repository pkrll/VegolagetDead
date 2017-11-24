//
//  Month.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 09/02/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

enum Month: Int {
  
  case january = 1
  case february
  case march
  case april
  case may
  case june
  case july
  case august
  case september
  case october
  case november
  case december
  
  var description: String {
    var month: String!
    
    switch (self) {
    case .january:
      month = "January"
    case .february:
      month = "February"
    case .march:
      month = "March"
    case .april:
      month = "April"
    case .may:
      month = "May"
    case .june:
      month = "June"
    case .july:
      month = "July"
    case .august:
      month = "August"
    case .september:
      month = "September"
    case .october:
      month = "October"
    case .november:
      month = "November"
    case .december:
      month = "December"
    }
    
    return month
  }
}
