//
//  Weekday.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 09/02/16.
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
  
  var description: String {
    var weekDay: String!
    
    switch (self) {
    case .Sunday:
      weekDay = "Sunday"
    case .Monday:
      weekDay = "Monday"
    case .Tuesday:
      weekDay = "Tuesday"
    case .Wednesday:
      weekDay = "Wednesday"
    case .Thursday:
      weekDay = "Thursday"
    case .Friday:
      weekDay = "Friday"
    case .Saturday:
      weekDay = "Saturday"
    }
    
    return weekDay
  }
  
}