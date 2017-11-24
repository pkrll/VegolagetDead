//
//  Weekday.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 09/02/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

enum WeekDay: Int {
  
  case sunday = 1
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
  
  var description: String {
    var weekDay: String!
    
    switch (self) {
    case .sunday:
      weekDay = "Sunday"
    case .monday:
      weekDay = "Monday"
    case .tuesday:
      weekDay = "Tuesday"
    case .wednesday:
      weekDay = "Wednesday"
    case .thursday:
      weekDay = "Thursday"
    case .friday:
      weekDay = "Friday"
    case .saturday:
      weekDay = "Saturday"
    }
    
    return weekDay
  }
  
}
