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
  
  private let dateFormat = "yyyy-MM-dd"
  private let dateLocale = "se"
  private let dateFormatter: NSDateFormatter
  
  init(date: String, time: String) {
    self.date = date
    self.time = time
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = self.dateFormat
    dateFormatter.locale = NSLocale(localeIdentifier: self.dateLocale)
    
    let todayString = dateFormatter.stringFromDate(NSDate())
    let definedDate = dateFormatter.dateFromString(self.date) as NSDate!
    let compareDate = dateFormatter.dateFromString(todayString) as NSDate!
    let comparision = compareDate.compare(definedDate).rawValue
    
    self.isToday = comparision == 0
    self.hasPassed = comparision > 0
    
    self.dateFormatter = dateFormatter
  }
  
  func weekDay() -> String {
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let date = self.dateFormatter.dateFromString(self.date) as NSDate!
    let components = calendar.components(.Weekday, fromDate: date)
    
    return WeekDay(rawValue: components.weekday)?.description ?? ""
  }
  
  func month() -> String {
    let components = self.date.componentsSeparatedByString("-")
    let month = Month(rawValue: Int(components[1])!)?.description ?? ""
    return month
  }
  
  func day() -> String {
    let components = self.date.componentsSeparatedByString("-")
    if components[2].characters.first == "0" {
      let range = Range(start: components[2].startIndex.advancedBy(1), end: components[2].endIndex)
      return components[2].substringWithRange(range)
    }
    
    return components[2]
  }
  
  static func daysSince(fromDate: NSDate) -> Int {
    let toDate = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components(NSCalendarUnit.Day, fromDate: fromDate, toDate: toDate, options: [])
    
    return components.day
  }
  
}