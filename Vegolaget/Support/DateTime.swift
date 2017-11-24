//
//  Date.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

struct DateTime {
  
  let date: String
  let time: String
  let isToday: Bool
  let hasPassed: Bool
  
  fileprivate let dateFormat = "yyyy-MM-dd"
  fileprivate let dateLocale = "se"
  fileprivate let dateFormatter: DateFormatter
  
  init(date: String, time: String) {
    self.date = date
    self.time = time
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = self.dateFormat
    dateFormatter.locale = Locale(identifier: self.dateLocale)
    
    let todayString = dateFormatter.string(from: Date())
    let definedDate = dateFormatter.date(from: self.date) as Date!
    let compareDate = dateFormatter.date(from: todayString) as Date!
    let comparision = compareDate?.compare(definedDate!).rawValue
    
    self.isToday = comparision == 0
    self.hasPassed = comparision! > 0
    
    self.dateFormatter = dateFormatter
  }
  
  func weekDay() -> String {
    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    let date = self.dateFormatter.date(from: self.date) as Date!
    let components = (calendar as NSCalendar).components(.weekday, from: date!)
    
    return WeekDay(rawValue: components.weekday!)?.description ?? ""
  }
  
  func month() -> String {
    let components = self.date.components(separatedBy: "-")
    let month = Month(rawValue: Int(components[1])!)?.description ?? ""
    return month
  }
  
  func day() -> String {
    let components = self.date.components(separatedBy: "-")
    if components[2].characters.first == "0" {
      let range = (components[2].characters.index(components[2].startIndex, offsetBy: 1) ..< components[2].endIndex)
      return components[2].substring(with: range)
    }
    
    return components[2]
  }
  
  static func daysSince(_ fromDate: Date) -> Int {
    let toDate = Date()
    let calendar = Calendar.current
    let components = (calendar as NSCalendar).components(NSCalendar.Unit.day, from: fromDate, to: toDate, options: [])
    
    return components.day!
  }
  
}
